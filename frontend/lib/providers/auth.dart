import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api.dart';
import '../utils/http_exception.dart';

class Auth with ChangeNotifier {
  final String authUrl = Api.authUrl;

  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    _authTimer?.cancel();
    _authTimer = null;

    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autoLogout() {
    _authTimer?.cancel();
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(pref.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> authenticate(String email, String password, String endpoint) async {
    try {
      final url = Uri.parse('$authUrl/$endpoint');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
          }));

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      _token = responseData['accessToken'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.now().add(Duration(seconds: 3600));

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) {
    return authenticate(email, password, 'signing');
  }

  Future<void> signUp(String email, String password) {
    return authenticate(email, password, 'signup');
  }
}