import 'package:flutter/material.dart';

class OAuthShellPage extends StatefulWidget {
  const OAuthShellPage({required this.child, super.key});
  final Widget child;
  @override
  State<OAuthShellPage> createState() => OAuthShellPageState();

  static OAuthShellPageState? of(BuildContext context) => context.findAncestorStateOfType<OAuthShellPageState>();
}

class OAuthShellPageState extends State<OAuthShellPage> {
  String appBarTitle = "OAuth Shell Page";

  void updateTitle(String newTitle) {
    setState(() {
      appBarTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: widget.child,
    );
  }
}
