import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_player.dart';

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
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            EditPlayer.routeName,
                            arguments: playgroup.players[index].id,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'Do you want to remove this player from your playgroup?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    Provider.of<PlaygroupProvider>(
                                      context,
                                      listen: false,
                                    ).deletePlayer(
                                      playgroup.players[index].id,
                                    );
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
