import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:appxplorebd/utils/myCalender.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;

import 'AppointmentConfirmForm.dart';

List skill_info;
List education_info;
List chamber_info;
String AUTH_KEY;
String SELECTED_DATE;
String name_;
String photo_;
String designation_title_;
int id_;

class ChamberDoctorFullProfileView extends StatefulWidget {
  String name;
  String photo;
  String designation_title;
  int id;

  ChamberDoctorFullProfileView(this.id, this.name, this.photo,
      this.designation_title);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<ChamberDoctorFullProfileView> {
  Future<String> getData() async {

    Future<SharedPreferences> _prefs =
    SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY =  prefs.getString("auth");
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" +
          'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'dr_id': widget.id.toString()}),
    );
    showThisToast(response.statusCode.toString());

    this.setState(() {
      skill_info = json.decode(response.body)["skill_info"];
      education_info = json.decode(response.body)["education_info"];
      chamber_info = json.decode(response.body)["chamber_info"];
    });

    //   print(skill_info);

    return "Success!";
  }

  @override
  void initState() {
 /*   Future<SharedPreferences> _prefs =
    SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY =  prefs.getString("auth");

  */
    name_ = widget.name;
    photo_ = widget.photo;
    designation_title_ = widget.designation_title;
    id_ = widget.id;
    this.getData();
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(widget.name),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "Chambers",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Skills"),
              Tab(icon: Icon(Icons.school), text: "Education"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chambers((chamber_info)),
            Skills(skill_info),
            Educations(education_info)
          ],
        ),
      ),
    );
  }
}

Widget Chambers(List chambers) {
  print("see now");
  print(chambers);
  return new ListView.builder(
    itemCount: chambers == null ? 0 : chambers.length,
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
                  chambers[index]["chamber_name"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text(
                  (chambers[index]["address"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              trailing: RaisedButton(
                color: Colors.pink,
                child: Text(
                  "Book an Appointment",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // makePayment();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            chamberBooking(
                                chamber_info[index], context), //startwork
                      ));
                },
              ),
            ),
          ));
    },
  );
}

Widget Skills(List list) {
  // print(list);
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
  //print(education_info);
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

Widget chamberBooking(chamber_info, BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Book an Appointment"),
    ),
    body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      child: Expanded(
                        child: Image.network(
                          "http://telemedicine.drshahidulislam.com/" + photo_,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(name_),
                        subtitle: Text(designation_title_),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Expanded(
                child: ListTile(
                  title: Text((chamber_info["chamber_name"]).toString()),
                  subtitle: Text((chamber_info["address"]).toString()),
                ),
              ),
            ),
            printAllDates(chamber_info["chamber_days"], context,
                (chamber_info["id"]).toString()),
          ],
        )),
  );
}

Widget printAllDates(chamber_days, BuildContext context, String chamber_id) {
  showThisToast(chamber_days.length.toString());

  TabBarView tabBarView = TabBarView(
    children: [],
  );

  var monday = 1;
  int datesSize = 0;
//  while ((now.weekday) == monday) {
//    i++;
//    now = now.add(new Duration(days: 1));
//    dates += 'nxt monday $now' + '\n';
//    showThisToast(now.toString());
//  }
  bool sundayOpen = false;
  bool mondayOpen = false;
  bool tuesdayOpen = false;
  bool wedsdayOpen = false;
  bool thurdayOpen = false;
  bool fridayOpen = false;
  bool satdayOpen = false;

  List<bool> openBool = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ]; //mon sat
  List<String> startTimesList = ["", "", "", "", "", "", ""]; //mon sat
  List<String> endTimesList = ["", "", "", "", "", "", ""]; //mon sat

  if (chamber_days.length > 0) {
    for (int k = 0; k < chamber_days.length; k++) {
      openBool[int.parse(chamber_days[k]["day"].toString())] = true;
      startTimesList[int.parse(chamber_days[k]["day"].toString())] =
          (chamber_days[k]["start_time"]).toString();
      endTimesList[int.parse(chamber_days[k]["day"].toString())] =
          (chamber_days[k]["end_time"]).toString();
    }

  }

  // showThisToast((chamber_days[0]["day"]).toString());

  String dates = "";

  if (true) {
    List<String> datesList = [];
    List<int> datesListWeekMap = [];
    var now = new DateTime.now();
    now = now.add(new Duration(days: 10));
    datesSize = 0;
    for (int i = now.day; i < getMonthCount(now.month); i++) {
      now = now.add(new Duration(days: 1));
      if ((now.weekday == 1 && openBool[0]) ||
          (now.weekday == 2 && openBool[1]) ||
          (now.weekday == 3 && openBool[2]) ||
          (now.weekday == 4 && openBool[3]) ||
          (now.weekday == 5 && openBool[4]) ||
          (now.weekday == 6 && openBool[5]) ||
          (now.weekday == 7 && openBool[6])) {
        datesSize++;
        dates += now.toIso8601String();
        datesList.add(((now.day).toString() +
            "/" +
            (now.month).toString() +
            "/" +
            (now.year).toString())
            .toString());
        datesListWeekMap.add(now.weekday - 1);

        //tabBar.tabs.add(  Tab( text:"ok"));
      }
    }

    for (int i = 0; i < datesList.length; i++) {
      tabBarView.children.add(Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: ListTile(
                    leading: Wrap(
                      spacing: 0, // space between two icons
                      children: <Widget>[
                        Icon(
                          Icons.navigate_before,
                          color: Colors.white,
                        ),
                        // icon-1
                        // icon-2
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                        // icon-1
                        // icon-2
                      ],
                    ),
                    title: Center(
                        child: Text(
                          datesList[i],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child:
                Text("Chamber Opening Time " + startTimesList[datesListWeekMap[i]]),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Chamber Closing Time " + endTimesList[datesListWeekMap[i]]),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: RaisedButton(
                    color: Colors.pink,
                    child: Text("Book Appointment",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      SELECTED_DATE = datesList[i];
                      showThisToast(SELECTED_DATE);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                appointmentFormWidget(chamber_id,SELECTED_DATE)));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }
    //showThisToast("ok days foud " + datesSize.toString());
  }

  DefaultTabController tabController = DefaultTabController(
    length: datesSize,
    child: Column(
      children: <Widget>[SizedBox(height: 250.0, child: tabBarView)],
    ),
  );

  //showThisToast('$i monday found');
  //print('Recent monday $now');

  return tabController;
}

int getMonthCount(int month) {
  int count = 0;
  if (month == 1) count = 31;
  if (month == 2) count = 28;
  if (month == 3) count = 31;
  if (month == 4) count = 30;
  if (month == 5) count = 31;
  if (month == 6) count = 30;
  if (month == 7) count = 31;
  if (month == 8) count = 31;
  if (month == 9) count = 30;
  if (month == 10) count = 31;
  if (month == 11) count = 30;
  if (month == 12) count = 31;
  return count;
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
//"http://telemedicine.drshahidulislam.com/" + widget.photo,
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

Widget appointmentFormWidget(String chamberID, String DATE) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Confirm Appointment"),
    ),
    body: SingleChildScrollView(
        child: AppointmentConfirmForm(id_.toString(), chamberID, DATE)),
  );
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
