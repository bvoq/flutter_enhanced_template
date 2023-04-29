import 'package:flutter/material.dart';
import 'package:myapp/pages/dashboard/dashboard_page.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "Dashboard Home Page: ${DashboardPage.of(context)!.getCurrentPageIndex}",
        ),
      ),
    );
  }
}
