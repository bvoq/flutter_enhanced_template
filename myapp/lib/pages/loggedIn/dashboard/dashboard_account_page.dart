import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/pages/loggedIn/login_shell.dart';
import 'package:myapp/setup/pre_router_widget.dart';

class DashboardAccountPage extends StatelessWidget {
  const DashboardAccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // precondition
    assert(PreRouterWidget.of(context) != null);

    // main
    final themes = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          AppLocalizations.of(context)!.account_page_theme_system,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          AppLocalizations.of(context)!.account_page_theme_light,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          AppLocalizations.of(context)!.account_page_theme_dark,
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(flex: 1),
          const Text(
            "Dashboard Home Page.",
          ),
          const Spacer(flex: 1),
          SwitchListTile(
            controlAffinity: ListTileControlAffinity.leading,
            // This bool value toggles the switch.
            value: PreRouterWidget.of(context)!.getCrashlyticsEnabled(),
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              PreRouterWidget.of(context)!
                  .setCrashlyticsEnabled(crashlyticsEnabled: value);
            },
            title: Text(
              AppLocalizations.of(context)!
                  .account_page_enable_developer_analytics,
            ),
            subtitle: Text(
              AppLocalizations.of(context)!
                  .account_page_enable_developer_analytics_description,
            ),
          ),
          SwitchListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: PreRouterWidget.of(context)!.getHighContrast(),
            onChanged: (bool value) {
              PreRouterWidget.of(context)!.setHighContrast(highContrast: value);
            },
            title: Text(
              AppLocalizations.of(context)!.account_page_enable_high_contrast,
            ),
            subtitle: Text(
              AppLocalizations.of(context)!
                  .account_page_enable_high_contrast_description,
            ),
          ),
          const Spacer(flex: 1),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.account_page_theme_description,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                isSelected: [
                  PreRouterWidget.of(context)!.getTheme().index == 0,
                  PreRouterWidget.of(context)!.getTheme().index == 1,
                  PreRouterWidget.of(context)!.getTheme().index == 2,
                ],
                onPressed: (int index) {
                  PreRouterWidget.of(context)!.setTheme(
                    index == 0
                        ? ThemeMode.system
                        : index == 1
                            ? ThemeMode.light
                            : ThemeMode.dark,
                  );
                },
                children: themes,
              ),
            ],
          ),
          const Spacer(flex: 1),
          IconButton(
            onPressed: () {
              LoginShell.of(context)!.updateTitle('abc');
            },
            icon: const Icon(Icons.abc),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
