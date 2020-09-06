import 'dart:convert';

import 'package:appxplorebd/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:appxplorebd/networking/Repsonse.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String dID, cID;
String DATE = "";

class AppointmentConfirmForm___ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: AppointmentConfirmForm("", "","","",""),
      ),
    );
  }
}

// Create a Form widget.
class AppointmentConfirmForm extends StatefulWidget {
  String docID_, chamberID_, SELECTED_DATE,auth,uid;

  AppointmentConfirmForm(this.docID_, this.chamberID_, this.SELECTED_DATE,this.auth,this.uid);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<AppointmentConfirmForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String name, problem, contact;
  String myMessage = "Login";

  Widget StandbyWid = Text("Submit", style: TextStyle(color: Colors.white));
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:  TextFormField(

              validator: (value) {
                name = value;
                if (value.isEmpty) {
                  return 'Please write patient name';
                }
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: "Write your name"),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:  TextFormField(

              validator: (value) {
                problem = value;
                if (value.isEmpty) {
                  return 'Write problems/symptoms';
                }
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: "Write your problems/symptoms"),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:  TextFormField(

              validator: (value) {
                contact = value;
                if (value.isEmpty) {
                  return 'Contact phone number';
                }
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: 'Contact phone number'),
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
                  color: Colors.pink,
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      setState(() {
                        StandbyWid = Text(
                          "Please wait",
                          style: TextStyle(color: Colors.white),
                        );
                      });


                      var appointmentSubmitRespons =
                      await performAppointmentSubmit(widget.auth,
                          widget.uid,
                          widget.docID_,
                          problem,
                          contact,
                          name,
                          widget.chamberID_,
                          widget.SELECTED_DATE,
                          "0",
                          "n");
                      if (appointmentSubmitRespons["status"]) {
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                  child: StandbyWid,
                ),),
          ),


        ],
      ),
    );
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
