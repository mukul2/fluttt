import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/doctor/doctor_view.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/login_view.dart';
//Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//?LoginUI:Center(child: Text("Logged user"))) );

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Helvetica'),
        title: 'My GP',
        home: projectWidget(context));
  }
}

Widget projectWidget(BuildContext context) {
  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUI()));
  //runApp(LoginUI());
  //runApp(MyApp());
  //getLoginStatus();

  Future.delayed(const Duration(milliseconds: 2000), () {
    getLoginStatus();
    runApp(LoginUI());
  });

  return new Scaffold(
      body: Container(
          child: Stack(
    children: [
      Image.asset(
        "assets/nurse.png",
        fit: BoxFit.cover,
      ),
      // Positioned(top: 0,left:0,right: 0,bottom: 0, child: Center(child: Image.asset("assets/nurse.png",fit: BoxFit.fill,),),),
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(80, 240, 248, 255),
              Color.fromARGB(90, 240, 248, 255),
              Colors.orange,
              Colors.deepOrange

              //Color.fromARGB(95, 227, 182, 0),
              // Color.fromARGB(95, 208, 167, 0),
              //  Colors.or,
              // Colors.orange,

              // Colors.deepOrangeAccent,
              // Colors.orangeAccent
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 100,
        child: Center(
          child: Text(
            "Welcome to My Gp",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    ],
  )));

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
