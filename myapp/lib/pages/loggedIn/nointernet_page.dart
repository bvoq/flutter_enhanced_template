import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({
    super.key,
  });

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    final Widget loadingNoInternetWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/app_icons/j_plus_orange.svg",
                semanticsLabel: 'J+ Logo',
              ),
              Lottie.asset('assets/lottie_animations/cloudy.json', width: 250),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            AppLocalizations.of(context)!
                .progressIndicator_noInternetConnection,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!
                .progressIndicator_noInternetConnectionMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {
              GoRouter.of(context).refresh();
            },
            child: Text(
              AppLocalizations.of(context)!.noInternetPage_button_try_again,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Center(
        child: StreamBuilder<InternetConnectionStatus>(
          stream: InternetConnectionChecker.createInstance(
            checkInterval: const Duration(seconds: 2),
          ).onStatusChange,
          builder: (
            BuildContext context,
            AsyncSnapshot<InternetConnectionStatus> snapshot,
          ) {
            if (!snapshot.hasData || snapshot.data == null) {
              return loadingNoInternetWidget;
            }

            final connectivityResult = snapshot.data!;
            if (connectivityResult == InternetConnectionStatus.connected) {
              // This is required! We cannot set state or change route during a build.
              // see: https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                GoRouter.of(context).refresh();
              });
            }
            return loadingNoInternetWidget;
          },
        ),
      ),
    );
  }
}
