import 'package:common_utils_module/logging/debug_menu_wrapper.dart';
import 'package:common_utils_module/logging/juice_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jplus_pilot/services/update_checker_singleton.dart';
import 'package:jplus_pilot/widgets/full_screen_parallelogram_button.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({required this.updateUrl, super.key});

  final String updateUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
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
                  Lottie.asset(
                    'assets/lottie_animations/background-party.json',
                    width: 250,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Text(
                AppLocalizations.of(context)!.forceUpdatePage_title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Text(
                AppLocalizations.of(context)!.forceUpdatePage_description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: _launchUpdateUrl,
                child: Text(
                  AppLocalizations.of(context)!.forceUpdatePage_button_update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUpdateUrl() async {
    debugPrint('Could not launch $updateUrl on trace ${StackTrace.current}');
  }
}
