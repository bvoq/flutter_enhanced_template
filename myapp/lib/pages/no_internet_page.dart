//import 'package:common_utils_module/uicomponents/loading_progress_indicator_with_potential_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({
    required this.onInternetConnectionAvailable,
    super.key,
  });

  final void Function() onInternetConnectionAvailable;

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    final loadingProgressIndicator = const CircularProgressIndicator();

    return Scaffold(
      body: Center(
        child: StreamBuilder<InternetConnectionStatus>(
          stream: InternetConnectionChecker().onStatusChange,
          builder: (
            BuildContext context,
            AsyncSnapshot<InternetConnectionStatus> snapshot,
          ) {
            if (!snapshot.hasData || snapshot.data == null) {
              return loadingProgressIndicator;
            }

            final connectivityResult = snapshot.data!;
            if (connectivityResult == InternetConnectionStatus.connected) {
              // This is required! We cannot set state or change route during a build.
              // see: https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                widget.onInternetConnectionAvailable();
              });
            }
            return loadingProgressIndicator;
          },
        ),
      ),
    );
  }
}
