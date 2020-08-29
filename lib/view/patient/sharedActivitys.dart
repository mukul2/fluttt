//start
import 'dart:convert';

import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";
final String _baseUrl_image = "http://telemedicine.drshahidulislam.com/";
var body;

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
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
  } else {
    showThisToast(response.statusCode.toString());
  }
  return response.body;
}

class VideoAppointmentListActivityPatient extends StatefulWidget {
  String AUTH, USER_ID;

  VideoAppointmentListActivityPatient(this.AUTH, this.USER_ID);

  @override
  _VideoAppointmentListActivityPatientState createState() =>
      _VideoAppointmentListActivityPatientState();
}

class _VideoAppointmentListActivityPatientState
    extends State<VideoAppointmentListActivityPatient> {
  List data = [];

  Future getData() async {
    body = <String, String>{'user_type': "patient", 'id': widget.USER_ID};
    String apiResponse =
        await makePostReq("get_video_appointment_list", widget.AUTH, body);
    this.setState(() {
      data = json.decode(apiResponse);
    });
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Appointments"),
      ),
      body: data.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {
                    String chatRoom = createChatRoomName(
                        int.parse(widget.USER_ID),
                        data[index]["dr_info"]["id"]);
                    CHAT_ROOM = chatRoom;
                    showThisToast(chatRoom);
                    // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                widget.USER_ID,
                                UNAME,
                                _baseUrl_image +
                                    data[index]["dr_info"]["photo"],
                                data[index]["dr_info"]["id"].toString(),
                                data[index]["dr_info"]["name"],
                                _baseUrl_image +
                                    data[index]["dr_info"]["photo"],
                                chatRoom)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              _baseUrl_image + data[index]["dr_info"]["photo"]),
                        ),
                        title: Text(data[index]["dr_info"]["name"]),
                        subtitle: Text(
                          "Send a Message",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            ),
    );
  }
}

class ChoosePrescriptionForPrescriptionreview extends StatefulWidget {
  String AUTH, USER_ID,TRANS_ID,PAYPAL_ID,DR_ID;

  ChoosePrescriptionForPrescriptionreview(this.AUTH, this.USER_ID,this.DR_ID,this.TRANS_ID,this.PAYPAL_ID);

  @override
  _ChoosePrescriptionForPrescriptionreviewState createState() =>
      _ChoosePrescriptionForPrescriptionreviewState();
}

class _ChoosePrescriptionForPrescriptionreviewState
    extends State<ChoosePrescriptionForPrescriptionreview> {
  List data = [];

  Future getData() async {
    body = <String, String>{'user_type': "patient", 'id': widget.USER_ID};
    String apiResponse =
        await makePostReq("get_video_appointment_list", widget.AUTH, body);
    this.setState(() {
      data = json.decode(apiResponse);
    });
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("-Choose a Prescription for Review"),
      ),
      body: data.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChooseCommentForPresRecheckAndPublish(
                                    widget.AUTH,
                                    widget.USER_ID,
                                    widget.DR_ID,
                                    data[index]["id"].toString(),
                                    widget.TRANS_ID,
                                    widget.PAYPAL_ID,
                                    payable_amount,
                                    "1")));

//                    String chatRoom = createChatRoomName(
//                        int.parse(widget.USER_ID),
//                        data[index]["dr_info"]["id"]);
//                    CHAT_ROOM = chatRoom;
//                    showThisToast(chatRoom);
//                    // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ChatScreen(
//                                widget.USER_ID,
//                                UNAME,
//                                _baseUrl_image +
//                                    data[index]["dr_info"]["photo"],
//                                data[index]["dr_info"]["id"].toString(),
//                                data[index]["dr_info"]["name"],
//                                _baseUrl_image +
//                                    data[index]["dr_info"]["photo"],
//                                chatRoom)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              _baseUrl_image + data[index]["dr_info"]["photo"]),
                        ),
                        title: Text(data[index]["dr_info"]["name"]),
                        subtitle: Text(
                          "Review This Prescription",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            ),
    );
  }
}

//end

//start

class EducationsActivity extends StatefulWidget {
  String AUTH, USER_ID;

  EducationsActivity(this.AUTH, this.USER_ID);

  @override
  _EducationsActivityState createState() => _EducationsActivityState();
}

class _EducationsActivityState extends State<EducationsActivity> {
  String user_name_from_state = UNAME;
  String user_picture = UPHOTO;

