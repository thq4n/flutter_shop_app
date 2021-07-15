import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  Future<void> authenticateUser(String email, String password, Uri url,
      [bool isSignUp = false]) async {
    final response = await http.post(url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));
    final responseData = json.decode(response.body);
    if (responseData["error"] != null) {
      throw HttpException(responseData["error"]["message"]);
    }

    if (isSignUp) {
      return;
    }

    _token = responseData["idToken"];
    _userId = responseData["localId"];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseData["expiresIn"])));

    _autoLogout();

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final userData = json.encode(
      {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
      },
    );

    prefs.setString("userData", userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]!);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  bool isAuth() {
    if (_token != null) {
      return true;
    }
    return false;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else
      return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDaQUCB8uKtTOkEh-Awu4fpExdVLfXP5yU");

    return authenticateUser(email, password, url, true);
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDaQUCB8uKtTOkEh-Awu4fpExdVLfXP5yU");

    return authenticateUser(email, password, url);
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.remove("userData");

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
