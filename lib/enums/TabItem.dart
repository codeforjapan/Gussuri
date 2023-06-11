import 'package:flutter/material.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/help.dart';
import 'package:gussuri/home.dart';
import 'package:gussuri/print.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TabItem {
  home(
    icon: Icons.home,
    page: Home(),
  ),
  calender(
    icon: Icons.calendar_month,
    page: Calendar(),
  ),
  print(
    icon: Icons.print,
    page: Print(),
  ),
  help(
    icon: Icons.help_outline,
    page: Help(),
  );

  const TabItem({
    required this.icon,
    required this.page,
  });

  final IconData icon;

  final Widget page;
}

extension TabItemExtension on TabItem {
  String title(BuildContext context) {
    switch (this) {
      case TabItem.home:
        return AppLocalizations.of(context)?.home ?? 'ホーム';
      case TabItem.calender:
        return AppLocalizations.of(context)?.calendar ?? 'カレンダー';
      case TabItem.print:
        return AppLocalizations.of(context)?.print ?? '印刷';
      case TabItem.help:
        return AppLocalizations.of(context)?.help ?? 'ヘルプ';
      default:
        return '';
    }
  }
}