  List data = [];
  dynamic respo;

  Future getData() async {
    body = <String, String>{'dr_id': widget.USER_ID};
    String apiResponse =
        await makePostReq("doctor-education-chamber-info", widget.AUTH, body);
    this.setState(() {
      respo = json.decode(apiResponse);
      data = respo["education_info"];
      //showThisToast("edu row found "+data.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    //doctor-education-chamber-info
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Education Info"),
      ),
      body: data.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        title: Text(data[index]["title"].toString()),
                        subtitle: Text(
                          data[index]["body"].toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            ),
    );
  }
}

class ChooseCommentForPresRecheckAndPublish extends StatefulWidget {
  String AUTH,
      USER_ID,
      dr_id,
      old_pres_id,
      payment_details,
      paypal_id,
      amount,
      payment_status;

  ChooseCommentForPresRecheckAndPublish(
      this.AUTH,
      this.USER_ID,
      this.dr_id,
      this.old_pres_id,
      this.payment_details,
      this.paypal_id,
      this.amount,
      this.payment_status);

  @override
  _ChooseCommentForPresRecheckAndPublishState createState() =>
      _ChooseCommentForPresRecheckAndPublishState();
}

class _ChooseCommentForPresRecheckAndPublishState
    extends State<ChooseCommentForPresRecheckAndPublish> {
  String user_name_from_state = UNAME;
  String user_picture = UPHOTO;

  List data = [];
  dynamic respo;
  final _formKey = GlobalKey<FormState>();
  String problem;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );
  Future getData() async {
    body = <String, String>{'dr_id': widget.USER_ID};

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // this.getData();
    //doctor-education-chamber-info
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body:  Scaffold(
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
                                'patient_id': UID,
                                'dr_id': widget.dr_id,
                                'old_prescription_id': widget.old_pres_id,
                                'patient_comment': problem,
                                'payment_status': "1",
                                'payment_details': widget.payment_details,
                                'amount': widget.amount,
                                'paypal_id': widget.paypal_id
                              });
                              final http.Response response = await http.post(
                                _baseUrl + 'add-prescription-recheck-request',
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': A_KEY,
                                },
                                body: body_,
                              );

                              print(body_);
                              if (response.statusCode == 200) {
                                dynamic jsonRes = jsonDecode(response.body);
                                if (jsonRes["status"]) {
                                  setState(() {
                                    StandbyWid = Text(
                                        "Prescription Review request success",
                                        style: TextStyle(color: Colors.white));
                                  });
                                  Navigator.of(context).pop();
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

//end

//start

class SkillsActivity extends StatefulWidget {
  String AUTH, USER_ID;

  SkillsActivity(this.AUTH, this.USER_ID);

  @override
  _SkillsActivityState createState() => _SkillsActivityState();
}

class _SkillsActivityState extends State<SkillsActivity> {
  String user_name_from_state = UNAME;
  String user_picture = UPHOTO;

  List data = [];
  dynamic respo;

  Future getData() async {
    body = <String, String>{'dr_id': widget.USER_ID};
    String apiResponse =
        await makePostReq("doctor-education-chamber-info", widget.AUTH, body);
    this.setState(() {
      respo = json.decode(apiResponse);
      data = respo["skill_info"];
      //showThisToast("skill row found "+data.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    //doctor-education-chamber-info
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Skill Info"),
      ),
      body: data.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        title: Text(data[index]["body"]),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            ),
    );
  }
}

//end
//
// start

class ChamberActivity extends StatefulWidget {
  String AUTH, USER_ID;

  ChamberActivity(this.AUTH, this.USER_ID);

  @override
  _ChamberActivityState createState() => _ChamberActivityState();
}

class _ChamberActivityState extends State<ChamberActivity> {
  String user_name_from_state = UNAME;
  String user_picture = UPHOTO;

  List data = [];
  dynamic respo;

  Future getData() async {
    body = <String, String>{'dr_id': widget.USER_ID};
    String apiResponse =
        await makePostReq("doctor-education-chamber-info", widget.AUTH, body);
    this.setState(() {
      respo = json.decode(apiResponse);
      data = respo["chamber_info"];
      //showThisToast("skill row found "+data.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    //doctor-education-chamber-info
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamber Info"),
      ),
      body: data.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : " + data[index]["chamber_name"]),
                          Text("Address : " + data[index]["address"]),
                          Text("Fees : " + data[index]["fee"].toString()),
                          Text("Follow up Fees : " +
                              data[index]["follow_up_fee"].toString()),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                                color: Colors.blue,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Day",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Opens",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Closes",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          data[index]["chamber_days"] != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data[index]["chamber_days"] == null
                                      ? 0
                                      : data[index]["chamber_days"].length,
                                  itemBuilder:
                                      (BuildContext context, int index2) {
                                    return new InkWell(
                                        onTap: () {},
                                        child: Container(
                                          color: index2 % 2 != 0
                                              ? Color.fromARGB(
                                                  100, 212, 212, 212)
                                              : Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    getDayName(data[index]
                                                            ["chamber_days"]
                                                        [index2]["day"]),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    data[index]["chamber_days"]
                                                                [index2]
                                                            ["start_time"]
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    data[index]["chamber_days"]
                                                            [index2]["end_time"]
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                )
                              : Text("No chamber sitting days assigned")
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            ),
    );
  }
}

String getDayName(int day) {
  String returnDay = "Error";
  switch (day) {
    case 6:
      {
        // statements;
        returnDay = "Sat";
      }
      break;

    case 1:
      {
        //statements;
        returnDay = "Mon";
      }
      break;
    case 2:
      {
        //statements;
        returnDay = "Tue";
      }
      break;
    case 3:
      {
        //statements;
        returnDay = "Wed";
      }
      break;
    case 4:
      {
        //statements;
        returnDay = "Thu";
      }
      break;
    case 5:
      {
        //statements;
        returnDay = "Fri";
      }
      break;
    case 0:
      {
        //statements;
        returnDay = "Sun";
      }

      break;

    default:
      {
        //statements;
      }
      break;
  }
  return returnDay;
}

//end

//start
class myServicesWidget extends StatefulWidget {
  String AUTH, UID;

  myServicesWidget(this.AUTH, this.UID);

  @override
  _myServicesWidgetState createState() => _myServicesWidgetState();
}

class _myServicesWidgetState extends State<myServicesWidget> {
  List data = [];
  List data_doc = [];

  Future getData() async {
    String apiResponse =
        await makePostReq("all-online-service", widget.AUTH, null);
    this.setState(() {
      data = json.decode(apiResponse);
      //showThisToast("skill row found "+data.length.toString());
    });
  }

  Future getData_doc() async {
    body = <String, String>{'doctor_id': widget.UID};

    String apiResponse =
        await makePostReq("view-online-doctor-service", widget.AUTH, body);
    this.setState(() {
      data_doc = json.decode(apiResponse);
      //showThisToast(apiResponse);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
    this.getData_doc();
  }

  @override
  Widget build(BuildContext context) {
    //all-online-service
    return data.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      trailing: Checkbox(
                        onChanged: (newvalue) {
                          showThisToast(newvalue.toString());
                        },
                        value: getvalueBool(data[index]["id"], data_doc),
                      ),
                      title: Text(data[index]["name"]),
                      subtitle: getfeesAmount(data[index]["id"], data_doc),
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text("No Data"),
          );
  }
}

//end
Widget getfeesAmount(int serviceId, List data) {
  List<Widget> widgests = [];
  String dataFees = "00";
  //&&  data [i]["status"] == 1
  if (data != null && data.length > 0) {
    for (int i = 0; i < data.length; i++) {
      print(serviceId.toString() +
          "   " +
          data[i]["online_service_id"].toString());
      if (serviceId == data[i]["online_service_id"]) {
        dataFees = data[i]["fees_per_unit"].toString();
      }
    }
  }
  widgests.add(Text(dataFees + " BDT"));
  InkWell inkWell = InkWell(
    child: Padding(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Text(
        "Edit Fees",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
  Card card = Card(
    color: Colors.red,
    child: inkWell,
  );
  widgests.add(card);
  Row row = Row(
    children: widgests,
  );
  return row;
}

bool getvalueBool(int serviceId, List data) {
  bool value = false;
  //&&  data [i]["status"] == 1
  if (data != null && data.length > 0) {
    for (int i = 0; i < data.length; i++) {
      print(serviceId.toString() +
          "   " +
          data[i]["online_service_id"].toString());
      if (serviceId == data[i]["online_service_id"] && data[i]["status"] == 1) {
        value = true;
      } else {
        // showThisToast("No match");
      }
    }
  } else {
    showThisToast("No data");
  }

  return value;
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
