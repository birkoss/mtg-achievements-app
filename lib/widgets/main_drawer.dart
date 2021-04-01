import 'package:app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('MTG Achievements'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Provider.of<UserProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
