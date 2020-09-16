//start
import 'dart:convert';

import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/directions.dart';
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
    body = <String, String>{
      'user_type': "patient",
      'isFollowup': "0",
      'id': widget.USER_ID
    };
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
                                data[index]["dr_info"]["id"].toString(),
                                data[index]["dr_info"]["name"],
                                _baseUrl_image +
                                    data[index]["dr_info"]["photo"],
                                widget.USER_ID,
                                UNAME,
                                UPHOTO,
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

class FollowupVideoAppointmentListActivityPatient extends StatefulWidget {
  String AUTH, USER_ID;

  FollowupVideoAppointmentListActivityPatient(this.AUTH, this.USER_ID);

  @override
  _FollowupVideoAppointmentListActivityPatientState createState() =>
      _FollowupVideoAppointmentListActivityPatientState();
}

class _FollowupVideoAppointmentListActivityPatientState
    extends State<FollowupVideoAppointmentListActivityPatient> {
  List data = [];

  Future getData() async {
    body = <String, String>{
      'user_type': "patient",
      'isFollowup': "1",
      'id': widget.USER_ID
    };
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
        title: Text("Followup Video Appointments"),
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
  String AUTH, USER_ID, TRANS_ID, PAYPAL_ID, DR_ID;

  ChoosePrescriptionForPrescriptionreview(
      this.AUTH, this.USER_ID, this.DR_ID, this.TRANS_ID, this.PAYPAL_ID);

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
        await makePostReq("get-prescription-info", widget.AUTH, body);
    this.setState(() {
      data = json.decode(apiResponse);
      showThisToast("total pres found " + data.length.toString());
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
                                    "0")));

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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChamberAddctivity(widget.AUTH, widget.USER_ID)));
          },
          label: Text("Add a Chamber")),
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

//==
class ChamberAddctivity extends StatefulWidget {
  String AUTH, USER_ID;

  ChamberAddctivity(this.AUTH, this.USER_ID);

  @override
  _ChamberAddctivityState createState() => _ChamberAddctivityState();
}

class _ChamberAddctivityState extends State<ChamberAddctivity> {
  final _formKey = GlobalKey<FormState>();
  String cname, caddress, fees, ffees;
  String myMessage = "Submit";
  String txtSelectDays = "Add Chamber Opening Times";
  var days;

