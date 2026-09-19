import 'package:flutter/material.dart';
import 'package:frontend_userside/core/utils/responsive_utils.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_sidebar.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_top_bar.dart';

class UserLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const UserLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<UserLayout> createState() => _UserLayoutState();
}

class _UserLayoutState extends State<UserLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            UserSidebar(currentRoute: widget.currentRoute),
            Expanded(
              child: Column(
                children: [
                  const UserTopBar(),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: UserSidebar(
          currentRoute: widget.currentRoute,
          onItemTapped: () => _scaffoldKey.currentState?.closeDrawer(),
        ),
      ),
      body: Column(
        children: [
          UserTopBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
