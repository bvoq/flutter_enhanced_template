import 'package:flutter/material.dart';
import 'package:myapp/pages/loggedIn/require_internet_and_updated_fragment.dart';

class LoginShell extends StatefulWidget {
  const LoginShell({required this.shellChild, super.key});
  final Widget shellChild;
  @override
  State<LoginShell> createState() => LoginShellState();

  static LoginShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<LoginShellState>();
}

class LoginShellState extends State<LoginShell> {
  String appBarTitle = "OAuth Shell Page";

  void updateTitle(String newTitle) {
    setState(() {
      appBarTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RequiredInternetAndUpdatedShell(
      shellChild: FutureBuilder(
        future: null, //mtlsSession.oauth.getValidAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // No session page, need to sign in here...
            // return const NoSessionWidget();
            return Container();
          } else {
            return widget.shellChild;
          }
        },
      ),
    );
  }
}
