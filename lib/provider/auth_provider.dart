import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exeption.dart';

class AuthProvider with ChangeNotifier {
  String idToken = null;
  DateTime expiry;
  String emailName = null;
  String userId = null;
  Timer timer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (expiry != null && expiry.isAfter(DateTime.now()) && idToken != null) {
      return idToken;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    var response;
    var responseData;
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDRIb7xg-bTeEpCUGNOhuaJp_5FTR5aJf0";
    try {
      response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpExeption(responseData['error']['message']);
      }
      idToken = responseData["idToken"];
      userId = responseData["localId"];
      emailName = email;
      expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final perf = await SharedPreferences.getInstance();
      final data = json.encode({
        "idToken": idToken,
        "userId": userId,
        "expiry": expiry.toIso8601String(),
        "emailName": emailName
      });
      perf.setString("data", data);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey("data")) {
      return false;
    }
    final prefData = json.decode(pref.getString("data"))
        as Map<String, Object>; //....................error.....
    final isExpire = DateTime.parse(prefData["expiry"]);
    if (!isExpire.isAfter(DateTime.now())) {
      return false;
    }
    idToken = prefData["idToken"];
    userId = prefData["userId"];
    emailName = prefData["emailName"];
    expiry = isExpire;

    notifyListeners();
    autoLogOut();
    return true;
  }

  Future<void> logIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<void> singUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> logOut() async {
    idToken = null;
    userId = null;
    expiry = null;
    emailName = null;
    if (timer != null) {
      timer.cancel();
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogOut() {
    if (timer != null) {
      timer.cancel();
    }
    final timetoExpire = expiry.difference(DateTime.now()).inSeconds;
    timer = Timer(Duration(seconds: timetoExpire), logOut);
  }
}
