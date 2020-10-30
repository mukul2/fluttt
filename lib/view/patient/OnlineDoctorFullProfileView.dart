import 'dart:io';
import 'dart:math';

import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/networking/indFileOne.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;

List skill_info;
List education_info;
String AUTH_KEY;
String UID;
String type = "";
String CLIEND_ID = "xploreDoc";

final String _baseUrl = "https://appointmentbd.com/api/";

class OnlineDoctorFullProfileView extends StatefulWidget {
  String name;
  String photo;
  String designation_title;
  List online_doctors_service_info;
  int id;
  List paymentMethods = [];
  String auth,uid;

  dynamic subscriptionStatus;

  OnlineDoctorFullProfileView(this.id, this.name, this.photo,
      this.designation_title, this.online_doctors_service_info);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorFullProfileView> {
  bool shouldPurChase = true;

  Function funtionChangeState;

  Future<String> getData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    UID = prefs.getString("uid");

    setState(() {
      widget.auth = prefs.getString("auth");
      widget.uid = prefs.getString("uid");
    });

    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.auth,
      },
      body: jsonEncode(<String, String>{'dr_id': widget.id.toString()}),
    );

    this.setState(() {
      skill_info = json.decode(response.body)["skill_info"];
      education_info = json.decode(response.body)["education_info"];
    });

    //  print(skill_info);

    return "Success!";
  }

  Future<String> getSubscriptions() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    String uid_ = prefs.getString("uid");

    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'check_subscriptions',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'dr_id': widget.id.toString(), 'patient_id': uid_}),
    );
    print(response.body);
    //showThisToast(response.body);

    this.setState(() {
      //showThisToast(response.body);
      widget.subscriptionStatus = json.decode(response.body);
      // this.getData();
      // this.getPaymentMethods();
    });

    print(skill_info);

    return "Success!";
  }

  Future<String> getPaymentMethods() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    UID = prefs.getString("uid");
    final http.Response response = await http.get(
      "https://appointmentbd.com/api/" + 'get_payment_methods_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
    );
    //showThisToast(response.body);

    this.setState(() {
      widget.paymentMethods = json.decode(response.body);
    });

    // print(skill_info);

    return "Success!";
  }

  @override
  void initState() {
    docID = widget.id.toString();
    docNAME = widget.name;
    docPhoto = widget.photo;
    this.getSubscriptions();
    this.getData();
    this.getPaymentMethods();
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(widget.name),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "Services",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Skills"),
              Tab(icon: Icon(Icons.school), text: "Education"),
            ],
          ),
        ),
        key: scaffoldKey,
        body: TabBarView(
          children: [
//            Services((widget.online_doctors_service_info), widget.id,widget.name,widget.photo),
            ListView.builder(
              itemCount: widget.online_doctors_service_info == null
                  ? 0
                  : widget.online_doctors_service_info.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(00.0),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: new Text(
                            widget.online_doctors_service_info[index]
                                ["service_name_info"]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                          child: new Text(
                            (widget.online_doctors_service_info[index]
                                        ["fees_per_unit"])
                                    .toString() +
                                CURRENCY_USD_SIGN,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
//                        trailing: RaisedButton(
//                          color: Colors.pink,
//                          child: getPurchsedTrace(
//                              widget.online_doctors_service_info[index]
//                              ["service_name_info"]["name"],
//                              widget.subscriptionStatus,widget.online_doctors_service_info[index]
//                          ),
//                          onPressed: () {
//                            // makePayment();
//                            if (shouldPurChase) {
//                              payable_amount =
//                                  (widget.online_doctors_service_info[index]
//                                  ["fees_per_unit"])
//                                      .toString();
//                              docID = widget.id.toString();
//                              docNAME = widget.name;
//                              docPhoto = widget.photo;
//                              type = (widget.online_doctors_service_info[index]
//                              ["service_name_info"]["name"])
//                                  .toString();
//                              showThisToast(type);
//                              scaffoldKey.currentState
//                                  .showBottomSheet((context) => Container(
//                                width: double.infinity,
//                                child: Column(
//                                  crossAxisAlignment:
//                                  CrossAxisAlignment.start,
//                                  children: [
//                                    Padding(
//                                      padding: EdgeInsets.all(15),
//                                      child: Text(
//                                        "Choose a Payment Method",
//                                        style: TextStyle(
//                                            fontSize: 18,
//                                            fontWeight:
//                                            FontWeight.bold),
//                                      ),
//                                    ),
//                                    ListView.builder(
//                                      shrinkWrap: true,
//                                      itemCount:
//                                      widget.paymentMethods == null
//                                          ? 0
//                                          : widget.paymentMethods
//                                          .length,
//                                      itemBuilder:
//                                          (BuildContext context,
//                                          int index_) {
//                                        return new InkWell(
//                                            onTap: () {
//                                              payable_amount =
//                                                  (widget.online_doctors_service_info[
//                                                  index][
//                                                  "fees_per_unit"])
//                                                      .toString();
//                                              docID =
//                                                  widget.id.toString();
//                                              docNAME = widget.name;
//                                              docPhoto = widget.photo;
//                                              type = (widget.online_doctors_service_info[
//                                              index][
//                                              "service_name_info"]
//                                              ["name"])
//                                                  .toString();
//
//                                              if (widget.paymentMethods[
//                                              index_]["name"] ==
//                                                  "Paypal") {
//                                                Navigator.push(
//                                                    context,
//                                                    MaterialPageRoute(
//                                                      builder: (BuildContext
//                                                      context) =>
//                                                          PaypalPayment(
//                                                            type,
//                                                            onFinish:
//                                                                (number) async {},
//                                                          ),
//                                                    ));
//                                              } else if (widget
//                                                  .paymentMethods[
//                                              index_]["name"] ==
//                                                  "Bank Transfer") {
//                                                Navigator.push(
//                                                    context,
//                                                    MaterialPageRoute(
//                                                      builder: (BuildContext
//                                                      context) =>
//                                                          BkashPaymentActivity(
//                                                              widget.paymentMethods[
//                                                              index_],
//                                                              UID,
//                                                              AUTH_KEY,
//                                                              payable_amount,
//                                                              docID,
//                                                              type),
//                                                    ));
//                                              }
//                                            },
//                                            child: Card(
//                                                color: Colors.white70,
//                                                shape:
//                                                RoundedRectangleBorder(
//                                                  borderRadius:
//                                                  BorderRadius
//                                                      .circular(
//                                                      00.0),
//                                                ),
//                                                child: ListTile(
//                                                  trailing: Icon(Icons
//                                                      .arrow_right),
//                                                  title: Text(widget
//                                                      .paymentMethods[
//                                                  index_]["name"]),
//                                                )));
//                                      },
//                                    ),
//                                  ],
//                                ),
//                                margin: const EdgeInsets.only(
//                                    top: 5, left: 15, right: 15),
//                                color: Colors.white,
//                              ));
//                            }
//                          },
//                        ),
                        trailing: getPurchsedTrace(
                            widget.online_doctors_service_info[index]
                                ["service_name_info"]["name"],
                            widget.subscriptionStatus,
                            widget.online_doctors_service_info[index]),
                      ),
                    ));
              },
            ),
            Skills(skill_info),
            Educations(education_info)
          ],
        ),
      ),
    );
  }

  Widget getPurchsedTrace(String serviceName, dynamic allStatus,
      dynamic online_doctors_service_info) {
    //shouldPurChase = true;
    String direction = "Purchase";
    print(serviceName);

    bool isActivated = false;

    if (allStatus != null) {
      if (serviceName == "Video Call") {
        if (allStatus["video"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }

      if (serviceName == "Chat") {
        if (allStatus["chat"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }

      if (serviceName == "1 Month Subscription") {
        if (allStatus["one"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }
      if (serviceName == "3 Month Subscription") {
        if (allStatus["three"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }

      if (serviceName == "6 Month Subscription") {
        if (allStatus["six"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }

      if (serviceName == "12 Month Subscription") {
        if (allStatus["year"].toString() != "0") {
          direction = "Already Purchased";
          print("Already Purchased " + serviceName);
          isActivated = true;
        }
      }
    }
    shouldPurChase = !isActivated;

    return InkWell(
      onTap: () {
        docID = widget.id.toString();
        docNAME = widget.name;
        docPhoto = widget.photo;
        type = (online_doctors_service_info["service_name_info"]["name"])
            .toString();
        // makePayment();
        if (!isActivated) {
          payable_amount = (["fees_per_unit"]).toString();

          // showThisToast(type);
          scaffoldKey.currentState.showBottomSheet((context) => Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Choose a Payment Method",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.paymentMethods == null
                          ? 0
                          : widget.paymentMethods.length,
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                            onTap: () async {
                              payable_amount =
                                  (online_doctors_service_info["fees_per_unit"])
                                      .toString();
                              docID = widget.id.toString();
                              docNAME = widget.name;
                              docPhoto = widget.photo;
                              type = (online_doctors_service_info[
                                      "service_name_info"]["name"])
                                  .toString();

                              if (widget.paymentMethods[index_]["name"] ==
                                  "Paypal") {
                                fun(number)async{
                                  print('order id: '+number);
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PaypalPayment(
                                        type,
                                              AUTH_KEY,UID,

                                       fun
                                      ),
                                    ));
                              } else if (widget.paymentMethods[index_]
                                      ["name"] ==
                                  "Bank Transfer") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BkashPaymentActivity(
                                              widget.paymentMethods[index_],
                                              UID,
                                              AUTH_KEY,
                                              payable_amount,
                                              docID,
                                              type),
                                    ));
                              } else if (widget.paymentMethods[index_]
                                      ["name"] ==
                                  "Pay Later") {
                                if (type == "Prescription Service") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MakePrescriptionRequestWidget(
                                                  AUTH_KEY,
                                                  UID,
                                                  "No trans id",
                                                  payable_amount,
                                                  docID,
                                                  "0",
                                                  payable_amount,
                                                  "1")));
                                } else  if (type == "Prescription Review") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChoosePrescriptionForPrescriptionreview(AUTH_KEY,UID, docID,"No Trans id",
                                                 "0","1","0")));
                                }  else if (type == "Video Call") {


                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_video_appointment_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'doctor_id': docID,
                                      'payment_details': "No trans id",
                                      'payment_status': "0",
                                      'amount': payable_amount,
                                      'is_review_appointment': "1",
                                      'isPaymentPending': "1",

                                    }),
                                  );

                                  if(response.statusCode==200){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }


                                }else if (type == "Follow up Video Appointment") {
                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_video_appointment_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'doctor_id': docID,
                                      'payment_details': "No trans id",
                                      'payment_status': "0",
                                      'amount': payable_amount,
                                      'is_review_appointment': "1",
                                      'isPaymentPending': "1",
                                    }),
                                  );


                                  if(response.statusCode==200){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                  // Navigator.of(context).pop();
                                }else if (type == '1 Month Subscription') {
                                  DateTime selectedDate = DateTime.now();
                                  String startDate = (selectedDate.year).toString() +
                                      "-" +
                                      (selectedDate.month).toString() +
                                      "-" +
                                      (selectedDate.day).toString();
                                  DateTime endDate_ =
                                  DateTime.now().add((Duration(days: 30)));
                                  endDate_.add((Duration(days: 30)));
                                  String endDate =
                                      (DateTime.now().add((Duration(days: 30))).year)
                                          .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 30))).month)
                                              .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 30))).day)
                                              .toString();

                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_subscription_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'dr_id': docID,
                                      'payment_status': "0",
                                      'number_of_months': "1",
                                      'payment_details': "No trans id",
                                      'starts': startDate,
                                      'amount': payable_amount,
                                      'ends': endDate,
                                      'status': "1",
                                      'isPaymentPending': "1",

                                    }),
                                  );
                                  // showThisToast(response.statusCode.toString());
                                  //popup count
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                } else if (type == '3 Month Subscription') {
                                  DateTime selectedDate = DateTime.now();
                                  String startDate = (selectedDate.year).toString() +
                                      "-" +
                                      (selectedDate.month).toString() +
                                      "-" +
                                      (selectedDate.day).toString();

                                  selectedDate.add((Duration(days: 90)));
                                  String endDate =
                                      (DateTime.now().add((Duration(days: 90))).year)
                                          .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 90))).month)
                                              .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 90))).day)
                                              .toString();

                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_subscription_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'dr_id': docID,
                                      'payment_status': "0",
                                      'number_of_months': "3",
                                      'payment_details': "No trans id",
                                      'starts': startDate,
                                      'amount': payable_amount,
                                      'ends': endDate,
                                      'status': "1",

                                      'isPaymentPending': "1",
                                    }),
                                  );
                                  // showThisToast(response.statusCode.toString());
                                  //popup count
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  //  Navigator.of(context).pop();
                                } else if (type== '6 Month Subscription') {
                                  DateTime selectedDate = DateTime.now();
                                  String startDate = (selectedDate.year).toString() +
                                      "-" +
                                      (selectedDate.month).toString() +
                                      "-" +
                                      (selectedDate.day).toString();

                                  selectedDate.add((Duration(days: 180)));
                                  String endDate =
                                      (DateTime.now().add((Duration(days: 180))).year)
                                          .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 180))).month)
                                              .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 180))).day)
                                              .toString();
                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_subscription_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'dr_id': docID,
                                      'payment_status': "0",
                                      'number_of_months': "6",
                                      'payment_details': "No trans id",
                                      'starts': startDate,
                                      'amount': payable_amount,
                                      'ends': endDate,
                                      'status': "1",

                                      'isPaymentPending': "1",
                                    }),
                                  );
                                  //  showThisToast(response.statusCode.toString());
                                  //popup count
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  //Navigator.of(context).pop();
                                } else if (type == '1 Year Subscription') {
                                  DateTime selectedDate = DateTime.now();
                                  String startDate = (selectedDate.year).toString() +
                                      "-" +
                                      (selectedDate.month).toString() +
                                      "-" +
                                      (selectedDate.day).toString();

                                  selectedDate.add((Duration(days: 360)));
                                  String endDate =
                                      (DateTime.now().add((Duration(days: 360))).year)
                                          .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 360))).month)
                                              .toString() +
                                          "-" +
                                          (DateTime.now().add((Duration(days: 360))).day)
                                              .toString();

                                  final http.Response response = await http.post(
                                    _baseUrl + 'add_subscription_info',
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'patient_id': UID,
                                      'dr_id': docID,
                                      'payment_status': "0",
                                      'number_of_months': "12",
                                      'payment_details': "No trans id",
                                      'starts': startDate,
                                      'amount': payable_amount,
                                      'ends': endDate,
                                      'status': "1",

                                      'isPaymentPending': "1",
                                    }),
                                  );

                                  // showThisToast(response.statusCode.toString());
                                  // showThisToast(response.body);
                                  //popup count
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                }
                              }
                            },
                            child: Card(
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(00.0),
                                ),
                                child: ListTile(
                                  trailing: Icon(Icons.arrow_right),
                                  title: Text(
                                      widget.paymentMethods[index_]["name"]),
                                )));
                      },
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                color: Colors.white,
              ));
        } else {
          if (type == "Video Call") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          } else if (type == "Chat") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          } else if (type == "1 Month Subscription") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          } else if (type == "3 Month Subscription") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          } else if (type == "6 Month Subscription") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          } else if (type == "1 Year Subscription") {
            String chatRoom =
                createChatRoomName(int.parse(UID), int.parse(docID));
            CHAT_ROOM = chatRoom;
            //   showThisToast("chat room " + CHAT_ROOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(docID, docNAME, docPhoto,
                        UID, UNAME, UPHOTO, chatRoom)));
          }
          //showThisToast("Already purchased" +"   "+docID+"  "+docNAME+"  "+type);
        }
      },
      child: Card(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            direction,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class BkashPaymentActivity extends StatefulWidget {
  String uid, auth, amount, docid, TYPE,USER_NAME,USER_PHOTO;
  dynamic paymentMethodBody;

  BkashPaymentActivity(this.paymentMethodBody, this.uid, this.auth, this.amount,
      this.docid, this.TYPE);

  @override
  _BkashPaymentActivityState createState() => _BkashPaymentActivityState();
}

class _BkashPaymentActivityState extends State<BkashPaymentActivity> {

  @override
  void initState() async{
    // TODO: implement initState
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;


    setState(() {
      widget.USER_NAME = prefs.getString("uname");
      widget.USER_PHOTO = prefs.getString("uphoto");
    });
  }
  final _formKey = GlobalKey<FormState>();
  String transID;
  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );
  String imageLink = null;

  File selectedImage = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Transfer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("Bank Marchant"),
                    subtitle: Text(widget.paymentMethodBody["marchant"] +
                        '\n' +
                        "Make " +
                        widget.paymentMethodBody["name"] +
                        " transfer and add transaction ID here"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      initialValue: "",
                      validator: (value) {
                        transID = value;
                        if (value.isEmpty) {
                          return 'Please enter transaction ID';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Transaction ID"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: InkWell(
                        onTap: () async {
                          File image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            selectedImage = image;
                          });
                        },
                        child: Card(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Add Screenshot",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: setImage(selectedImage),
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

                              if (widget.TYPE == 'chamber') {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'amount': payable_amount,
                                  'status': "0",
                                  'reason': "Chamber Appointment",
                                  'transID': transID,
                                  'table_id': appTableID,
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) =>
//                                              MakePrescriptionRequestWidget(
//                                                  widget.auth,
//                                                  widget.uid,
//                                                  transID,
//                                                  payable_amount,
//                                                  widget.docid,
//                                                  val["message"].toString(),
//                                                  widget.amount)));
                                }

                                print(body);

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only_for_chamber_appoiontment',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only_for_chamber_appoiontment',
                                      function_name);
                                }
                              } else if (widget.TYPE ==
                                  'Prescription Service') {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'amount': payable_amount,
                                  'status': "0",
                                  'reason': "Prescription request",
                                  'transID': transID,
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MakePrescriptionRequestWidget(
                                                  widget.auth,
                                                  widget.uid,
                                                  transID,
                                                  payable_amount,
                                                  widget.docid,
                                                  val["message"].toString(),
                                                  widget.amount,
                                                  "0")));
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only',
                                      function_name);
                                }
                              } else if (widget.TYPE ==
                                  '1 Month Subscription') {
                                DateTime selectedDate = DateTime.now();
                                String startDate =
                                    (selectedDate.year).toString() +
                                        "-" +
                                        (selectedDate.month).toString() +
                                        "-" +
                                        (selectedDate.day).toString();
                                DateTime endDate_ =
                                    DateTime.now().add((Duration(days: 30)));
                                endDate_.add((Duration(days: 30)));
                                String endDate = (DateTime.now()
                                            .add((Duration(days: 30)))
                                            .year)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 30)))
                                            .month)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 30)))
                                            .day)
                                        .toString();

                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'payment_status': "0",
                                  'number_of_months': "1",
                                  'payment_details': transID,
                                  'starts': startDate,
                                  'amount': widget.amount,
                                  'ends': endDate,
                                  'status': "0",
                                  'isPaymentPending': "0",
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                }

                                // showThisToast(response.statusCode.toString());
                                //popup count

                                // Navigator.of(context).pop();
                              } else if (widget.TYPE ==
                                  '3 Month Subscription') {
                                DateTime selectedDate = DateTime.now();
                                String startDate =
                                    (selectedDate.year).toString() +
                                        "-" +
                                        (selectedDate.month).toString() +
                                        "-" +
                                        (selectedDate.day).toString();

                                selectedDate.add((Duration(days: 90)));
                                String endDate = (DateTime.now()
                                            .add((Duration(days: 90)))
                                            .year)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 90)))
                                            .month)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 90)))
                                            .day)
                                        .toString();

                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'payment_status': "0",
                                  'number_of_months': "3",
                                  'payment_details': transID,
                                  'starts': startDate,
                                  'amount': widget.amount,
                                  'ends': endDate,
                                  'status': "0",
                                  'isPaymentPending': "0",
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                }
                                //  Navigator.of(context).pop();
                              } else if (widget.TYPE ==
                                  '6 Month Subscription') {
                                DateTime selectedDate = DateTime.now();
                                String startDate =
                                    (selectedDate.year).toString() +
                                        "-" +
                                        (selectedDate.month).toString() +
                                        "-" +
                                        (selectedDate.day).toString();

                                selectedDate.add((Duration(days: 180)));
                                String endDate = (DateTime.now()
                                            .add((Duration(days: 180)))
                                            .year)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 180)))
                                            .month)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 180)))
                                            .day)
                                        .toString();
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'payment_status': "0",
                                  'number_of_months': "6",
                                  'payment_details': transID,
                                  'starts': startDate,
                                  'amount': widget.amount,
                                  'ends': endDate,
                                  'status': "0",
                                  'isPaymentPending': "0",
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                }
                              } else if (widget.TYPE == '1 Year Subscription') {
                                DateTime selectedDate = DateTime.now();
                                String startDate =
                                    (selectedDate.year).toString() +
                                        "-" +
                                        (selectedDate.month).toString() +
                                        "-" +
                                        (selectedDate.day).toString();

                                selectedDate.add((Duration(days: 360)));
                                String endDate = (DateTime.now()
                                            .add((Duration(days: 360)))
                                            .year)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 360)))
                                            .month)
                                        .toString() +
                                    "-" +
                                    (DateTime.now()
                                            .add((Duration(days: 360)))
                                            .day)
                                        .toString();

                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'payment_status': "0",
                                  'number_of_months': "12",
                                  'payment_details': transID,
                                  'starts': startDate,
                                  'amount': widget.amount,
                                  'ends': endDate,
                                  'status': "0",
                                  'isPaymentPending': "0",
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_subscription_info',
                                      function_name);
                                }
                                // Navigator.of(context).pop();
                              } else if (widget.TYPE == 'Chat') {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'amount': widget.amount,
                                  'payment_details': transID,
                                  'status': "0"
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  //Navigator.of(context).pop();
                                  String chatRoom = createChatRoomName(
                                      int.parse(widget.uid),
                                      int.parse(widget.docid));
                                  CHAT_ROOM = chatRoom;
                                  print("chat room " + chatRoom);
                                  DatabaseReference _messageDatabaseReference;
                                  DatabaseReference
                                      _messageDatabaseReference_last;
                                  _messageDatabaseReference = FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child(CLIEND_ID)
                                      .child("chatHistory")
                                      .child(CHAT_ROOM);

                                  _messageDatabaseReference_last =
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child(CLIEND_ID)
                                          .child("lastChatHistory");

                                  USER_ID = widget.uid;
                                  docID = widget.docid;

                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("message_body")
                                      .set(
                                          "Chat service payment is compleated");
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("message_type")
                                      .set("TYPE_TEXT");
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("receiver_name")
                                      .set(docNAME);
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("receiver_photo")
                                      .set(docPhoto);
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("recever_id")
                                      .set((docID));
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("sender_id")
                                      .set(USER_ID);
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("sender_name")
                                      .set(widget.USER_NAME);
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("sender_photo")
                                      .set(widget.USER_PHOTO);
                                  _messageDatabaseReference_last
                                      .child(USER_ID)
                                      .child(docID)
                                      .child("time")
                                      .set(new DateTime.now()
                                          .toUtc()
                                          .toIso8601String());

                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("message_body")
                                      .set(
                                          "Chat service payment is compleated");
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("message_type")
                                      .set("TYPE_TEXT");
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("receiver_name")
                                      .set(docNAME);
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("receiver_photo")
                                      .set(docPhoto);
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("recever_id")
                                      .set((docID));
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("sender_id")
                                      .set(USER_ID);
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("sender_name")
                                      .set(UNAME);
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("sender_photo")
                                      .set(widget.USER_PHOTO);
                                  _messageDatabaseReference_last
                                      .child(docID)
                                      .child(USER_ID)
                                      .child("time")
                                      .set(new DateTime.now()
                                          .toUtc()
                                          .toIso8601String());
                                  mainP();
                                  //  showThisToast("Please wait while your pending transaction gets approved");

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              widget.uid,
                                              widget.USER_NAME,
                                              widget.USER_PHOTO,
                                              widget.docid,
                                              docNAME,
                                              docPhoto,
                                              chatRoom)));
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_chat_appointment_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_chat_appointment_info',
                                      function_name);
                                }
                              } else if (widget.TYPE == "Video Call") {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'doctor_id': widget.docid,
                                  'payment_details': transID,
                                  'amount': widget.amount,
                                  'is_review_appointment': "0",
                                  'payment_status': "0",
                                };

                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };

                                function_name(data) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  showThisToast(
                                      "Please wait while your pending transaction gets approved");
                                }

                                //  showThisToast(body.toString());

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_video_appointment_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_video_appointment_info',
                                      function_name);
                                }
                              } else if (widget.TYPE == "Prescription Review") {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'dr_id': widget.docid,
                                  'amount': widget.amount,
                                  'status': "0",
                                  'reason': "Prescription review",
                                  'transID': transID,
                                };
                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };
                                function_name(val) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChoosePrescriptionForPrescriptionreview(
                                                  widget.auth,
                                                  widget.uid,
                                                  widget.docid,
                                                  transID,
                                                  val["message"].toString(),"0","0")));
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_payment_info_only',
                                      function_name);
                                }
                              } else if (widget.TYPE ==
                                  "Follow up Video Appointment") {
                                Map<String, String> body = <String, String>{
                                  'patient_id': widget.uid,
                                  'doctor_id': widget.docid,
                                  'payment_details': transID,
                                  'payment_status': "0",
                                  'amount': widget.amount,
                                  'is_review_appointment': "1",
                                };

                                Map<String, String> header = <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': widget.auth,
                                };

                                function_name(data) {
                                  // mainP();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  showThisToast(
                                      "Please wait while your pending transaction gets approved");
                                }

                                if (selectedImage == null) {
                                  apiRequestWithMultipart(
                                      null,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_video_appointment_info',
                                      function_name);
                                } else {
                                  apiRequestWithMultipart(
                                      selectedImage,
                                      header,
                                      body,
                                      _baseUrl,
                                      'add_video_appointment_info',
                                      function_name);
                                }
                              } else {
                                //   showThisToast("Unknwon service " + widget.TYPE);
                              }
                              setState(() {
                                StandbyWid = Text("Please wait");
                              });

                              int start = 0;
                              int current = 0;

                              //mainD();
                            } else {
                              // showThisToast("User Allreasy registered");

                            }
                          },
                          child: StandbyWid,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget setImage(File selectedImage) {
    if (selectedImage != null) {
      return Image.file(selectedImage);
    } else {
      return Text("");
    }
  }
}

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}
//
//Widget Services(
//    List online_doctors_service_info, int id, String name, String photo) {
//  print(online_doctors_service_info);
//  return new ListView.builder(
//    itemCount: online_doctors_service_info == null
//        ? 0
//        : online_doctors_service_info.length,
//    itemBuilder: (BuildContext context, int index) {
//      return new InkWell(
//          onTap: () {
////            Navigator.push(
////                context,
////                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
//          },
//          child: Card(
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(00.0),
//            ),
//            child: ListTile(
//              title: Padding(
//                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
//                child: new Text(
//                  online_doctors_service_info[index]["service_name_info"]
//                      ["name"],
//                  style: TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              subtitle: Padding(
//                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
//                child: new Text(
//                  (online_doctors_service_info[index]["fees_per_unit"])
//                          .toString() +
//                      CURRENCY_USD_SIGN,
//                  style: TextStyle(fontWeight: FontWeight.bold),
//                ),
//              ),
//              trailing: RaisedButton(
//                color: Colors.pink,
//                child: Text(
//                  "Purchase",
//                  style: TextStyle(color: Colors.white),
//                ),
//                onPressed: () {
//                  // makePayment();
//                  payable_amount = (online_doctors_service_info[index]
//                          ["fees_per_unit"])
//                      .toString();
//                  docID = id.toString();
//                  docNAME = name;
//                  docPhoto = photo;
//                  type = (online_doctors_service_info[index]
//                          ["service_name_info"]["name"])
//                      .toString();
//                  showThisToast(type);
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (BuildContext context) => PaypalPayment(type,
//                          onFinish: (number) async {
////                            String reason;
////                            String doc_id = online_doctors_service_info[index]
////                                ["service_name_info"]["name"];
////
////                            // payment done
////                            showThisToast('order id: ' + number);
////                            print('order id: ' + number);
////                            if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                'Prescription Review') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                'Video Call') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                'Prescription Service') {
////                              //Prescription request
////                              reason = "Prescription request";
////                              final http.Response response = await http.post(
////                                _baseUrl + 'add_payment_info_only',
////                                headers: <String, String>{
////                                  'Content-Type':
////                                      'application/json; charset=UTF-8',
////                                  'Authorization': AUTH_KEY,
////                                },
////                                body: jsonEncode(<String, String>{
////                                  'patient_id': USER_ID,
////                                  'dr_id': id.toString(),
////                                  'amount': (online_doctors_service_info[index]
////                                          ["fees_per_unit"])
////                                      .toString(),
////                                  'reason': reason
////                                }),
////                              );
////                              showThisToast("Api response "+response.statusCode.toString());
////
////                              //Navigator.of(context).pop();
////
////                              Navigator.push(
////                                  context,
////                                  MaterialPageRoute(
////                                      builder: (context) =>
////                                          MakePrescriptionRequestWidget(
////                                              number,
////                                              online_doctors_service_info[index]
////                                                  ["fees_per_unit"],
////                                              id.toString())));
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                'Chat') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                '1 Month Subscription') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                '3 Month Subscription') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                '6 Month Subscription') {
////                            } else if ((online_doctors_service_info[index]
////                                        ["service_name_info"]["name"]
////                                    .toString()) ==
////                                '1 Year Subscription') {}
//                          },
//                        ),
//                      ));
//                },
//              ),
//            ),
//          ));
//    },
//  );
//}

Widget Skills(List list) {
  print(list);
  return new ListView.builder(
    itemCount: list == null ? 0 : list.length,
    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(
                  list[index]["body"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text(
                  (list[index]["created_at"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ));
    },
  );
}

Widget Educations(List education_info) {
  print(education_info);
  return new ListView.builder(
    itemCount: education_info == null ? 0 : education_info.length,
    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(
                  education_info[index]["title"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text(
                  (education_info[index]["body"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ));
    },
  );
}

//Widget tabBody(){
//  return
//}

//new SingleChildScrollView(
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//CircleAvatar(
//radius: 70,
//backgroundImage: NetworkImage(
//"https://appointmentbd.com/" + widget.photo,
//)),
//Center(
//child: Padding(
//padding: EdgeInsets.all(10),
//child: Text(widget.designation_title),
//),
//
//),
//tabBody()
//
//
//],
//),
//)

//class MakePrescriptionRequestWidget extends StatefulWidget {
//  String tranactionID;
//
//  int fees;
//
//  String docID;
//
//  MakePrescriptionRequestWidget(this.tranactionID, this.fees, this.docID);
//
//  @override
//  _MakePrescriptionRequestState createState() =>
//      _MakePrescriptionRequestState();
//}
//
//class _MakePrescriptionRequestState
//    extends State<MakePrescriptionRequestWidget> {
//  final _formKey = GlobalKey<FormState>();
//  String problem;
//  String myMessage = "Submit";
//
//  Widget StandbyWid = Text(
//    "Login",
//    style: TextStyle(color: Colors.white),
//  );
//
//  @override
//  void initState() {
//    // TODO: implement initState
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Create Prescription Request"),
//      ),
//      body: Scaffold(
//        body: SingleChildScrollView(
//            child: Form(
//              key: _formKey,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    "Write your problems in detail and Doctor will send you prescripton",
//                    style: TextStyle(
//                        color: Color(0xFF34448c), fontWeight: FontWeight.bold),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                    child: TextFormField(
//                      initialValue: "",
//                      validator: (value) {
//                        problem = value;
//                        if (value.isEmpty) {
//                          return 'Write your Problems';
//                        }
//                        return null;
//                      },
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//                    child: SizedBox(
//                        height: 50,
//                        width: double.infinity, // match_parent
//                        child: RaisedButton(
//                          color: Color(0xFF34448c),
//                          onPressed: () async {
//                            // Validate returns true if the form is valid, or false
//                            // otherwise.
//                            if (_formKey.currentState.validate()) {
//                              // If the form is valid, display a Snackbar.
//                              setState(() {
//                                StandbyWid = Text("Please wait");
//                              });
//                              final http.Response response = await http.post(
//                                _baseUrl + 'add-prescription-request',
//                                headers: <String, String>{
//                                  'Content-Type': 'application/json; charset=UTF-8',
//                                  'Authorization': AUTH_KEY,
//                                },
//                                body: jsonEncode(<String, String>{
//                                  'patient_id': USER_ID,
//                                  'dr_id': widget.docID,
//                                  'payment_status': "1",
//                                  'problem': problem,
//                                  'payment_details': widget.tranactionID
//                                }),
//                              );
//                              showThisToast(response.statusCode.toString());
//                              //popup count
//
//                              setState(() {
//                                StandbyWid =
//                                    Text("Prescription request success");
//                              });
//                            } else {}
//                          },
//                          child: StandbyWid,
//                        )),
//                  ),
//                ],
//              ),
//            )),
//      ),
//    );
//  }
//}

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
