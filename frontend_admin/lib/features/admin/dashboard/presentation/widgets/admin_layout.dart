import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/constants/app_constants.dart';
import 'admin_sidebar.dart';
import 'admin_top_bar.dart';

class AdminLayout extends StatefulWidget {
  final String title;
  final String currentPath;
  final Widget child;

  const AdminLayout({
    super.key,
    required this.title,
    required this.currentPath,
    required this.child,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppConstants.mobileBreakpoint;
    final isTablet =
        width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;

    // Automatically collapse on tablet if not explicitly set
    final shouldCollapse = isTablet || _isCollapsed;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundLight,
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.sidebarBackground,
              child: AdminSidebar(
                currentPath: widget.currentPath,
                isCollapsed: false,
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar for Desktop and Tablet
          if (!isMobile)
            AdminSidebar(
              currentPath: widget.currentPath,
              isCollapsed: shouldCollapse,
              onToggleCollapse: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                AdminTopBar(
                  title: widget.title,
                  showMenuButton: isMobile || isTablet,
                  onMenuPressed: () {
                    if (isMobile) {
                      _scaffoldKey.currentState?.openDrawer();
                    } else {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    }
                  },
                ),
                Expanded(child: SelectionArea(child: widget.child)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
