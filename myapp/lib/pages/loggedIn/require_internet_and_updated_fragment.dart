import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myapp/pages/loggedIn/force_update_page.dart';
import 'package:myapp/pages/loggedIn/nointernet_page.dart';

class RequiredInternetAndUpdatedShell extends StatelessWidget {
  const RequiredInternetAndUpdatedShell({required this.shellChild, super.key});
  final Widget shellChild;

  Future<bool> hasInternet() async {
    // In case we don't have internet, we want to redirect to the no internet screen.
    final internetConnectivity =
        await InternetConnectionChecker().hasConnection;
    debugPrint("Internet connectivity: $internetConnectivity");
    if (internetConnectivity == false) {
      debugPrint("No internet activity.");
      return false;
    }
    return true;
  }

  /*
  Future<fpdart.Option<UpdateStrategy>> hasUpdatedVersion() async {
    // In case there is a force update we want to redirect to the force update screen.
    final updateStrategy =
        await UpdateCheckerSingleton.getInstance().getUpdateStrategy();
    if (updateStrategy.updateStrategy.shouldShowForceUpdateScreen) {
      debugPrint("Force update detected.");
      return fpdart.Some(updateStrategy);
    }
    return const fpdart.None();
  }*/

  @override
  Widget build(BuildContext context) {
    const Widget awaitingResults = Scaffold(
      body: Text("Loading screen TODO"),
      /*LoadingScreenWithMessageAndImage(
        errorMessageAfterLongLoadingDuration:
            AppLocalizations.of(context)!.progressIndicator_longLoadingErrorMessage,
      ),*/
    );
    return FutureBuilder<bool>(
      future: hasInternet(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data! == false) {
            // No internet page
            return const NoInternetPage();
          }
          return shellChild;
          /*
          return FutureBuilder<fpdart.Option<UpdateStrategy>>(
            future: hasUpdatedVersion(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.isNone()) {
                  return shellChild;
                } else {
                  // Force update page
                  return ForceUpdatePage(
                    updateUrl: snapshot.data!.toNullable()!.updateUrl ??
                        UpdateCheckerSingleton.fallbackUpdateUrl,
                  );
                }
              } else {
                return awaitingResults;
              }
            },
          );*/
        } else {
          return awaitingResults;
        }
      },
    );
  }
}
