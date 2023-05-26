import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gussuri/component/header.dart';
import 'package:gussuri/enums/TabItem.dart';

final _navigatorKeys = <TabItem, GlobalKey<NavigatorState>>{
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.calender: GlobalKey<NavigatorState>(),
  TabItem.print: GlobalKey<NavigatorState>(),
  TabItem.help: GlobalKey<NavigatorState>(),
};

class Base extends HookWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab = useState(TabItem.home);
    return Scaffold(
      appBar: const Header(),
      body: Stack(
        children: TabItem.values
            .map(
              (tabItem) => Offstage(
                offstage: currentTab.value != tabItem,
                child: Navigator(
                  key: _navigatorKeys[tabItem],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute<Widget>(
                      builder: (context) => tabItem.page,
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: TabItem.values.indexOf(currentTab.value),
        onTap: (index) {
          final selectedTab = TabItem.values[index];
          if (currentTab.value == selectedTab) {
            _navigatorKeys[selectedTab]
                ?.currentState
                ?.popUntil((route) => route.isFirst);
          } else {
            // 未選択
            currentTab.value = selectedTab;
          }
        },
        items: TabItem.values
            .map(
              (tabItem) => BottomNavigationBarItem(
                icon: Icon(tabItem.icon),
                label: tabItem.title,
              ),
            )
            .toList(),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
