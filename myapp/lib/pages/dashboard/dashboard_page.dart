import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  State<DashboardPage> createState() => DashboardPageState();

  // ignore: library_private_types_in_public_api
  static DashboardPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<DashboardPageState>();
}

class DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  int _currentPageIndex = 0;

  // example of access parent state from child widget.
  int get getCurrentPageIndex => _currentPageIndex;
  void updatePageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
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
    _currentPageIndex = index;
    switch (index) {
      case 0:
        context.goNamed(
          Routes.dashboardHome.name,
        );
        break;
      case 1:
        context.goNamed(
          Routes.dashboardAccount.name,
        );
        break;
      default:
    }
  }
}
