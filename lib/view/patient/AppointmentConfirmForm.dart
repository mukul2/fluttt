import 'dart:convert';

import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:flutter/material.dart';
import 'package:appxplorebd/networking/Repsonse.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'OnlineDoctorFullProfileView.dart';

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
        body: AppointmentConfirmForm("", "", "", "", "","","",""),
      ),
    );
  }
}

// Create a Form widget.
class AppointmentConfirmForm extends StatefulWidget {
  String docID_, chamberID_, SELECTED_DATE, auth, uid,fees,name,photo;

  AppointmentConfirmForm(
      this.docID_, this.chamberID_, this.SELECTED_DATE, this.auth, this.uid,this.fees,this.name,this.photo);

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
  String myMessage = "";

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
            child: TextFormField(
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
            child: TextFormField(
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
              minLines: 3,
              maxLines: 4,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
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
              keyboardType: TextInputType.phone,
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
                        await performAppointmentSubmit(
                            widget.auth,
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
                      //show page
                      //_ConfirmedAppointmentPageState
                      appTableID =  appointmentSubmitRespons["appointment_id"].toString();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmedAppointmentPage(
                                  appointmentSubmitRespons,widget.fees,widget.docID_,widget.name,widget.photo,"chamber")));

/*

                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);

 */
                    }
                  }
                },
                child: StandbyWid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmedAppointmentPage extends StatefulWidget {
  dynamic response;
  List paymentMethods = [];
  String amount ;
  String docID ;
  String docName;
  String docPhoto;
  String type;
  String  AUTH__;
  String UID__;
  ConfirmedAppointmentPage(this.response,this.amount,this.docID,this.docName,this.docPhoto,this.type);

  @override
  _ConfirmedAppointmentPageState createState() =>
      _ConfirmedAppointmentPageState();
}

class _ConfirmedAppointmentPageState extends State<ConfirmedAppointmentPage> {

  Future<String> getPaymentMethods() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    // AUTH__ = prefs.getString("auth");
   // UID__  = prefs.getString("uid");
    setState(() {
      widget.AUTH__ = prefs.getString("auth");
      widget. UID__  = prefs.getString("uid");
    });
    final http.Response response = await http.get(
      "http://telemedicine.drshahidulislam.com/api/" +
          'get_payment_methods_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.AUTH__,
      },
    );


    this.setState(() {
      widget.paymentMethods = json.decode(response.body);
    });
    //showThisToast(widget.paymentMethods.toString());
    // print(skill_info);

    return "Success!";
  }
  @override
  void initState() {
    this.getPaymentMethods();
    // TODO: implement initState
    super.initState();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done_all,
            size: 50,
          ),
          Text(
            "Your Appointment request has been submitted successfully",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: OutlineButton(
                child: new Text("Make Payment", style: TextStyle(color: Colors.blue)),
                onPressed: () {

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text("Choose Payment Method",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              widget.paymentMethods == null
                                  ? 0
                                  : widget.paymentMethods
                                  .length,
                              itemBuilder:
                                  (BuildContext context,
                                  int index_) {
                                return new InkWell(
                                    onTap: () {
                                      payable_amount =
                                          widget.amount;
                                      docID =
                                          widget.docID;
                                      docNAME = widget.docName;
                                      docPhoto = widget.docPhoto;
                                      type = widget.type;

                                      if (widget.paymentMethods[
                                      index_]["name"] ==
                                          "Paypal") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                                  PaypalPayment(
                                                    type,
                                                    onFinish:
                                                        (number) async {},
                                                  ),
                                            ));
                                      } else if (widget
                                          .paymentMethods[
                                      index_]["name"] ==
                                          "Bank Transfer") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                                  BkashPaymentActivity(
                                                      widget.paymentMethods[
                                                      index_],
                                                      widget.UID__,
                                                      widget.AUTH__,
                                                      payable_amount,
                                                      docID,
                                                      type),
                                            ));
                                      }
                                    },
                                    child: Card(
                                        color: Colors.white,
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              00.0),
                                        ),
                                        child: ListTile(
                                          trailing: Icon(Icons
                                              .arrow_right),
                                          title: Text(widget
                                              .paymentMethods[
                                          index_]["name"]),
                                        )));
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  );


//                  scaffoldKey.currentState
//                      .showBottomSheet((context) => Container(
//                    width: double.infinity,
//                    child: Column(
//                      crossAxisAlignment:
//                      CrossAxisAlignment.start,
//                      children: [
//                        Padding(
//                          padding: EdgeInsets.all(15),
//                          child: Text(
//                            "Choose a Payment Method",
//                            style: TextStyle(
//                                fontSize: 18,
//                                fontWeight:
//                                FontWeight.bold),
//                          ),
//                        ),
//                        ListView.builder(
//                          shrinkWrap: true,
//                          itemCount:
//                          widget.paymentMethods == null
//                              ? 0
//                              : widget.paymentMethods
//                              .length,
//                          itemBuilder:
//                              (BuildContext context,
//                              int index_) {
//                            return new InkWell(
//                                onTap: () {
//                                  payable_amount =widget.amount;
//                                  docID = widget.docID;
//                                  docNAME = widget.docName;
//                                  docPhoto = widget.docPhoto;
//                                  String  type = widget.type;
//
//                                  if (widget.paymentMethods[
//                                  index_]["name"] ==
//                                      "Paypal") {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (BuildContext
//                                          context) =>
//                                              PaypalPayment(
//                                                type,
//                                                onFinish:
//                                                    (number) async {},
//                                              ),
//                                        ));
//                                  } else if (widget
//                                      .paymentMethods[
//                                  index_]["name"] ==
//                                      "Bank Transfer") {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (BuildContext
//                                          context) =>
//                                              BkashPaymentActivity(
//                                                  widget.paymentMethods[
//                                                  index_],
//                                                  widget.UID__,
//                                                  widget.AUTH__,
//                                                  payable_amount,
//                                                  docID,
//                                                  type),
//                                        ));
//                                  }
//                                },
//                                child: Card(
//                                    color: Colors.white70,
//                                    shape:
//                                    RoundedRectangleBorder(
//                                      borderRadius:
//                                      BorderRadius
//                                          .circular(
//                                          00.0),
//                                    ),
//                                    child: ListTile(
//                                      trailing: Icon(Icons
//                                          .arrow_right),
//                                      title: Text(widget
//                                          .paymentMethods[
//                                      index_]["name"]),
//                                    )));
//                          },
//                        ),
//                      ],
//                    ),
//                    margin: const EdgeInsets.only(
//                        top: 5, left: 15, right: 15),
//                    color: Colors.white,
//                  ));
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0))),
          )
        ],
      )),
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
