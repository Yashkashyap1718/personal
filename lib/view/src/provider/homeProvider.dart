import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_bank/model/user_model.dart';

class HomeProvider extends ChangeNotifier {
  bool loading = false;
  UserModel user = UserModel();
  File? profilePic;

  int pageIndex = 0;
  bool agree = false;

  showLoader() {
    loading = true;
    notifyListeners();
  }

  // hide loading

  hideLoader() {
    loading = false;
    notifyListeners();
  }

  // Set Profile pic
  setpic(file) {
    profilePic = file;
    notifyListeners();
  }

  updatepage(v) {
    pageIndex = v;
  }

  setAgree() {
    agree = !agree;
    notifyListeners();
  }

  updateUser(user, status) {
    user = user;

    notifyListeners();
  }
}
