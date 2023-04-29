import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/pages/dashboard/dashboard_page.dart';
import 'package:myapp/setup/pre_router_widget.dart';

class DashboardAccountPage extends StatelessWidget {
  const DashboardAccountPage({
    required this.getPreRouterWidgetState,
    super.key,
  });

  final PreRouterWidgetState? Function(BuildContext) getPreRouterWidgetState;

  @override
  Widget build(BuildContext context) {
    // precondition
    assert(
      getPreRouterWidgetState(context) != null &&
          getPreRouterWidgetState(context)!.mounted,
    );

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
          Text(
            "Dashboard Home Page: ${DashboardPage.of(context)!.getCurrentPageIndex}",
          ),
          const Spacer(flex: 1),
          SwitchListTile(
            controlAffinity: ListTileControlAffinity.leading,
            // This bool value toggles the switch.
            value: getPreRouterWidgetState(context)!.getCrashlyticsEnabled(),
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              getPreRouterWidgetState(context)!
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
            value: getPreRouterWidgetState(context)!.getHighContrast(),
            onChanged: (bool value) {
              getPreRouterWidgetState(context)!
                  .setHighContrast(highContrast: value);
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
                  getPreRouterWidgetState(context)!.getTheme().index == 0,
                  getPreRouterWidgetState(context)!.getTheme().index == 1,
                  getPreRouterWidgetState(context)!.getTheme().index == 2,
                ],
                onPressed: (int index) {
                  getPreRouterWidgetState(context)!.setTheme(
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
        ],
      ),
    );
  }
}
