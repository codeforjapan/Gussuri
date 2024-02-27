import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gussuri/component/header.dart';
import 'package:gussuri/enums/TabItem.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'utils.dart';

final _navigatorKeys = <TabItem, GlobalKey<NavigatorState>>{
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.calender: GlobalKey<NavigatorState>(),
  TabItem.print: GlobalKey<NavigatorState>(),
  TabItem.help: GlobalKey<NavigatorState>(),
};

class Base extends HookWidget {
  const Base({super.key});

  Future<void> getEvents(context) async {
    Map<DateTime, List<Event>> eventData = {};
    for (var index = 0; index < 2; index++) {
      DateTime date = DateTime(kFirstDay.year, kFirstDay.month + index);
      final orderSnap = await FirebaseFirestore.instance
          .collection(await DeviceData.getDeviceUniqueId())
          .doc('${date.year}')
          .collection(DateFormat('MM').format(date))
          .get();
      orderSnap.docs.map((e) => e).forEach((res) {
        final data = res.data();
        eventData.addAll({
          DateTime.utc(date.year, date.month, int.parse(res.id)):
          List.generate(1, (index) {
            return Event(data, res.reference.path);
          })
        });
      });
    }
    Provider.of<CalenderState>(context, listen: false).updateEvent(eventData);
  }

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
          if (selectedTab == TabItem.calender) {
            getEvents(context);
          }
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
                label: tabItem.title(context),
              ),
            )
            .toList(),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
