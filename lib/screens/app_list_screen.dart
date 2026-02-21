import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../models/risk_level.dart';
import '../services/permission_service.dart';
import '../widgets/app_card.dart';
import '../utils/constants.dart';
import 'app_detail_screen.dart';
import 'dashboard_screen.dart';
import 'education_screen.dart';

class AppListScreen extends StatefulWidget {
  const AppListScreen({super.key});

  @override
  State<AppListScreen> createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  final PermissionService _permissionService = PermissionService();
  List<AppInfo> _allApps = [];
  List<AppInfo> _filteredApps = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _loadedCount = 0;
  int _totalCount = 0;
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'risk', 'permissions'
  bool _showSystemApps = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loadedCount = 0;
      _totalCount = 0;
    });

    try {
      final apps = await _permissionService.getInstalledApps();

      if (!mounted) return;
      setState(() => _totalCount = apps.length);

      // Fetch permissions for all apps to calculate risk
      List<AppInfo> appsWithRisk = [];
      for (var app in apps) {
        try {
          final appWithPerms = await _permissionService.getAppWithPermissions(app);
          appsWithRisk.add(appWithPerms);
        } catch (_) {
          appsWithRisk.add(app);
        }
        if (!mounted) return;
        setState(() => _loadedCount = appsWithRisk.length);
      }

      if (!mounted) return;
      setState(() {
        _allApps = appsWithRisk;
        _filteredApps = appsWithRisk;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load apps: $e';
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredApps = _allApps.where((app) {
        // Filter by search query
        if (_searchQuery.isNotEmpty &&
            !app.appName.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
        
        // Filter system apps
        if (!_showSystemApps && app.isSystemApp) {
          return false;
        }
        
        return true;
      }).toList();
      
      // Sort
      switch (_sortBy) {
        case 'name':
          _filteredApps.sort((a, b) => a.appName.compareTo(b.appName));
          break;
        case 'risk':
          _filteredApps.sort((a, b) {
            final riskOrder = {RiskLevel.high: 0, RiskLevel.medium: 1, RiskLevel.low: 2};
            return (riskOrder[a.riskLevel] ?? 3).compareTo(riskOrder[b.riskLevel] ?? 3);
          });
          break;
        case 'permissions':
          _filteredApps.sort((a, b) => b.permissionCount.compareTo(a.permissionCount));
          break;
      }
    });
  }

  Widget _buildAppListTab() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              _totalCount > 0
                  ? 'Analyzing apps... ($_loadedCount / $_totalCount)'
                  : 'Scanning installed apps...',
              style: const TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 14,
              ),
            ),
            if (_totalCount > 0) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: LinearProgressIndicator(
                  value: _loadedCount / _totalCount,
                  backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppConstants.errorColor, size: 64),
              const SizedBox(height: 16),
              Text(
                'Could not load apps',
                style: const TextStyle(
                  color: AppConstants.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadApps,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: TextField(
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _applyFilters();
            },
            style: const TextStyle(color: AppConstants.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search apps...',
              hintStyle: TextStyle(color: AppConstants.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppConstants.primaryColor),
              filled: true,
              fillColor: AppConstants.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Name'),
                selected: _sortBy == 'name',
                onSelected: (_) {
                  setState(() => _sortBy = 'name');
                  _applyFilters();
                },
                selectedColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: _sortBy == 'name' ? Colors.white : AppConstants.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Risk Level'),
                selected: _sortBy == 'risk',
                onSelected: (_) {
                  setState(() => _sortBy = 'risk');
                  _applyFilters();
                },
                selectedColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: _sortBy == 'risk' ? Colors.white : AppConstants.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Permissions'),
                selected: _sortBy == 'permissions',
                onSelected: (_) {
                  setState(() => _sortBy = 'permissions');
                  _applyFilters();
                },
                selectedColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: _sortBy == 'permissions' ? Colors.white : AppConstants.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(_showSystemApps ? 'Hide System' : 'Show System'),
                selected: false,
                onSelected: (_) {
                  setState(() => _showSystemApps = !_showSystemApps);
                  _applyFilters();
                },
                labelStyle: const TextStyle(color: AppConstants.textSecondary),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // App List
        Expanded(
          child: _filteredApps.isEmpty
              ? Center(
                  child: Text(
                    'No apps found',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadApps,
                  color: AppConstants.primaryColor,
                  child: ListView.builder(
                    itemCount: _filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = _filteredApps[index];
                      return AppCard(
                        app: app,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppDetailScreen(app: app),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildAppListTab(),
      DashboardScreen(apps: _allApps),
      const EducationScreen(),
    ];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'App Permission Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 0,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: AppConstants.surfaceColor,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
        ],
      ),
    );
  }
}
