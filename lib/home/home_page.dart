import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/account/account_page.dart';
import 'package:time_tracker_flutter_course/home/Entries/entries_page.dart';
import 'package:time_tracker_flutter_course/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/home/tab_item.dart';
import 'package:time_tracker_flutter_course/jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, WidgetBuilder> get widgetBuilder {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }

    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelected: _select,
        widgetBuilder: widgetBuilder,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
