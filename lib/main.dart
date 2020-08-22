import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/doctor/doctor_view.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/login_view.dart';
//Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//?LoginUI:Center(child: Text("Logged user"))) );

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Chucky Norris', home: projectWidget(context));
  }
}

Widget projectWidget(BuildContext context) {
  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUI()));
  runApp(LoginUI());
  //runApp(MyApp());
  getLoginStatus();

  return Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: new TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: new InputDecoration(
            hintText: '1',
            labelText: "Go to Login",
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(0.0),
              ),
              borderSide: new BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );

//  return FutureBuilder(
//    builder: (context, projectSnap) {
//      return (((projectSnap.data == null) | (projectSnap.data == false))
//          ? LoginUI()
//          : navigateUser());
//    },
//    future: getLoginStatus(),
//  );
}

Widget navigateUser() {
//  print("trying");
//
// Future<String> type =  getUserType();
//
// type.then((value) =>(){
//   print(value);
// });
//  getUserType().then((value) => () {
//    print("are- "+value);
//        if (value == "d") {
//          mainD();
//          print("D");
//        } else {
//          if (value == "p") {
//            mainP();
//            print("p");
//          }
//          print("dead");
//        }
//      });
  return Scaffold(
    body: Center(
      child: Text("Please wait"),
    ),
  );
}
