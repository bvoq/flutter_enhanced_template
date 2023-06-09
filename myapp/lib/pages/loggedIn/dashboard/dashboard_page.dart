import 'package:flutter/material.dart';
import 'package:myapp/router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.child,
    required this.pageIndex,
    super.key,
  });
  final Widget child;
  final int pageIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (index) => onItemTapped(context, index),
      ),
    );
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        const DashboardHomeRouteData().go(context);
      case 1:
        const DashboardAccountRouteData().go(context);
      default:
    }
  }
}
