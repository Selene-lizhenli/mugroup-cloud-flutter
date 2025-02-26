import 'package:cloud/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthNotifier extends ChangeNotifier {
  User? user;

  bool get isLogged => user != null;

  void setUser(User? _user) {
    user = _user;
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();

final userProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return authNotifier;
});
