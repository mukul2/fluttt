import 'package:appxplorebd/view/doctor/doctor_view.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

//Future<SharedPreferences> PROJ_SHARED_PREFF = SharedPreferences.getInstance();

Future<bool> getLoginStatus() async {
  bool isLoggedIn = false;
  String type = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  isLoggedIn =
      ((prefs.getBool("isLoggedIn") == null) | prefs.getBool("isLoggedIn") ==
              false)
          ? true
          : (isLoggedIn = true);

  type = prefs.getString("userType");
  if (type == "d") {
    mainD();
  } else if (type == "p") {
    mainP();
  }else  {


  }

  return isLoggedIn;
}

Future setLoginStatus(bool status) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  prefs.setBool("isLoggedIn", status);
  prefs.setString("userType", "none");
}

Future setUserType(String type) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  prefs.setString("userType", type);
}

Future<String> getUserType() async {
  String type = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;

  if (prefs.getString("userType") != null) {
    type = prefs.getString("userType");
  }
}
  //start
  Future setUserName(String type) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setString("userName", type);
  }

  Future<String> getuserName() async {
    String type = "";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;

    if (prefs.getString("userName") != null) {
      type = prefs.getString("userName");
    }
  }
  // end
  //start
  Future setUserID(String type) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setString("userID", type);
  }

  Future<String> getuserID() async {
    String type = "";
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;

    if (prefs.getString("userID") != null) {
      type = prefs.getString("userID");
    }
    // end

    //start
    Future setUserID(String type) async {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      prefs.setString("userID", type);
    }

    Future<String> getAuth() async {
      String type = "";
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;

      if (prefs.getString("auth") != null) {
        type = prefs.getString("auth");
      }
      //
    return type;
  }
}
