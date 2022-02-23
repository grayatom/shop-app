import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String token;
  String userId;
  DateTime expiryDateTime;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null &&
        expiryDateTime != null &&
        expiryDateTime.isAfter(DateTime.now());
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCvOjE8N--bS1uUNaK8IjANrR9LGQdDJXI';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final _decodedResponse = json.decode(response.body);
      if (_decodedResponse['error'] != null) {
        throw HttpException(_decodedResponse['error']['message']);
      }
      token = _decodedResponse['idToken'];
      userId = _decodedResponse['localId'];
      // print(int.parse(_decodedResponse['expiresIn']));
      expiryDateTime = DateTime.now().add(
        Duration(
          seconds: int.parse(_decodedResponse['expiresIn']),
        ),
      );
      Timer(
          Duration(
              seconds: expiryDateTime.difference(DateTime.now()).inSeconds),
          logout);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'userData',
        json.encode(
          {
            'token': token,
            'userId': userId,
            'expiryDT': expiryDateTime.toIso8601String(),
          },
        ),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) return false;
    final _userData = json.decode(prefs.getString('userData'));
    expiryDateTime = DateTime.parse(_userData['expiryDT']);
    if (expiryDateTime.isBefore(DateTime.now())) {
      expiryDateTime = null;
      return false;
    }
    token = _userData['token'];
    userId = _userData['userId'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    token = null;
    userId = null;
    expiryDateTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // void _autoLogout() {
  //   _authTimer = Timer(
  //       Duration(seconds: expiryDateTime.difference(DateTime.now()).inSeconds),
  //       logout);
  // }
}
