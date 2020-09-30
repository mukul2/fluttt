import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:appxplorebd/utils/myCalender.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;

import 'AppointmentConfirmForm.dart';


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
  List skill_info = [];
  List education_info = [];
  List chamber_info = [];
  Future<String> getData() async {
    Future<SharedPreferences> _prefs =
    SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" +
          'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'dr_id': widget.id.toString()}),
    );
    //showThisToast(response.statusCode.toString());

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
 bool  _enabled = true;
  print(chambers);
  return  chambers.length ==0 ?Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: _enabled,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00.0),
                  ),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_right),
                    title: Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: double.infinity,
                          height: 12.0,
                          color: Colors.white,
                        )
                    ),
                  ),
                ),
              ),
              itemCount: 6,
            ),
          ),
        ),

      ],
    ),
  ): new ListView.builder(
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
                                chambers[index], context), //startwork
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
//this is real
Widget chamberBooking(chamber_info, BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Book an Appointment"),
    ),
    body: SingleChildScrollView(
        child: new Column(

          children: <Widget>[
            Card(

              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 00, 0),
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Expanded(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "http://telemedicine.drshahidulislam.com/" +
                                photo_),
                      ),
                    ),
                  ),
                ),
                trailing: Text((chamber_info["fee"]).toString() + " USD"),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Doctor", style: TextStyle(fontSize: 12),),
                    Text(name_, style: TextStyle(color: Colors.black),),
                    Text(designation_title_, style: TextStyle(fontSize: 12),)
                  ],
                ),
              ),
            ),

            Card(
                child: ListTile(
                  leading: Icon(Icons.label_important),
                  title: Text("Chamber Name"),
                  subtitle: Text((chamber_info["address"]).toString()),
                ),
            ),
            Card(
                child: ListTile(
                  leading: Icon(Icons.label_important),
                  title: Text("Followup Fees"),
                  subtitle: Text((chamber_info["follow_up_fee"]).toString()),
                ),
            ),
//

//            Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
//            ListTile(
//              title: Text("Chamber address"),
//              subtitle: Text((chamber_info["address"]).toString()),
//            ),
//            Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
//            ListTile(
//              title: Text("Chamber Fees"),
//              subtitle: Text((chamber_info["fee"]).toString()),
//            ),
//            Divider(
//              color: Colors.grey,
//              height: 1,
//            ),

//
//            Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
            printAllDates(chamber_info["chamber_days"], context,
                (chamber_info["id"]).toString(), (chamber_info["fees"]).toString())

          ],
        )),
  );
}

Widget printAllDates(chamber_days, BuildContext context, String chamber_id,String fees) {
  int seelctedPosition = 0;
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
//    return ListView.builder(
//      shrinkWrap: true,
//      itemCount: datesList == null ? 0 : datesList.length,
//      itemBuilder: (BuildContext context, int index) {
//        return new InkWell(
//            onTap: () {
////            Navigator.push(
////                context,
////                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
//            },
//            child: SizedBox(
//              height: 100,
//              width: 100,
//              child: Container(
//                width: 100,
//                height: 100,
//                child: Card(
//                  color: Colors.blue,
//                  child: Text(
//                    datesList[index],
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold, color: Colors.white),
//                  ),
//                ),
//              ),
//            ));
//      },
//    );

//
//    return GridView.builder(
//        itemCount: 20,
//        gridDelegate:
//        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//        itemBuilder: (BuildContext context, int index) {
//          return new GestureDetector(
//            child: new Card(
//              elevation: 5.0,
//              child: new Container(
//                alignment: Alignment.center,
//                child: new Text('Item $index'),
//              ),
//            ),
//            onTap: () {
//              showDialog(
//                barrierDismissible: false,
//                context: context,
//                child: new CupertinoAlertDialog(
//                  title: new Column(
//                    children: <Widget>[
//                      new Text("GridView"),
//                      new Icon(
//                        Icons.favorite,
//                        color: Colors.green,
//                      ),
//                    ],
//                  ),
//                  content: new Text("Selected Item $index"),
//                  actions: <Widget>[
//                    new FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        child: new Text("OK"))
//                  ],
//                ),
//              );
//            },
//          );
//        });


//    return ListView.builder(
//      shrinkWrap: true,
//      itemCount: datesList == null ? 0 : datesList.length,
//      itemBuilder: (BuildContext context, int index) {
//        return new InkWell(
//            onTap: () {
////            Navigator.push(
////                context,
////                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
//            },
//            child: Card(
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    color: Colors.pink,
//                    child: Padding(
//                      padding: EdgeInsets.all(0),
//                      child: ListTile(
//                        leading: Wrap(
//                          spacing: 0, // space between two icons
//                          children: <Widget>[
//                            Icon(
//                              Icons.navigate_before,
//                              color: Colors.white,
//                            ),
//                            // icon-1
//                            // icon-2
//                          ],
//                        ),
//                        trailing: Wrap(
//                          spacing: 12, // space between two icons
//                          children: <Widget>[
//                            Icon(
//                              Icons.navigate_next,
//                              color: Colors.white,
//                            ),
//                            // icon-1
//                            // icon-2
//                          ],
//                        ),
//                        title: Center(
//                            child: Text(
//                              datesList[index],
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold, color: Colors.white),
//                            )),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                    child:
//                    Text("Opening Time " + startTimesList[datesListWeekMap[index]]),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(0,0,0,15),
//                    child: Text("Closing Time " + endTimesList[datesListWeekMap[index]]),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(0),
//                    child: Center(
//                      child: RaisedButton(
//                        color: Colors.pink,
//                        child: Text("Book Appointment",
//                            style: TextStyle(color: Colors.white)),
//                        onPressed: () {
//                          SELECTED_DATE = datesList[index];
//                          showThisToast(SELECTED_DATE);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) =>
//                                  appointmentFormWidget(chamber_id,SELECTED_DATE)));
//                        },
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ));
//      },
//    );
//now work here
    for (int i = 0; i < datesList.length; i++) {
      tabBarView.children.add(Padding(
        padding: EdgeInsets.all(0),
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:
                Text("Opening Time " + startTimesList[datesListWeekMap[i]]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                    "Closing Time " + endTimesList[datesListWeekMap[i]]),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Center(
                  child: RaisedButton(
                    color: Colors.pink,
                    child: Text("Book Appointment",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      Future<SharedPreferences> _prefs =
                      SharedPreferences.getInstance();
                      SharedPreferences prefs;
                      prefs = await _prefs;
                      String auth = prefs.getString("auth");
                      String uid = prefs.getString("uid");

                      SELECTED_DATE = datesList[i];
                      showThisToast(SELECTED_DATE);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              appointmentFormWidget(
                                  chamber_id, SELECTED_DATE, auth, uid,fees)));
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

Widget appointmentFormWidget(String chamberID, String DATE, String auth,
    String uid,String fees) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Confirm Appointment "+fees),
    ),
    body: SingleChildScrollView(
        child: AppointmentConfirmForm(
            id_.toString(), chamberID, DATE, auth, uid)),
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
