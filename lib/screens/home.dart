import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/achievements.dart';
import '../screens/edit_achievement.dart';
import '../screens/edit_player.dart';
import '../screens/players.dart';

import '../widgets/main_drawer.dart';

import '../providers/user.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> _pages;

  var _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _addNew() {
    if (_selectedPageIndex == 0) {
      Navigator.of(context).pushNamed(EditAchievement.routeName);
    } else {
      Navigator.of(context).pushNamed(EditPlayer.routeName);
    }
  }

  @override
  void initState() {
    setState(() {
      _pages = [
        {
          'page': AchievementsScreen(),
          'title': 'Achievements',
          'icon': Icons.military_tech,
        },
        {
          'page': PlayersScreen(),
          'title': 'Players',
          'icon': Icons.people,
        },
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: [
          if (user.playgroups.length > 1)
            PopupMenuButton(
              onSelected: (String selectedValue) {
                user.changePlaygroup(selectedValue);
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => user.playgroups
                  .map((playgroup) => PopupMenuItem(
                        child: ListTile(
                          leading: user.playgroupId == playgroup.id
                              ? Icon(Icons.check)
                              : Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                          title: Text(playgroup.name),
                        ),
                        value: playgroup.id,
                      ))
                  .toList(),
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNew,
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryTextTheme.headline1.color,
        unselectedItemColor:
            Theme.of(context).primaryTextTheme.headline1.color.withOpacity(0.5),
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: _pages
            .map(
              (singlePage) => BottomNavigationBarItem(
                label: singlePage['title'],
                icon: Icon(singlePage['icon']),
              ),
            )
            .toList(),
      ),
    );
  }
}

/*

        unselectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorites'),
          ),
        ],
      ),
    );

    */