  Widget StandbyWid = Text(
    "Add",
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.getData();
    //doctor-education-chamber-info
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Chamber"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  cname = value;
                  if (value.isEmpty) {
                    return 'Please write chamber name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Chamber Name"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  caddress = value;
                  if (value.isEmpty) {
                    return 'Please write chamber address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Chamber Address"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  fees = value;
                  if (value.isEmpty) {
                    return 'Please write chamber Fees';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Chamber Fees"),
                keyboardType: TextInputType.number,
                autocorrect: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  ffees = value;
                  if (value.isEmpty) {
                    return 'Please write Followup Fees';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Followup Visit Fees"),
                keyboardType: TextInputType.number,
                autocorrect: false,
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
                            builder: (context) => ChooseChamberDaysActivity(
                                  function: (data) {
                                    //  showThisToast("im hit hit hit wioth "+data);
                                    setState(() {
                                      print(data.toString());
                                      days = data;
//                                  selectedDepartment =
//                                      data["id"].toString();
//                                  txtSelectDepartment =
//                                      data["name"].toString();
                                    });
                                  },
                                )));
                  },
                  trailing: Icon(Icons.arrow_downward),
                  title: Text(txtSelectDays),
                ),
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

                        var body_ = jsonEncode(<String, String>{
                          'dr_id': widget.USER_ID,
                          'chamber_name': cname,
                          'address': caddress,
                          'fee': fees,
                          'follow_up_fee': ffees,
                          'days': jsonEncode(days)
                        });
                        final http.Response response = await http.post(
                          _baseUrl + 'chamber-add',
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Accept': 'application/json',
                            'Authorization': widget.AUTH,
                          },
                          body: body_,
                        );
                        print(body_);
                        showThisToast(response.statusCode.toString());
                        print(response.body);
                        if (response.statusCode == 200) {
                          Navigator.of(context).pop();
                        } else {
                          showThisToast("Error occured");
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
//==

//start
class ChooseChamberDaysActivity extends StatefulWidget {
  List timeTable = [
    <String, String>{
      'day': '1',
      'name': 'Mon',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '2',
      'name': 'Tue',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '3',
      'name': 'Wed',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '4',
      'name': 'Thu',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '5',
      'name': 'Fri',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '6',
      'name': 'Sat',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '1'
    },
    <String, String>{
      'day': '0',
      'name': 'Sun',
      'start_time': '15:00',
      'end_time': '23:59',
      'status': '0'
    },
  ];

  Function function;

  //ChooseDeptActivity(this.deptList__, this.function);
  ChooseChamberDaysActivity({Key key, this.function}) : super(key: key);

  @override
  _ChooseChamberDaysActivityState createState() =>
      _ChooseChamberDaysActivityState();
}

class _ChooseChamberDaysActivityState extends State<ChooseChamberDaysActivity> {
  // List deptList = ['Sat Day','Sunday','Monday','Tues Day'];
  changeTimeFunctionOpening(data) {
    int index = int.parse(data["index"]);
    String hour = data["hour"];
    String minute = data["minute"];
    setState(() {
      widget.timeTable[index]["start_time"] = hour + ":" + minute;
    });
  }

  changeTimeFunctionClosing(data) {
    int index = int.parse(data["index"]);
    String hour = data["hour"];
    String minute = data["minute"];
    setState(() {
      widget.timeTable[index]["end_time"] = hour + ":" + minute;
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
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                widget.function(widget.timeTable);
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text("Finish & Return"),
              ),
            ),
          )
        ],
        title: Text("Choose Days"),
      ),
      body: true
          ? ListView.builder(
              itemCount: widget.timeTable == null ? 0 : widget.timeTable.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      setState(() {
                        // widget.timeTable[index]["status"]=="1"?(widget.timeTable[index]["status"]=1):(widget.timeTable[index]["status"]=0);
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: Switch(
                            value: widget.timeTable[index]["status"] == "1"
                                ? true
                                : false,
                            activeColor: Colors.blue,
                            focusColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                value
                                    ? (widget.timeTable[index]["status"] = "1")
                                    : (widget.timeTable[index]["status"] = "0");
                              });
                              // showThisToast(value.toString());
                            },
                          ),
                          leading: Icon(Icons.access_time),
                          title: new Text(
                            widget.timeTable[index]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: createSubtitleWidget(
                              widget,
                              index,
                              changeTimeFunctionOpening,
                              changeTimeFunctionClosing),
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text(widget.timeTable.toString()),
            ),
    );
  }

  Widget createSubtitleWidget(ChooseChamberDaysActivity theWidget, int index,
      Function changeTimeFunctionOpening, Function changeTimeFunctionClosing) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              String hour = "00";
              String minute = "00";

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text("Chamber Opening Time"),
                            ),
                            body: Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          //initialDateTime: DateTime(1969, 1, 1, _timeOfDay.hour, _timeOfDay.minute),
                                          onDateTimeChanged:
                                              (DateTime newDateTime) {
                                            var newTod = TimeOfDay.fromDateTime(
                                                newDateTime);
                                            // _updateTimeFunction(newTod);
                                            // showThisToast(newDateTime.hour.toString());
                                            hour = newDateTime.hour.toString();
                                            minute =
                                                newDateTime.minute.toString();
                                          },
                                          use24hFormat: true,
                                          minuteInterval: 1,
                                        )), //double.infinity
                                    SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          changeTimeFunctionOpening(<String,
                                              String>{
                                            'hour': hour,
                                            'minute': minute,
                                            'index': index.toString()
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Card(
                                          color: Colors.blue,
                                          child: Center(
                                            child: Text(
                                              "Done",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )));

              showThisToast("Clicked");
            },
            child: Text("Opens : " + theWidget.timeTable[index]["start_time"]),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              String hour = "00";
              String minute = "00";

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text("Chamber Closing Time"),
                            ),
                            body: Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          //initialDateTime: DateTime(1969, 1, 1, _timeOfDay.hour, _timeOfDay.minute),
                                          onDateTimeChanged:
                                              (DateTime newDateTime) {
                                            var newTod = TimeOfDay.fromDateTime(
                                                newDateTime);
                                            // _updateTimeFunction(newTod);
                                            // showThisToast(newDateTime.hour.toString());
                                            hour = newDateTime.hour.toString();
                                            minute =
                                                newDateTime.minute.toString();
                                          },
                                          use24hFormat: true,
                                          minuteInterval: 1,
                                        )), //double.infinity
                                    SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          changeTimeFunctionClosing(<String,
                                              String>{
                                            'hour': hour,
                                            'minute': minute,
                                            'index': index.toString()
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Card(
                                          color: Colors.blue,
                                          child: Center(
                                            child: Text(
                                              "Done",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )));

              // showThisToast("Clicked");
            },
            child: Text("Closes : " + theWidget.timeTable[index]["end_time"]),
          ),
        ),
      ],
    );
  }
}

