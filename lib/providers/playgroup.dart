import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/achievement.dart';
import '../models/http_exception.dart';
import '../models/player.dart';
import '../models/playgroup.dart';

class PlaygroupProvider with ChangeNotifier {
  // final String id;
  // final String userToken;

  // PlaygroupProvider(this.userToken, this.id);
  String id;
  String userToken;

  PlaygroupProvider(String ut, String i) {
    print("PlaygroupProvider()");
    userToken = ut;
    id = i;
    if (userToken != null) {
      fetch();
    }
  }

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

  Future<void> addAchievement(
      String name, int points, String description) async {
    final url = Uri.http('localhost:8000', 'v1/playgroup/$id/achievements');
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'token $userToken',
        },
        body: json.encode({
          'name': name,
          'points': points,
          'description': description,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      _achievements.add(
        Achievement(
          id: responseData['playerId'],
          name: name,
          description: description,
          points: points,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
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
    print("PlaygroupProvider.fetch()");
    var url = Uri.http('localhost:8000', 'v1/playgroup/$id/players');

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

      url = Uri.http('localhost:8000', 'v1/playgroup/$id/achievements');

      final responseAchievements = await http.get(url, headers: {
        'Authorization': 'token $userToken',
      });

      final dataAchievements =
          json.decode(responseAchievements.body)['achievements'] as List;

      List<Achievement> newAchievements = dataAchievements
          .map(
            (achievement) => Achievement(
              id: achievement['achievementId'],
              name: achievement['name'],
              points: achievement['points'],
              description: achievement['description'],
            ),
          )
          .toList();

      _achievements = newAchievements;

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
