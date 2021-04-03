import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../models/playgroup.dart';

class UserProvider with ChangeNotifier {
  String _token;
  String _playgroupId;

  List<Playgroup> _playgroups = [];

  bool get isLogged {
    return token != null && playgroups.length > 0;
  }

  String get token {
    return _token;
  }

  String get playgroupId {
    return _playgroupId;
  }

  List<Playgroup> get playgroups {
    return [..._playgroups];
  }

  Future<void> fetchPlaygroups() async {
    final url = Uri.http('localhost:8000', '/v1/playgroups');
    try {
      final response = await http.get(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'token $token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      final responsePlaygroups = responseData['playgroups'] as List;

      _playgroups = responsePlaygroups
          .map((playgroup) => Playgroup(
                playgroup['id'],
                playgroup['name'],
                playgroup['role'],
              ))
          .toList();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _login(String newToken, String newPlaygroupId) async {
    _token = newToken;
    _playgroupId = newPlaygroupId;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'userData',
        json.encode({
          'token': _token,
          'playgroupId': _playgroupId,
        }));

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.http('localhost:8000', '/v1/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      await _login(responseData['token'], responseData['playgroupId']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    _token = null;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    final url = Uri.http('localhost:8000', '/v1/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      await _login(responseData['token'], responseData['playgroupId']);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    print("tryAutoLogin()");

    var prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    var userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    if (userData['token'] == null) {
      return false;
    }

    _token = userData['token'];
    if (userData['playgroupId'] != null) {
      _playgroupId = userData['playgroupId'];
    }

    print("tryAutoLogin: true");

    try {
      await fetchPlaygroups();

      notifyListeners();
    } catch (error) {
      print(error);
      print("logout");
      await logout();
    }

    return true;
  }
}
