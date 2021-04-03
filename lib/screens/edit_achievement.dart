import 'package:app/widgets/add_achievement.dart';
import 'package:flutter/material.dart';

class EditAchievement extends StatefulWidget {
  static const routeName = '/edit-achievement';

  @override
  _EditAchievementState createState() => _EditAchievementState();
}

const List<Tab> tabs = <Tab>[
  Tab(text: 'Create new Achievement'),
  Tab(text: 'Import existing'),
];

class _EditAchievementState extends State<EditAchievement> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext ctx) {
          final TabController tabController = DefaultTabController.of(ctx);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              print(tabController.index);
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: Text('Achievements'),
              bottom: const TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: [
                AddAchievement(),
                Center(
                  child: Text('Todo...'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
