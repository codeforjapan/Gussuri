import 'package:flutter/material.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/help.dart';
import 'package:gussuri/home.dart';
import 'package:gussuri/print.dart';

enum TabItem {
  home(
      title: 'ホーム',
      icon: Icons.home,
      page: Home()
  ),
  calender(
      title: 'カレンダー',
      icon: Icons.calendar_month,
      page: Calendar()
  ),
  print(
      title: '印刷',
      icon: Icons.print,
      page: Print()
  ),
  help(
      title: 'ヘルプ',
      icon: Icons.help_outline,
      page: Help()
  );

  const TabItem({
    required this.title,
    required this.icon,
    required this.page,
  });

  final String title;

  final IconData icon;

  final Widget page;
}