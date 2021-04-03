import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/achievement.dart';
import '../models/http_exception.dart';
import '../models/player.dart';
import '../models/playgroup.dart';

class PlaygroupProvider with ChangeNotifier {
  final String id;
  final String userToken;

  PlaygroupProvider(this.userToken, this.id);

  List<Achievement> _achievements = [];
  List<Playgroup> _playgroups = [];
  List<Player> _players = [];

  List<Achievement> get achievements {
    return _achievements;
  }

  List<Player> get players {
    return _players;
  }

  List<Playgroup> get playgroups {
    return _playgroups;
  }

  Future<void> addPlayer(String email, String role) async {
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/players');
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'token $userToken',
        },
        body: json.encode({
          'email': email,
          'role': role,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      _players.add(Player(responseData['playerId'], email, role));
      notifyListeners();
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
              player['player']['id'],
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

  Future<void> deletePlayer(String playerId) async {
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/player/$playerId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'token $userToken',
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      _players.removeWhere((player) => player.id == playerId);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updatePlayer(String playerId, String playerRole) async {
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/player/$playerId');
    try {
      final response = await http.patch(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'token $userToken',
        },
        body: json.encode({
          'role': playerRole,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      // _players.add(Player(responseData['playerId'], email, role));
      var index = _players.indexWhere((player) => player.id == playerId);
      if (index >= 0) {
        _players[index] = Player(
          _players[index].id,
          _players[index].email,
          playerRole,
        );
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
