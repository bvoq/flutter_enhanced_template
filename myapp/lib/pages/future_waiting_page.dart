import 'package:flutter/material.dart';

class FutureWaitingExtra<T extends Object> {
  const FutureWaitingExtra({
    required this.future,
    required this.redirect,
    required this.onError,
    this.errorMessageAfterLongLoadingDuration,
  });

  final Future<T> future;
  final void Function(Object completedFuture, BuildContext context) redirect;
  final void Function(Object? error, BuildContext context) onError;

  final String? errorMessageAfterLongLoadingDuration;
}

/// Generic class that takes a redirect and a future and waits for it to complete before calling the next route.
class FutureWaitingPage<T extends Object> extends StatelessWidget {
  const FutureWaitingPage({required this.futureWaitingExtra, super.key});

  final FutureWaitingExtra<T> futureWaitingExtra;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: futureWaitingExtra.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          futureWaitingExtra.redirect(snapshot.data!, context);
        } else if (snapshot.hasError) {
          futureWaitingExtra.onError(snapshot.error, context);
        }
        return const Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Loading ..."),
            ],
          ),
        );
      },
    );
  }
}
