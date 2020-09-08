import 'dart:convert';
import 'dart:core';
import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/view/doctor/doctor_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';
import 'dart:io';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'config.dart';

final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";
String A_KEY;
String UID;

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  String TYPE;

  PaypalPayment(this.TYPE, {this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = payable_amount;
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = payable_amount;
    String subTotalAmount = payable_amount;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) async {
                  showThisToast("real " + id);
                  //  widget.onFinish(id);
                  //  Navigator.of(context).pop();
                  Future<SharedPreferences> _prefs =
                      SharedPreferences.getInstance();
                  prefs = await _prefs;
                  A_KEY = prefs.getString("auth");
                  UID = prefs.getString("uid");
                  if (widget.TYPE == 'Prescription Service') {
                    final http.Response response = await http.post(
                      _baseUrl + 'add_payment_info_only',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'amount': payable_amount,
                        'status': "1",
                        'reason': "Prescription request",
                        'transID': id,
                      }),
                    );

                    if (response.statusCode == 200) {
                      print(response.body.toLowerCase());
                      dynamic jsonResponse = jsonDecode(response.body);
                      print(jsonResponse.toString());
                      print(jsonResponse["message"].toString());
                      // dynamic jsonresponse = jsonDecode(response.body);
                      if (true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MakePrescriptionRequestWidget(A_KEY,UID,
                                        id,
                                        payable_amount,
                                        docID,
                                        jsonResponse["message"].toString(),payable_amount)));
                      } else {
                        showThisToast("Failed to insert data");
                      }
                    } else {
                      showThisToast("Api error");
                    }
                  } else if (widget.TYPE == '1 Month Subscription') {
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
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "1",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                        'status': "1",

                      }),
                    );
                    // showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  } else if (widget.TYPE == '3 Month Subscription') {
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
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "3",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                        'status': "1",

                      }),
                    );
                    // showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //  Navigator.of(context).pop();
                  } else if (widget.TYPE == '6 Month Subscription') {
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
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "6",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                        'status': "1",

                      }),
                    );
                    //  showThisToast(response.statusCode.toString());
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                  } else if (widget.TYPE == '1 Year Subscription') {
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
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'payment_status': "1",
                        'number_of_months': "12",
                        'payment_details': id,
                        'starts': startDate,
                        'amount': payable_amount,
                        'ends': endDate,
                        'status': "1",

                      }),
                    );
                    print(jsonEncode(<String, String>{
                      'patient_id': UID,
                      'dr_id': docID,
                      'payment_status': "1",
                      'number_of_months': "12",
                      'payment_details': id,
                      'starts': startDate,
                      'amount': payable_amount,
                      'ends': endDate,
                    }));
                    showThisToast(response.statusCode.toString());
                    showThisToast(response.body);
                    //popup count
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  } else if (widget.TYPE == 'Chat') {
                    final http.Response response = await http.post(
                      _baseUrl + 'add_chat_appointment_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'amount': payable_amount,
                        'payment_details': id,
                        'status': "1"

                      }),
                    );
                    // showThisToast(response.statusCode.toString());
                    //popup count

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                    String chatRoom = createChatRoomName(
                        int.parse(USER_ID), int.parse(docID));
                    CHAT_ROOM = chatRoom;
                    print("chat room " + chatRoom);
                    DatabaseReference _messageDatabaseReference;

                    DatabaseReference _messageDatabaseReference_last;
                    _messageDatabaseReference = FirebaseDatabase.instance
                        .reference()
                        .child(CLIEND_ID)
                        .child("chatHistory")
                        .child(CHAT_ROOM);

                    _messageDatabaseReference_last = FirebaseDatabase.instance
                        .reference()
                        .child(CLIEND_ID)
                        .child("lastChatHistory");

                    _messageDatabaseReference_last
                        .child(USER_ID)
                        .child(docID)
                        .child("message_body")
                        .set("Chat service payment is compleated");
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
                        .set(USER_NAME);
                    _messageDatabaseReference_last
                        .child(USER_ID)
                        .child(docID)
                        .child("sender_photo")
                        .set(USER_PHOTO);
                    _messageDatabaseReference_last
                        .child(USER_ID)
                        .child(docID)
                        .child("time")
                        .set(new DateTime.now().toUtc().toIso8601String());

                    _messageDatabaseReference_last
                        .child(docID)
                        .child(USER_ID)
                        .child("message_body")
                        .set("Chat service payment is compleated");
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
                        .set(USER_NAME);
                    _messageDatabaseReference_last
                        .child(docID)
                        .child(USER_ID)
                        .child("sender_photo")
                        .set(USER_PHOTO);
                    _messageDatabaseReference_last
                        .child(docID)
                        .child(USER_ID)
                        .child("time")
                        .set(new DateTime.now().toUtc().toIso8601String());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                USER_ID,
                                USER_NAME,
                                USER_PHOTO,
                                docID,
                                docNAME,
                                docPhoto,
                                chatRoom)));
                  } else if (widget.TYPE == "Video Call") {
                    final http.Response response = await http.post(
                      _baseUrl + 'add_video_appointment_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'doctor_id': docID,
                        'payment_details': id,
                        'payment_status': "1",
                        'amount': payable_amount,
                        'is_review_appointment': "1",

                      }),
                    );


                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoAppointmentListActivityPatient(
                                    A_KEY, UID)));
                    // Navigator.of(context).pop();
                  } else if (widget.TYPE == "Prescription Review") {
                    final http.Response response = await http.post(
                      _baseUrl + 'add_payment_info_only',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'dr_id': docID,
                        'amount': payable_amount,
                        'status': "1",
                        'reason': "Prescription review",
                        'transID': id,
                      }),
                    );

                    if (response.statusCode == 200) {
                      print(response.body.toLowerCase());
                      dynamic jsonResponse = jsonDecode(response.body);
                      print(jsonResponse.toString());
                      print(jsonResponse["message"].toString());
                      // dynamic jsonresponse = jsonDecode(response.body);
                      if (true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChoosePrescriptionForPrescriptionreview(A_KEY,UID, docID,id,
                                        jsonResponse["message"].toString())));
                      } else {
                        showThisToast("Failed to insert data");
                      }
                    } else {
                      showThisToast("Api error");
                    }
                  }else if (widget.TYPE == "Follow up Video Appointment") {
                    final http.Response response = await http.post(
                      _baseUrl + 'add_video_appointment_info',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': A_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': UID,
                        'doctor_id': docID,
                        'payment_details': id,
                        'payment_status': "1",
                        'amount': payable_amount,
                        'is_review_appointment': "1",
                      }),
                    );




                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FollowupVideoAppointmentListActivityPatient(
                                    A_KEY, UID)));
                    // Navigator.of(context).pop();
                  }  else {
                    showThisToast("Unknwon service " + widget.TYPE);
                  }
                });
              } else {
                showThisToast("No Payer id found");
              }
              //  Navigator.of(context).pop();
            } else {
              showThisToast("probl here 1");
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}

