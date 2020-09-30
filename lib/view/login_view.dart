import 'dart:convert';
import 'dart:io';
import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/patient/another_map.dart';
import 'package:appxplorebd/view/patient/myMapViewActivity.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";

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
        body: MyCustomForm(),
      ),
    );
  }
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
                      color: widget.userType == "p" ?Colors.blue:Colors.white,
                      child: ListTile(

                       // trailing: Icon(Icons.face, color: widget.userType == "p" ?Colors.white:Colors.blue,),
                        title: Center(
                          child: Text(
                            "Patient",
                            style: TextStyle(
                                color: widget.userType == "p" ?Colors.white:Colors.blue, fontWeight: FontWeight.bold),
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
                      color: widget.userType == "d" ?Colors.blue:Colors.white,
                      child:  ListTile(
                       // trailing: Icon(Icons.face,color: widget.userType == "d" ?Colors.white:Colors.blue,),

                        title: Center(
                          child: Text(
                            "Health Care Provider",
                            style: TextStyle(
                                color: widget.userType == "d" ?Colors.white:Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: InkWell(
                child: Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CheckPhoneIntegForm(widget.userType))); //
                        },
                        child: Text(
                          "NEXT",style: TextStyle(color: Colors.white),
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
    style: TextStyle(color: Colors.white),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
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
          Center(
            child: Container(
              height: 150,
              width: 250,
              child: Image.asset("assets/logo2.jpeg"),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              initialValue: "",
              validator: (value) {
                email = value;
                if (value.isEmpty) {
                  return 'Please enter Email';
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
              initialValue: "",
              validator: (value) {
                password = value;
                if (value.isEmpty) {
                  return 'Please enter Password';
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
              keyboardType: TextInputType.visiblePassword,
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

                      LoginResponse loginResponse =
                          await performLogin(email, password);
                      print(loginResponse.toString());
                      //  showThisToast(loginResponse.message);
                      setState(() {
                        StandbyWid = Text(loginResponse.message);
                      });
                     
                      if (loginResponse.status) {
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
                        prefs.setString(
                            "uphone", loginResponse.userInfo.phone.toString());
                        prefs.setString(
                            "uphoto", loginResponse.userInfo.photo.toString());
                        prefs.setString(
                            "uemail", loginResponse.userInfo.email.toString());
                        prefs.setString("utype",
                            loginResponse.userInfo.userType.toString());
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
                  color: Colors.deepPurple,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

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
                initialValue: "+447466481593",
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

                          if (false) {
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
                              "User Allready registered",
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
  String myMessage = "Signup";

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
              "Signup as Patient",
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
  ChooseDocument(this.fileList, {Key key, this.function})
      : super(key: key);

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
            onTap: (){
               widget.function(widget.fileList);
               Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20,0),
              child: Center(child: Text("Done",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),),
            )
          )

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async {
        File image = await FilePicker.getFile();
//        final Map<String, File> data =
//        new Map<String, File>();
//        data['link'] = image;
        setState(() {
          widget. fileList.add(image);
        });

      }, label: Text("Pick from Device")),
      body: true
          ? ListView.builder(
              itemCount:
              widget. fileList == null ? 0 :widget. fileList.length,
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
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: Icon(Icons.add),
                          title: new Text(
                            widget.fileList[index].path,
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
      showThisToast("dept size " + deptList.length.toString());
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
                                 selectDocumentHint = ""+data.length.toString()+" documents selected";
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
                              "Please wait files are uploading 0/"+fileList.length.toString(),
                              style: TextStyle(color: Colors.white),
                            );
                          });
                          int start = 0 ;
                          int current = 0 ;
                          if(fileList.length>0) {
                            for (int i = 0; i < fileList.length; i++) {
                              var uri = Uri.parse(_baseUrl + "add_doctors_documents");
                              var request = new http.MultipartRequest("POST", uri);
                              String fileName = fileList[i].path.split("/").last;
                              var stream = new http.ByteStream(DelegatingStream.typed( fileList[i].openRead()));
                              var length = await  fileList[i].length(); //imageFile is your image file
                              var multipartFileSign = new http.MultipartFile('photo', stream, length, filename: fileName);
                              request.files.add(multipartFileSign);
                              Map<String, String> headers = {
                                "Accept": "application/json",
                                "Authorization": "Bearer " + resp["access_token"]
                              };
                              request.headers.addAll(headers);
                              request.fields['dr_id'] = resp["user_info"]["id"].toString();
                              request.fields['title'] = "TITLE";
                              var response = await request.send();
                              print(response.statusCode);
                              response.stream.transform(utf8.decoder).listen((value) {
                                showThisToast(value);
                                current ++;

                                print(value);
                                setState(() {
                                  StandbyWid = Text(
                                    "Please wait files are uploading "+current.toString()+"/"+fileList.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  );
                                });
                                if(current== (fileList.length)){
                                  setState(() {
                                    StandbyWid = Text(
                                      "Upload Compleated",
                                      style: TextStyle(color: Colors.white),
                                    );
                                  });mainD();
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
Future<String> uploadMultipleImage(File file, String userid,String auth) async {
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
  var multipartFileSign = new http.MultipartFile('photo', stream, length, filename: fileName);
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
    showThisToast(value);
    print(value);
  });
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
