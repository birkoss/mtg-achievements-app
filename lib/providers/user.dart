import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class UserProvider with ChangeNotifier {
  String _token;

  bool get isLogged {
    return token != null;
  }

  String get token {
    return _token;
  }

  Future<void> login(String email, String password) async {
    final url = Uri.http('localhost:8000', '/v1/login');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      print(responseData);
      // http://localhost:8000/v1/login

      _token = responseData['token'];
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData',
          json.encode({
            'token': _token,
          }));
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String email, String password) async {
    // @TODO: Register
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    _token = null;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    print('tryAutoLogin');

    var prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    var userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = userData['token'];
    notifyListeners();

    return true;
  }
}