class MakePrescriptionRequestWidget extends StatefulWidget {
  String tranactionID;

  String fees;

  String docID;
  String paypalID;
  String auth,uid;
  String amount ;

  MakePrescriptionRequestWidget(this.auth,this.uid,
      this.tranactionID, this.fees, this.docID, this.paypalID,this.amount);

  @override
  _MakePrescriptionRequestState createState() =>
      _MakePrescriptionRequestState();
}

class _MakePrescriptionRequestState
    extends State<MakePrescriptionRequestWidget> {
  final _formKey = GlobalKey<FormState>();
  String problem;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Prescription Request"),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    problem = value;
                    if (value.isEmpty) {
                      return 'Please write your problem';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(color: Colors.blue),
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: "Write write your problem"),
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
                      color: Colors.blue,
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          setState(() {
                            StandbyWid = Text("Please wait",
                                style: TextStyle(color: Colors.white));
                          });
                          var body_ = jsonEncode(<String, String>{
                            'patient_id': widget.uid,
                            'dr_id': widget.docID,
                            'payment_status': "1",
                            'problem': problem,
                            'payment_status': "1",
                            'amount': payable_amount,
                            'payment_details': widget.tranactionID,
                            'paypal_id': widget.paypalID
                          });
                          final http.Response response = await http.post(
                            _baseUrl + 'add-prescription-request',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization': widget.auth,
                            },
                            body: body_,
                          );

                          print(body_);
                          if (response.statusCode == 200) {
                            dynamic jsonRes = jsonDecode(response.body);
                            if (jsonRes["status"]) {
                              setState(() {
                                StandbyWid = Text(
                                    "Prescription request success",
                                    style: TextStyle(color: Colors.white));
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              showThisToast(jsonRes["message"]);
                            } else {
                              setState(() {
                                StandbyWid = Text("Error occured",
                                    style: TextStyle(color: Colors.white));
                              });
                              showThisToast("Error occured");
                            }
                          } else {
                            showThisToast(response.statusCode.toString());

                          }

                          //  showThisToast(response.statusCode.toString());
                          //popup count

                        } else {}
                      },
                      child: StandbyWid,
                    )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

Future<String> makePostReq(String url, String auth, body_) async {
  final http.Response response = await http.post(
    _baseUrl + url,
    headers: <String, String>{
      'Authorization': auth,
    },
    body: body_,
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    showThisToast(response.statusCode.toString());
    return "";
    showThisToast(response.statusCode.toString());
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
