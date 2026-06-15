import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/component/header.dart';
import 'package:gussuri/enums/TabItem.dart';
import 'package:gussuri/home.dart';
import 'package:gussuri/utils.dart';

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
    final currentIndex = useState(0);

    void updateTab(int newIndex, TabItem newTab) {
      currentIndex.value = newIndex;
      currentTab.value = newTab;
    }

    void onNavTap(int index) {
      final selectedTab = TabItem.values[index];
      if (currentTab.value == selectedTab) {
        _navigatorKeys[selectedTab]
            ?.currentState
            ?.popUntil((route) => route.isFirst);
      } else {
        currentTab.value = selectedTab;
        currentIndex.value = index;
      }
    }

    final tabBody = Stack(
      children: TabItem.values
          .map(
            (tabItem) => Offstage(
              offstage: currentTab.value != tabItem,
              child: Navigator(
                key: _navigatorKeys[tabItem],
                onGenerateRoute: (settings) {
                  if (tabItem.page is Home) {
                    return MaterialPageRoute<Widget>(
                      builder: (context) =>
                          Home(updateIndex: updateTab),
                    );
                  } else if (tabItem.page is Calendar) {
                    return MaterialPageRoute<Widget>(
                      builder: (context) =>
                          Calendar(updateIndex: updateTab),
                    );
                  } else {
                    return MaterialPageRoute<Widget>(
                      builder: (context) => tabItem.page,
                    );
                  }
                },
              ),
            ),
          )
          .toList(),
    );

    if (isTablet(context)) {
      return Scaffold(
        appBar: Header(pageTitle: currentTab.value.pageTitle(context)),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex.value,
              onDestinationSelected: onNavTap,
              labelType: NavigationRailLabelType.selected,
              indicatorColor: const Color(0xFFc5cae9),
              destinations: TabItem.values
                  .map(
                    (tabItem) => NavigationRailDestination(
                      icon: Icon(tabItem.icon),
                      label: Text(tabItem.title(context)),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: tabBody),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const Header(),
      body: tabBody,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: onNavTap,
        items: TabItem.values
            .map(
              (tabItem) => BottomNavigationBarItem(
                icon: Icon(tabItem.icon),
                label: tabItem.title(context),
              ),
            )
            .toList(),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
