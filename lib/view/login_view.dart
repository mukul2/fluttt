import 'dart:convert';
import 'dart:io';
import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/patient/another_map.dart';
import 'package:appxplorebd/view/patient/myMapViewActivity.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appPhoneVerification.dart';
import 'doctor/Widgets.dart';
import 'doctor/doctor_view.dart';
import 'package:flutter/material.dart';
import 'package:appxplorebd/networking/Repsonse.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:appxplorebd/view/patient/sharedData.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/chat/model/root_page.dart';
import 'package:appxplorebd/chat/service/authentication.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";

void main() => runApp(LoginUI());
var PHONE_NUMBER_VERIFIED;

class LoginUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.blueAccent,
      title: appTitle,
      home: Scaffold(
        // body: MyCustomForm(),
        body: NewLoginUI(),
      ),
    );
  }
}

Widget ChooseUserType(BuildContext context) {
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
        bottom: 50,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    onPressed: () {
                      //showThisToast("clicked");
                      // error
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => CheckPhoneIntegForm()));//
//
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPatientLoginForm()));
                    },
                    color: Colors.white,
                    child: Text(
                      "I'm a Patient",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "I'm a Doctor",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: ShapeDecoration(
                    shape: CustomRoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      topSide: BorderSide(color: Colors.white),
                      leftSide: BorderSide(color: Colors.white),
                      bottomLeftCornerSide: BorderSide(color: Colors.white),
                      topLeftCornerSide: BorderSide(color: Colors.white),
                      topRightCornerSide: BorderSide(color: Colors.white),
                      rightSide: BorderSide(color: Colors.white),
                      bottomRightCornerSide: BorderSide(color: Colors.white),
                      bottomSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  )));
}
//start

class ChooseUserTypeActivity extends StatefulWidget {
  String userType;

  @override
  _ChooseUserTypeActivityState createState() => _ChooseUserTypeActivityState();
}

class _ChooseUserTypeActivityState extends State<ChooseUserTypeActivity> {
  @override
  void initState() {
    setState(() {
      widget.userType = "p";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Image.asset("assets/stet.png"),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.userType = "p";
                      });
                    },
                    child: Card(
                      color:
                          widget.userType == "p" ? Colors.blue : Colors.white,
                      child: ListTile(
                        // trailing: Icon(Icons.face, color: widget.userType == "p" ?Colors.white:Colors.blue,),
                        title: Center(
                          child: Text(
                            "Patient",
                            style: TextStyle(
                                color: widget.userType == "p"
                                    ? Colors.white
                                    : Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.userType = "d";
                      });
                    },
                    child: Card(
                        color:
                            widget.userType == "d" ? Colors.blue : Colors.white,
                        child: ListTile(
                          // trailing: Icon(Icons.face,color: widget.userType == "d" ?Colors.white:Colors.blue,),

                          title: Center(
                            child: Text(
                              "Health Care Provider",
                              style: TextStyle(
                                  color: widget.userType == "d"
                                      ? Colors.white
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CheckPhoneIntegForm(widget.userType))); //
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: InkWell(
                  child: Card(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Text(
                          "NEXT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//start
class NewPatientLoginForm extends StatefulWidget {
  @override
  NewPatientLoginFormtate createState() {
    return NewPatientLoginFormtate();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewPatientLoginFormtate extends State<NewPatientLoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 18),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(15, 00, 0, 30)),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 00),
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 32,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 5, 15),
              child:  Text(
                "Welcome Back",
                style: TextStyle(
                  // color: Color(0xFF34448c),
                    fontSize: 25,
                    ),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 234, 234, 234), filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 234, 234, 234), width: 10.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 234, 234, 234), width: 10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 234, 234, 234), width: 10.0)),
                    labelText: "Email",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode2,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  password = value;
                  if (value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 234, 234, 234), filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 234, 234, 234), width: 10.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 234, 234, 234))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 234, 234, 234))),
                    labelText: "Password",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 55,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color.fromARGB(255, 240, 107, 28),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text(
                            "Please wait",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        });

                        LoginResponse loginResponse =
                            await performLogin(email, password);
                        print(loginResponse.toString());
                        //  showThisToast(loginResponse.message);

                        //  showThisToast(loginResponse.toString());

                        if (loginResponse != null && loginResponse.status) {
                          setState(() {
                            StandbyWid = Text(loginResponse.message);
                          });
                          setLoginStatus(true);
                          // AUTH_KEY = "Bearer " + loginResponse.accessToken;
                          USER_ID = loginResponse.userInfo.id.toString();
                          setUserType(loginResponse.userInfo.userType);

                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          prefs.setString(
                              "uid", loginResponse.userInfo.id.toString());
                          prefs.setString(
                              "uname", loginResponse.userInfo.name.toString());
                          prefs.setString("uphone",
                              loginResponse.userInfo.phone.toString());
                          prefs.setString("uphoto",
                              loginResponse.userInfo.photo.toString());
                          prefs.setString("uemail",
                              loginResponse.userInfo.email.toString());
                          prefs.setString("utype",
                              loginResponse.userInfo.userType.toString());
                          prefs.setString(
                              "udes",
                              loginResponse.userInfo.designationTitle
                                  .toString());
                          prefs.setString(
                              "auth", "Bearer " + loginResponse.accessToken);
                          prefs.setBool("isLoggedIn", true);

                          if (loginResponse.userInfo.userType.contains("d")) {
                            //  showThisToast("doctor");
                            DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
                            //doctor
                            mainD();
                          } else if (loginResponse.userInfo.userType
                              .contains("p")) {
                            //patient
                            //  showThisToast("patient");

                            mainP();
                            // mainMap();
//                      Navigator.push(
//                          context, MaterialPageRoute(builder: (context) => MyMaps()));
                          } else {
                            //unknwon user
                            showThisToast("Unknown user");
                          }
                        } else {
                          setState(() {
                            StandbyWid = Text(
                              "Wrong email or password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            );
                          });

                          //  showThisToast(loginResponse.message);
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindAccountActivity()));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Forgot password ?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
//end

