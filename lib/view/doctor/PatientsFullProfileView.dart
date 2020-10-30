import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;

List skill_info;
List education_info;

final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";

class PatientFullProfileView extends StatefulWidget {
  String name;
  String photo;
  String id;
  String auth;

  PatientFullProfileView(this.auth,this.id, this.name, this.photo);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<PatientFullProfileView> {
  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'doctor-education-chamber-info',
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

    print(skill_info);

    return "Success!";
  }

  @override
  void initState()  {
    this.getData();
//    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//    SharedPreferences prefs;
//    prefs = await _prefs;
//    AUTH_KEY = prefs.getString("auth");
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(widget.name),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "Prescriptions",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Diseases history"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PrescriptionsWidget(widget.id,widget.auth),
            DiseasesWidget(widget.id,widget.auth),

          ],
        ),
      ),
    );
  }
}

class PrescriptionsWidget extends StatefulWidget {
  String patient_id;
  String auth_2;

  PrescriptionsWidget(this.patient_id,this.auth_2);

  @override
  _PrescriptionsWidgetState createState() => _PrescriptionsWidgetState();
}

class _PrescriptionsWidgetState extends State<PrescriptionsWidget> {
  List prescriptionList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-prescription-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.auth_2,
      },
      body: jsonEncode(<String, String>{'id': widget.patient_id, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionList = json.decode(response.body);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: (prescriptionList != null && prescriptionList.length > 0)
          ? new ListView.builder(
              itemCount: prescriptionList == null ? 0 : prescriptionList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      List attachment = prescriptionList[index]["attachment"];
                      if (attachment != null && attachment.length > 0) {
                        //  showThisToast("analog");
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => PrescriptionsodyWidget(
//                                    prescriptionList[index])));
                      } else {
                        // showThisToast("digital");
                        print(prescriptionList[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: Text("Digital Prescription"),
                                      ),
                                      body: ListView(
                                        children: <Widget>[
                                          Expanded(
                                            child: ListTile(
                                              title: Text("Doctor's Comment"),
                                              subtitle: Text(
                                                  prescriptionList[index]
                                                      ["diseases_name"]),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 10, 10, 10),
                                              child: Text(
                                                "Prescribed Medicines",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                          medicinesListOfAPrescriptionWidget(prescriptionList[index]),
                                        ],
                                      ),
                                    )));
                      }
                      print(prescriptionList[index]);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(00.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(05),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(_baseUrl_image+prescriptionList[index]["dr_info"]["photo"]),
                          ),
                          title: new Text(
                            (prescriptionList[index]["dr_info"] == null
                                ? "No Doctor Name"
                                : prescriptionList[index]["dr_info"]["name"]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            prescriptionList[index]["created_at"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            )
          : Container(
              height: 200,
              child: Center(
                child: Text("No Prescription History"),
              )),

    );
  }
}
Widget medicinesListOfAPrescriptionWidget(medicineList) {
  return medicineList != null
      ? ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    itemCount: medicineList["medicine_info"] == null
        ? 0
        : medicineList["medicine_info"].length,
    itemBuilder: (BuildContext context, int index2) {
      return new InkWell(
          onTap: () {},
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: ListTile(
                 // leading: Icon(Icons.not_interested),
                  title: new Text(medicineList["medicine_info"][index2]
                  ["medicine_name_info"]["name"]),
                  subtitle: createMedicineDoseWid(
                      medicineList["medicine_info"][index2]["dose"]
                          .toString(),
                      medicineList["medicine_info"][index2]
                      ["duration_type"],
                      medicineList["medicine_info"][index2]
                      ["duration_length"]
                          .toString(),
                      medicineList["medicine_info"][index2]["isAfterMeal"]
                          .toString()),
                ),
              )));
    },
  )
      : Center(
    child: Text("Please Wait"),
  );
}
Widget createMedicineDoseWid(String string, String duration_type,
    String duration_length, String isAfterMeal) {
  String dosesText = "";
  List doses = string.split("-");

  if (doses[0] == "1") dosesText = dosesText + "Morning";
  if (doses[1] == "1") dosesText = dosesText + " Noon";
  if (doses[2] == "1") dosesText = dosesText + " Evening";

  dosesText = dosesText + "\n" + " " + duration_length;
  if (duration_type == 'd') dosesText = dosesText + " Days";
  if (duration_type == 'w') dosesText = dosesText + " Weeks";
  if (duration_type == 'm') dosesText = dosesText + " Months";

  if (isAfterMeal == '1') dosesText = dosesText + "\n After Meal";
  if (isAfterMeal == '0') dosesText = dosesText + "\n Before Meal";

  return Text(dosesText);
}
class DiseasesWidget extends StatefulWidget {
  String auth, patient_id ;
  DiseasesWidget(this.patient_id,this.auth);

  @override
  _DiseasesWidgetState createState() => _DiseasesWidgetState();
}

class _DiseasesWidgetState extends State<DiseasesWidget> {
  List diseasesList = [];


  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'patient-disease-record',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.auth,
      },
      body: jsonEncode(<String, String>{'patient_id': widget.patient_id}),
    );
    this.setState(() {
      diseasesList = json.decode(response.body);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: (diseasesList != null && diseasesList.length > 0)
          ? new ListView.builder(
        itemCount: diseasesList == null ? 0 : diseasesList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {},
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(05),
                  child: ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    leading: Icon(Icons.accessible_forward),
                    title: new Text(
                      diseasesList[index]["disease_name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      diseasesList[index]["first_notice_date"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        },
      )
          : Container(
          height: 200,
          child: Center(
            child: Text("No Diseases History"),
          )),

    );
  }
}


Widget Services(List online_doctors_service_info) {
  print(online_doctors_service_info);
  return new ListView.builder(
    itemCount: online_doctors_service_info == null
        ? 0
        : online_doctors_service_info.length,
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
                  online_doctors_service_info[index]["service_name_info"]
                      ["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text(
                  (online_doctors_service_info[index]["fees_per_unit"])
                          .toString() +
                      CURRENCY_USD_SIGN,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              trailing: RaisedButton(
                color: Colors.pink,
                child: Text(
                  "Purchase",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // makePayment();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) => PaypalPayment(
                  //         "",
                  //         onFinish: (number) async {
                  //           // payment done
                  //           // showThisToast('order id: '+number);
                  //           print('order id: ' + number);
                  //         },
                  //       ),
                  //     ));
                },
              ),
            ),
          ));
    },
  );
}

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
