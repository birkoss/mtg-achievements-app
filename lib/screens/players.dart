import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/loading.dart';

import '../providers/playgroup.dart';

class PlayersScreen extends StatelessWidget {
  Future<void> fetchPlaygroup(BuildContext ctx) async {
    await Provider.of<PlaygroupProvider>(ctx, listen: false).fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchPlaygroup(context),
        builder: (ctx, snapshop) {
          if (snapshop.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return Consumer<PlaygroupProvider>(
              builder: (ctx, playgroup, _) => ListView.builder(
                itemCount: playgroup.players.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(playgroup.players[index].email),
                  subtitle: Text(playgroup.players[index].role),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