//start
class NewLoginUI extends StatefulWidget {
  @override
  NewLoginUItate createState() {
    return NewLoginUItate();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewLoginUItate extends State<NewLoginUI> {
  @override
  Widget build(BuildContext context) {
    return ChooseUserType(context);
  }
}
//end

//end
// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 18),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    return Container(
      color: Color.fromARGB(255, 173, 216, 230),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//          Text(
//            "Telemedicine",
//            style: TextStyle(
//                color: Color(0xFF34448c),
//                fontSize: 30,
//                fontWeight: FontWeight.bold),
//          ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Center(
                child: Container(
                  height: 150,
                  width: 250,
                  child: Image.asset("assets/log_t.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 189, 62, 68),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 189, 62, 68), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    labelText: "Email",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode2,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  password = value;
                  if (value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 189, 62, 68),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 189, 62, 68), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    labelText: "Password",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color.fromARGB(255, 240, 107, 28),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text(
                            "Please wait",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        });

                        LoginResponse loginResponse =
                            await performLogin(email, password);
                        print(loginResponse.toString());
                        //  showThisToast(loginResponse.message);

                        //  showThisToast(loginResponse.toString());

                        if (loginResponse != null && loginResponse.status) {
                          setState(() {
                            StandbyWid = Text(loginResponse.message);
                          });
                          setLoginStatus(true);
                          // AUTH_KEY = "Bearer " + loginResponse.accessToken;
                          USER_ID = loginResponse.userInfo.id.toString();
                          setUserType(loginResponse.userInfo.userType);

                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          prefs.setString(
                              "uid", loginResponse.userInfo.id.toString());
                          prefs.setString(
                              "uname", loginResponse.userInfo.name.toString());
                          prefs.setString("uphone",
                              loginResponse.userInfo.phone.toString());
                          prefs.setString("uphoto",
                              loginResponse.userInfo.photo.toString());
                          prefs.setString("uemail",
                              loginResponse.userInfo.email.toString());
                          prefs.setString("utype",
                              loginResponse.userInfo.userType.toString());
                          prefs.setString(
                              "udes",
                              loginResponse.userInfo.designationTitle
                                  .toString());
                          prefs.setString(
                              "auth", "Bearer " + loginResponse.accessToken);
                          prefs.setBool("isLoggedIn", true);

                          if (loginResponse.userInfo.userType.contains("d")) {
                            //  showThisToast("doctor");
                            DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
                            //doctor
                            mainD();
                          } else if (loginResponse.userInfo.userType
                              .contains("p")) {
                            //patient
                            //  showThisToast("patient");

                            mainP();
                            // mainMap();
//                      Navigator.push(
//                          context, MaterialPageRoute(builder: (context) => MyMaps()));
                          } else {
                            //unknwon user
                            showThisToast("Unknown user");
                          }
                        } else {
                          setState(() {
                            StandbyWid = Text(
                              "Wrong email or password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            );
                          });

                          //  showThisToast(loginResponse.message);
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    onPressed: () {
                      // error
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => CheckPhoneIntegForm()));//
//
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseUserTypeActivity()));
                    },
                    color: Color.fromARGB(255, 189, 62, 68),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindAccountActivity()));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Forgot password ?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChooseuserTypeForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ChooseuserTypeFormState extends State<ChooseuserTypeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 18),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    FocusNode myFocusNode = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    return Container(
      color: Color.fromARGB(255, 173, 216, 230),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//          Text(
//            "Telemedicine",
//            style: TextStyle(
//                color: Color(0xFF34448c),
//                fontSize: 30,
//                fontWeight: FontWeight.bold),
//          ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Center(
                child: Container(
                  height: 150,
                  width: 250,
                  child: Image.asset("assets/log_t.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 189, 62, 68),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 189, 62, 68), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    labelText: "Email",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                focusNode: myFocusNode2,
                style: TextStyle(
                  color: Color.fromARGB(255, 189, 62, 68),
                ),
                initialValue: "",
                validator: (value) {
                  password = value;
                  if (value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                cursorColor: Color.fromARGB(255, 189, 62, 68),
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 189, 62, 68),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 189, 62, 68), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 189, 62, 68))),
                    labelText: "Password",
                    focusColor: Color.fromARGB(255, 189, 62, 68),
                    labelStyle: TextStyle(
                        color: myFocusNode.hasFocus
                            ? Color.fromARGB(255, 189, 62, 68)
                            : Color.fromARGB(255, 189, 62, 68))),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color.fromARGB(255, 240, 107, 28),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text(
                            "Please wait",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        });

                        LoginResponse loginResponse =
                            await performLogin(email, password);
                        print(loginResponse.toString());
                        //  showThisToast(loginResponse.message);

                        //  showThisToast(loginResponse.toString());

                        if (loginResponse != null && loginResponse.status) {
                          setState(() {
                            StandbyWid = Text(loginResponse.message);
                          });
                          setLoginStatus(true);
                          // AUTH_KEY = "Bearer " + loginResponse.accessToken;
                          USER_ID = loginResponse.userInfo.id.toString();
                          setUserType(loginResponse.userInfo.userType);

                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          prefs.setString(
                              "uid", loginResponse.userInfo.id.toString());
                          prefs.setString(
                              "uname", loginResponse.userInfo.name.toString());
                          prefs.setString("uphone",
                              loginResponse.userInfo.phone.toString());
                          prefs.setString("uphoto",
                              loginResponse.userInfo.photo.toString());
                          prefs.setString("uemail",
                              loginResponse.userInfo.email.toString());
                          prefs.setString("utype",
                              loginResponse.userInfo.userType.toString());
                          prefs.setString(
                              "udes",
                              loginResponse.userInfo.designationTitle
                                  .toString());
                          prefs.setString(
                              "auth", "Bearer " + loginResponse.accessToken);
                          prefs.setBool("isLoggedIn", true);

                          if (loginResponse.userInfo.userType.contains("d")) {
                            //  showThisToast("doctor");
                            DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
                            //doctor
                            mainD();
                          } else if (loginResponse.userInfo.userType
                              .contains("p")) {
                            //patient
                            //  showThisToast("patient");

                            mainP();
                            // mainMap();
//                      Navigator.push(
//                          context, MaterialPageRoute(builder: (context) => MyMaps()));
                          } else {
                            //unknwon user
                            showThisToast("Unknown user");
                          }
                        } else {
                          setState(() {
                            StandbyWid = Text(
                              "Wrong email or password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            );
                          });

                          //  showThisToast(loginResponse.message);
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    onPressed: () {
                      // error
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => CheckPhoneIntegForm()));//
//
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseUserTypeActivity()));
                    },
                    color: Color.fromARGB(255, 189, 62, 68),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindAccountActivity()));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Forgot password ?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Widget getAppVersion() async{
//  PackageInfo packageInfo = await PackageInfo.fromPlatform();
//  return
//
//}
//starts
class ShowFindAccountActivity extends StatefulWidget {
  dynamic foundAccout;

  ShowFindAccountActivity(this.foundAccout);

  @override
  ShowFindAccountActivityState createState() {
    return ShowFindAccountActivityState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ShowFindAccountActivityState extends State<ShowFindAccountActivity> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String number;
  String myMessage = "Search";

  Widget StandbyWid = Text(
    "Search",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Found"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          widget.foundAccout["profile"]["photo"] != null
                              ? _baseUrl_image +
                                  widget.foundAccout["profile"]["photo"]
                              : ""),
                    ),
                    title: Text(widget.foundAccout["profile"]["name"]),
                    subtitle: Text(widget.foundAccout["profile"]["phone"] +
                        "\n" +
                        widget.foundAccout["profile"]["email"]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    //PhoneVerificationScreenRecovery
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PhoneVerificationScreenRecovery(
                                    widget.foundAccout["profile"]["phone"])));
                  },
                  leading: Icon(Icons.done, color: Colors.blue),
                  title: Text(
                    "Yes this is my Account",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  title: Text("This is NOT my Account",
                      style: TextStyle(color: Colors.red)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
//ends

//starts
class UpdatePasswordActivity extends StatefulWidget {
  dynamic foundAccout;

  UpdatePasswordActivity(this.foundAccout);

  @override
  UpdatePasswordActivityState createState() {
    return UpdatePasswordActivityState();
  }
}

class UpdatePasswordActivityState extends State<UpdatePasswordActivity> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String number;
  String myMessage = "Update";

  Widget StandbyWid = Text(
    "Update",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      // appBar: AppBar(title: Text("Find your Account"),),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "New Password",
              style: TextStyle(
                  color: Color(0xFF34448c),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  number = value;
                  if (value.isEmpty) {
                    return 'Please enter new Password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "New Password"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color(0xFF34448c),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text("Please wait");
                        });

                        dynamic resp = await changePasswood(
                            widget.foundAccout.toString(), number);
                        print("check response");
                        print(resp);
                        if (resp["status"]) {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                        } else {
                          // showThisToast("User Allreasy registered");
                          setState(() {
                            StandbyWid = Text(
                              "Problem Occured",
                              style: TextStyle(color: Colors.white),
                            );
                          });
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

//ends

//starts
class FindAccountActivity extends StatefulWidget {
  @override
  FindAccountActivityState createState() {
    return FindAccountActivityState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class FindAccountActivityState extends State<FindAccountActivity> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String number;
  String myMessage = "Search";

  Widget StandbyWid = Text(
    "Search",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      // appBar: AppBar(title: Text("Find your Account"),),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Find your Account",
              style: TextStyle(
                  color: Color(0xFF34448c),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  number = value;
                  if (value.isEmpty) {
                    return 'Please enter Email/Phone Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Phone Number / Email"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color(0xFF34448c),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text("Please wait");
                        });

                        dynamic resp = await fetchuserByEmailorPhone(number);
                        print("check response");
                        print(resp);
                        if (resp["status"]) {
                          PHONE_NUMBER_VERIFIED = number;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowFindAccountActivity(resp)));
                        } else {
                          // showThisToast("User Allreasy registered");
                          setState(() {
                            StandbyWid = Text(
                              "User Not Found",
                              style: TextStyle(color: Colors.white),
                            );
                          });
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

//ends
//starts
class CheckPhoneIntegForm extends StatefulWidget {
  String userType;

  CheckPhoneIntegForm(this.userType);

  @override
  CheckPhoneIntegFormState createState() {
    return CheckPhoneIntegFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CheckPhoneIntegFormState extends State<CheckPhoneIntegForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String number;
  String myMessage = "Verify";

  Widget StandbyWid = Text(
    "Verify",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Verify Contact Number",
              style: TextStyle(
                  color: Color(0xFF34448c),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                initialValue: "+",
                validator: (value) {
                  number = value;
                  if (value.isEmpty) {
                    return 'Please enter Phone Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Phone Number"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color(0xFF34448c),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text("Please wait");
                        });

                        dynamic resp = await checkNumber(number);
                        print("check response");
                        print(resp);
                        if (resp["status"]) {
                          PHONE_NUMBER_VERIFIED = number;

                          if (true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PhoneVerificationScreen(
                                            widget.userType)));
                          } else {
                            if (widget.userType == "p") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignupActivityPatient()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignupActivityDoctor()));
                            }
                          }
                        } else {
                          // showThisToast("User Allreasy registered");
                          setState(() {
                            StandbyWid = Text(
                              "User Already registered",
                              style: TextStyle(color: Colors.white),
                            );
                          });
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
//ends

//starts

class SignupActivityPatient extends StatefulWidget {
  @override
  _SignupActivityPatientState createState() => _SignupActivityPatientState();
}

class _SignupActivityPatientState extends State<SignupActivityPatient> {
// Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String number, name, email, password;
  String myMessage = "Sign Up";

  Widget StandbyWid = Text(
    "Verify",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign Up as Patient",
              style: TextStyle(
                  color: Color(0xFF34448c),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  name = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Name"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                enabled: false,
                initialValue: PHONE_NUMBER_VERIFIED,
                validator: (value) {
                  number = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Phone';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Phone"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  password = value;
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Password"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color(0xFF34448c),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text("Please wait");
                        });

                        dynamic resp = await signupPatient(
                            name, number, email, "p", password);
                        print("check response");
                        print(resp);
                        if (resp["status"]) {
                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          prefs.setString(
                              "uid", resp["user_info"]["id"].toString());
                          prefs.setString(
                              "uname", resp["user_info"]["name"].toString());
                          prefs.setString("utype",
                              resp["user_info"]["user_type"].toString());
                          prefs.setString(
                              "auth", "Bearer " + resp["access_token"]);
                          prefs.setBool("isLoggedIn", true);
                          mainP();

                          setState(() {
                            StandbyWid = Text(
                              resp.toString(),
                              style: TextStyle(color: Colors.white),
                            );
                          });
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      PhoneVerificationScreen()));
                        } else {
                          // showThisToast("User Allreasy registered");
                          setState(() {
                            StandbyWid = Text(
                              "Error occured",
                              style: TextStyle(color: Colors.white),
                            );
                          });
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String getVerifiedNumber() {
    FirebaseUser user = FirebaseAuth.instance.currentUser() as FirebaseUser;
    return user.phoneNumber;
  }
}

//ends
//start
class ChooseDeptActivity extends StatefulWidget {
  List deptList__ = [];
  Function function;

  //ChooseDeptActivity(this.deptList__, this.function);
  ChooseDeptActivity(this.deptList__, {Key key, this.function})
      : super(key: key);

  @override
  _ChooseDeptActivityState createState() => _ChooseDeptActivityState();
}

class _ChooseDeptActivityState extends State<ChooseDeptActivity> {
  List deptList = [];

  getData() async {
    String da = await getDepartmentsData();
    setState(() async {
      widget.deptList__ = json.decode(da);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //  this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CHOOSE DEPARTMENT"),
      ),
      body: true
          ? ListView.builder(
              itemCount:
                  widget.deptList__ == null ? 0 : widget.deptList__.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      final Map<String, dynamic> data =
                          new Map<String, dynamic>();
                      data['id'] = widget.deptList__[index]["id"].toString();
                      data['name'] =
                          widget.deptList__[index]["name"].toString();
                      widget.function(data);
                      Navigator.of(context).pop(true);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: Icon(Icons.add),
                          title: new Text(
                            widget.deptList__[index]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text(widget.deptList__.toString()),
            ),
    );
  }
}

//ends
//
// start
class ChooseDocument extends StatefulWidget {
  Function function;
  List<File> fileList = [];

  //ChooseDeptActivity(this.deptList__, this.function);
  ChooseDocument(this.fileList, {Key key, this.function}) : super(key: key);

  @override
  _ChooseDocumentState createState() => _ChooseDocumentState();
}

class _ChooseDocumentState extends State<ChooseDocument> {
  @override
  void initState() {
    // TODO: implement initState
    //  this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add at least 1 Document"),
        actions: [
          GestureDetector(
              onTap: () {
                widget.function(widget.fileList);
                Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            File image = await FilePicker.getFile();
//        final Map<String, File> data =
//        new Map<String, File>();
//        data['link'] = image;
            setState(() {
              widget.fileList.add(image);
            });
          },
          label: Text("Pick from Device")),
      body: true
          ? ListView.builder(
              itemCount: widget.fileList == null ? 0 : widget.fileList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      // widget.function(data);
                      // Navigator.of(context).pop(true);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: InkWell(
                            onTap: () {
                              setState(() {
                                widget.fileList.removeAt(index);
                              });
                            },
                            child: Icon(Icons.delete),
                          ),
                          leading:
                              Image.file(File(widget.fileList[index].path)),
                          title: new Text(
                            (widget.fileList[index].path).split('/').last,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text(widget.fileList.toString()),
            ),
    );
  }
}
//ends

//starts

class SignupActivityDoctor extends StatefulWidget {
  @override
  _SignupActivityDoctorState createState() => _SignupActivityDoctorState();
}

class _SignupActivityDoctorState extends State<SignupActivityDoctor> {
// Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  List deptList = [];
  List<File> fileList = [];

  final _formKey = GlobalKey<FormState>();
  String number, name, email, password;
  String myMessage = "Signup";
  String selectedDepartment;
  String txtSelectDepartment = "Select a Department";
  String selectDocumentHint = "Add Documents/Certificates";

  getData() async {
    setState(() async {
      String da = await getDepartmentsData();

      deptList = json.decode(da);
      // showThisToast("dept size " + deptList.length.toString());
    });
  }

  Widget StandbyWid = Text(
    "Signup",
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //         <--- border radius here
          ),
      border: Border.all(
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Signup as Healthcare Provider",
              style: TextStyle(
                  color: Color(0xFF34448c),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Container(
                decoration: myBoxDecoration(),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseDeptActivity(
                                  deptList,
                                  function: (data) {
                                    //  showThisToast("im hit hit hit wioth "+data);
                                    setState(() {
                                      selectedDepartment =
                                          data["id"].toString();
                                      txtSelectDepartment =
                                          data["name"].toString();
                                    });
                                  },
                                )));
                  },
                  trailing: Icon(Icons.arrow_downward),
                  title: Text(txtSelectDepartment),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                decoration: myBoxDecoration(),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseDocument(
                                  fileList,
                                  function: (data) {
                                    //  showThisToast("im hit hit hit wioth "+data);
                                    setState(() {
                                      selectDocumentHint = "" +
                                          data.length.toString() +
                                          " documents selected";
                                    });
                                  },
                                )));
                  },
                  trailing: Icon(Icons.arrow_downward),
                  title: Text(selectDocumentHint),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  name = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Name"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                enabled: false,
                initialValue: PHONE_NUMBER_VERIFIED,
                validator: (value) {
                  number = value;
                  if (value.isEmpty) {
                    return 'Please enter Your Phone';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Phone"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  password = value;
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Password"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    color: Color(0xFF34448c),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        setState(() {
                          StandbyWid = Text("Please wait");
                        });

                        dynamic resp = await signupDoctor(name, number, email,
                            "d", password, selectedDepartment);
                        print("check response");
                        print(resp);
                        if (resp["status"]) {
                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;

                          prefs.setString(
                              "uid", resp["user_info"]["id"].toString());
                          prefs.setString(
                              "uname", resp["user_info"]["name"].toString());
                          prefs.setString("utype",
                              resp["user_info"]["user_type"].toString());
                          prefs.setString(
                              "auth", "Bearer " + resp["access_token"]);
                          prefs.setBool("isLoggedIn", true);

                          setState(() {
                            StandbyWid = Text(
                              resp["message"].toString(),
                              style: TextStyle(color: Colors.white),
                            );
                          });
                          setState(() {
                            StandbyWid = Text(
                              "Please wait files are uploading 0/" +
                                  fileList.length.toString(),
                              style: TextStyle(color: Colors.white),
                            );
                          });
                          int start = 0;
                          int current = 0;
                          if (fileList.length > 0) {
                            for (int i = 0; i < fileList.length; i++) {
                              var uri =
                                  Uri.parse(_baseUrl + "add_doctors_documents");
                              var request =
                                  new http.MultipartRequest("POST", uri);
                              String fileName =
                                  fileList[i].path.split("/").last;
                              var stream = new http.ByteStream(
                                  DelegatingStream.typed(
                                      fileList[i].openRead()));
                              var length = await fileList[i]
                                  .length(); //imageFile is your image file
                              var multipartFileSign = new http.MultipartFile(
                                  'photo', stream, length,
                                  filename: fileName);
                              request.files.add(multipartFileSign);
                              Map<String, String> headers = {
                                "Accept": "application/json",
                                "Authorization":
                                    "Bearer " + resp["access_token"]
                              };
                              request.headers.addAll(headers);
                              request.fields['dr_id'] =
                                  resp["user_info"]["id"].toString();
                              request.fields['title'] = "TITLE";
                              var response = await request.send();
                              print(response.statusCode);
                              response.stream
                                  .transform(utf8.decoder)
                                  .listen((value) {
                                // showThisToast(value);
                                current++;

                                print(value);
                                setState(() {
                                  StandbyWid = Text(
                                    "Please wait files are uploading " +
                                        current.toString() +
                                        "/" +
                                        fileList.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  );
                                });
                                if (current == (fileList.length)) {
                                  setState(() {
                                    StandbyWid = Text(
                                      "Upload Compleated",
                                      style: TextStyle(color: Colors.white),
                                    );
                                  });
                                  mainD();
                                }
                              });
                            }
                          }
                          //mainD();
                        } else {
                          // showThisToast("User Allreasy registered");
                          setState(() {
                            StandbyWid = Text(
                              "Error occured.Try again",
                              style: TextStyle(color: Colors.white),
                            );
                          });
                        }
                      }
                    },
                    child: StandbyWid,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String getVerifiedNumber() {
    FirebaseUser user = FirebaseAuth.instance.currentUser() as FirebaseUser;
    return user.phoneNumber;
  }
}

//ends
Future<String> uploadMultipleImage(
    File file, String userid, String auth) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = prefs.get(key) ?? 0;

// string to uri

// create multipart request
  var uri = Uri.parse(_baseUrl + "add_doctors_documents");
  var request = new http.MultipartRequest("POST", uri);
  String fileName = file.path.split("/").last;
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length(); //imageFile is your image file
  var multipartFileSign =
      new http.MultipartFile('photo', stream, length, filename: fileName);
  request.files.add(multipartFileSign);
  Map<String, String> headers = {
    "Accept": "application/json",
    "Authorization": auth
  };
  request.headers.addAll(headers);
  request.fields['dr_id'] = userid;
  request.fields['title'] = "TITLE";
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    // showThisToast(value);
    print(value);
  });
}

class PhoneVerificationScreenRecovery extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String verificationId_;

  AuthResult result;

  String phoneNumber;

  PhoneVerificationScreenRecovery(this.phoneNumber);

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // showThisToast("trying with " + phone);

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          //Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            // user is available
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdatePasswordActivity(phone)));
//            if (userType == "p") {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => SignupActivityPatient()));
//            } else {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => SignupActivityDoctor()));
//            }
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          showThisToast("error occured " + exception.message);
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          verificationId_ = verificationId;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                showThisToast("code sent");
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if (user != null) {
                          //veri done
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignupActivityPatient()));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    loginUser(phoneNumber, context);
    return Scaffold(
        body: Center(
      child: Text("Please wait"),
    ));
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
