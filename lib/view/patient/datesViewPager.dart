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
final String _baseUrl_image = "https://appointmentbd.com/";

List skill_info;
List education_info;
List chamber_info;

String name_;
String photo_;
String designation_title_;
int id_;
String AUTH_KEY;

class DatesViewPager extends StatefulWidget {
  String name;
  String photo;
  String designation_title;
  int id;

  DatesViewPager(
      this.id, this.name, this.photo, this.designation_title);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<DatesViewPager> {
  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" +
          'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'dr_id': widget.id.toString()}),
    );

    this.setState(() {
      skill_info = json.decode(response.body)["skill_info"];
      education_info = json.decode(response.body)["education_info"];
      chamber_info = json.decode(response.body)["chamber_info"];
    });

    //   print(skill_info);

    return "Success!";
  }

  @override
  void initState() async{
    name_ = widget.name;
    photo_ = widget.photo;
    designation_title_ = widget.designation_title;
    id_ = widget.id;
    this.getData();
    Future<SharedPreferences> _prefs =
    SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY =  prefs.getString("auth");
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
                            chamberBooking(chamber_info[index]), //startwork
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

Widget chamberBooking(chamber_info) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Book an Appointment here"),
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
                          _baseUrl_image + photo_,
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
            Card(
              child: printAllDates(),
            ),
          ],
        )),
  );
}

Widget printAllDates() {
  var monday = 1;
  var now = new DateTime.now();
  String dates = "";
 // showThisToast((now.month).toString() + ' starts');
  showThisToast(now.toString());
  now = now.add(new Duration(days: 0));
  showThisToast(now.toString());
  int i = 0;
//  while ((now.weekday) == monday) {
//    i++;
//    now = now.add(new Duration(days: 1));
//    dates += 'nxt monday $now' + '\n';
//    showThisToast(now.toString());
//  }
  for (int i = now.day; i < getMonthCount(now.month); i++) {
    now = now.add(new Duration(days: 1));
    if (now.weekday == monday) {
      dates += 'nxt monday $now' + '\n';
    }
  }
  //showThisToast('$i monday found');
  //print('Recent monday $now');

  return Text(dates);
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
