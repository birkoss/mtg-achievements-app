import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/achievement.dart';
import '../models/player.dart';

class PlaygroupProvider with ChangeNotifier {
  final String id;
  final String userToken;

  PlaygroupProvider(this.userToken, this.id);

  List<Player> _players = [];
  List<Achievement> _achievements = [];

  List<Player> get players {
    return _players;
  }

  List<Achievement> get achievements {
    return _achievements;
  }

  Future<void> addPlayer(String email, String role) async {
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/players');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'token $userToken',
        },
        body: json.encode({
          'email': email,
          'role': 'role',
        }),
      );

      print(response.body);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetch() async {
    print("playgroup provider . fetch()");
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/players');

    try {
      final responsePlayers = await http.get(url, headers: {
        'Authorization': 'token $userToken',
      });

      final dataPlayers = json.decode(responsePlayers.body)['players'] as List;
      List<Player> newPlayers = dataPlayers
          .map(
            (player) => Player(
              player['player']['email'],
              player['player_role']['name'],
            ),
          )
          .toList();

      _players = newPlayers;

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removePlayer(String email) async {
    // ...
  }
}
