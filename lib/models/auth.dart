import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  Map<String, String> auth_data = {
    "name": "",
    "email": "",
    "id": "",
    "token": ""
  };

  setAuthData(
      {required String name, required String email, required String id, required String token}) {
    auth_data = {
      "name": name,
      "email": email,
      "id": id,
      "token": token
    };
    notifyListeners();
  }

  wipeAuthData() {
    auth_data = {
      "name": "",
      "email": "",
      "id": "",
      "token": ""
    };
    notifyListeners();
  }
}