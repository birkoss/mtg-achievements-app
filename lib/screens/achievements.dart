import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/loading.dart';

import '../providers/playgroup.dart';

class AchievementsScreen extends StatelessWidget {
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
              builder: (ctx, playgroup, _) => Text(playgroup.id),
            );
          }
        },
      ),
    );
  }
}