//ends

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
  Function function;

  function_name() {}

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

  functionReloaded() {
    this.getData();
    this.getData_doc();
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
                          onChanged: (newvalue) async {
                            showThisToast(newvalue.toString());
                            if (newvalue) {
                              var body_ = jsonEncode(<String, String>{
                                'doctor_id': widget.UID,
                                'online_service_id':
                                    data[index]["id"].toString(),
                                'fees_per_unit': "00"
                              });
                              final http.Response response = await http.post(
                                _baseUrl + 'add-online-doctor-service',
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Accept': 'application/json',
                                  'Authorization': widget.AUTH,
                                },
                                body: body_,
                              );
                              showThisToast(response.body);
                              print(response.body);

                              if (response.statusCode == 200) {
                                this.getData();
                                this.getData_doc();
                              } else {
                                showThisToast("Error Occured");
                              }
                            } else {
                              //delete-online-doctor-service
                              var body_ = jsonEncode(<String, String>{
                                'doctor_id': widget.UID,
                                'online_service_id':
                                    data[index]["id"].toString(),
                              });
                              final http.Response response = await http.post(
                                _baseUrl + 'delete-online-doctor-service',
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Accept': 'application/json',
                                  'Authorization': widget.AUTH,
                                },
                                body: body_,
                              );
                              showThisToast(response.body);
                              print(response.body);

                              if (response.statusCode == 200) {
                                this.getData();
                                this.getData_doc();
                              } else {
                                showThisToast("Error Occured");
                              }
                            }

//                          setState(() {
//                            this.getData();
//                            this.getData_doc();
//                          });
                          },
                          value: getvalueBool(data[index]["id"], data_doc),
                        ),
                        title: Text(data[index]["name"]),
                        subtitle: getfeesAmount(
                            data[index]["id"],
                            data_doc,
                            context,
                            widget.AUTH,
                            widget.UID,
                            widget.function_name,
                            functionReloaded)),
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
Widget getfeesAmount(int serviceId, List data, BuildContext context,
    String auth, String uid, Function function, Function reload) {
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
  widgests.add(Text(dataFees + " USD"));
  InkWell inkWell = InkWell(
    onTap: () {
      final _formKey = GlobalKey<FormState>();
      String fees;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add / Update Fees in USD'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          initialValue: dataFees,
                          validator: (value) {
                            fees = value;
                            if (value.isEmpty) {
                              return 'Please enter Fees';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Update'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    //update-online-doctor-service-fees
                    var body_ = jsonEncode(<String, String>{
                      'doctor_id': uid,
                      'online_service_id': serviceId.toString(),
                      'fees': fees,
                    });
                    final http.Response response = await http.post(
                      _baseUrl + 'update-online-doctor-service-fees',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Accept': 'application/json',
                        'Authorization': auth,
                      },
                      body: body_,
                    );
                    if (response.statusCode == 200) {
                      Navigator.of(context).pop();
                      function();
                      reload.call();
                    } else {
                      showThisToast("Error occured");
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    },
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

//start
class SetFeesActivity extends StatefulWidget {
  List deptList__ = [];
  Function function;

  //ChooseDeptActivity(this.deptList__, this.function);
  SetFeesActivity(this.deptList__, {Key key, this.function}) : super(key: key);

  @override
  _SetFeesActivityState createState() => _SetFeesActivityState();
}

class _SetFeesActivityState extends State<SetFeesActivity> {
  @override
  void initState() {
    // TODO: implement initState
    //  this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Fees"),
      ),
    );
  }
}

//ends
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
    // showThisToast("No data");
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
