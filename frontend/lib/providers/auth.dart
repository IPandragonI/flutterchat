import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutterchat/data/forms/userForm.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api.dart';
import '../utils/http_exception.dart';

class Auth with ChangeNotifier {
  final String authUrl = Api.authUrl;

  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Map<String, dynamic>? _user;
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

  Map<String, dynamic>? get user {
    return _user;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _user = null;

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
    _user = extractedUserData['user'];
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> authenticate(UserForm userForm, String endpoint) async {
    try {
      final url = Uri.parse('$authUrl/$endpoint');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstName': userForm.firstName,
            'lastName': userForm.lastName,
            'email': userForm.email,
            'password': userForm.password,
          }));

      if(response.statusCode >= 400) {
        throw HttpException(json.decode(response.body)['message']);
      }

      final responseData = json.decode(response.body);

      _token = responseData['accessToken'];
      _userId = responseData['user']['id'];
      _expiryDate = DateTime.now().add(Duration(seconds: 3600));
      _user = responseData['user'];

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'user': _user,
      });

      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) {
    UserForm userForm = UserForm(email: email, password: password);
    return authenticate(userForm, 'login');
  }

  Future<void> signUp(String firstname, String lastname, String email, String password) {
    UserForm userForm = UserForm(firstName: firstname, lastName: lastname, email: email, password: password);
    return authenticate(userForm, 'signup');
  }
}