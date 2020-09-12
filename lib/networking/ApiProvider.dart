import 'dart:math';

import 'package:appxplorebd/chat/model/chat_message.dart';
import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/networking/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

String AUTH_KEY = "";
String USER_ID = "";
String USER_NAME = "";
String USER_PHOTO = "";
String USER_MOBILE = "";
String USER_EMAIL = "";
int DOC_HOME_VISIT = 0;

final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";

Future<LoginResponse> performLogin(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));
    USER_NAME = loginResponse.userInfo.name;
    USER_PHOTO = loginResponse.userInfo.photo;
    USER_MOBILE = loginResponse.userInfo.phone;
    USER_EMAIL = loginResponse.userInfo.email;
    //showThisToast("phoyo link "+USER_PHOTO);
    return loginResponse;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> checkNumber(String phone) async {
  final http.Response response = await http.post(
    _baseUrl + 'checkMobileNumber',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'phone': phone}),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> signupPatient(String name, String phone, String email,
    String type, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'sign-up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phone': phone,
      'email': email,
      'user_type': type,
      'name': name,
      'password': password,
      'department': "0"
    }),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<String> getDepartmentsData() async {
  final http.Response response = await http.post(
    _baseUrl + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );
//  this.setState(() {
//    blogCategoryList = json.decode(response.body);
//    getBlogs();
//  });
  return response.body;
}
Future<String> getTestRecListData(String auth) async {
  final http.Response response = await http.get(
    _baseUrl + 'all-diagnosis-test-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
  );
  //showThisToast(response.statusCode.toString());
  //showThisToast(response.body.toString());
//  this.setState(() {
//    blogCategoryList = json.decode(response.body);
//    getBlogs();
//  });
  return response.body;
}

Future<dynamic> signupDoctor(String name, String phone, String email,
    String type, String password, String depaertment) async {
  final http.Response response = await http.post(
    _baseUrl + 'sign-up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phone': phone,
      'email': email,
      'user_type': type,
      'name': name,
      'password': password,
      'department':
          depaertment != null && depaertment.length > 0 ? depaertment : "0"
    }),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> performLoginSecond(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));
    USER_NAME = loginResponse.userInfo.name;
    USER_PHOTO = loginResponse.userInfo.photo;
    USER_MOBILE = loginResponse.userInfo.phone;
    USER_EMAIL = loginResponse.userInfo.email;
    //  showThisToast("phoyo link "+USER_PHOTO);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> performAppointmentSubmit(
    String AUTH,
    String patient_id,
    String dr_id,
    String problems,
    String phone,
    String name,
    String chamber_id,
    String date,
    String status,
    String type) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-appointment-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH,
    },
    body: jsonEncode(<String, String>{
      'patient_id': patient_id,
      'dr_id': dr_id,
      'problems': problems,
      'phone': phone,
      'name': name,
      'chamber_id': chamber_id,
      'date': date,
      'status': status,
      'type': type,
    }),
  );
  print(response.body);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    showThisToast(response.statusCode.toString());

    throw Exception('Failed to load');
  }
}

Future<LoginResponse> fetchDepartList(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );
  //  showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> updateDisplayName(String auth, String userID, String name) async {
  final http.Response response = await http.post(
    _baseUrl + 'update-user-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{'name': name, 'user_id': userID}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<dynamic> request_withdraw(String auth, String userID, String amout,String bank) async {
  final http.Response response = await http.post(
    _baseUrl + 'add_withdrawal_request',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{'amount': amout, 'dr_id': userID,'bankinfo':bank}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<dynamic> addDiseasesHistory(String auth,String uid,
    String name, String startdate, String status) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-disease-record',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{
      'patient_id': uid,
      'disease_name': name,
      'first_notice_date': startdate,
      'status': status
    }),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception((response.statusCode).toString());
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
