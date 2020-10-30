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
String AUTH_KEY ;
class OnlineDoctorFullProfileView extends StatefulWidget {
  String name;
  String photo;
  String designation_title;
  List online_doctors_service_info;
  int id;

  OnlineDoctorFullProfileView(
      this.id, this.name, this.photo, this.designation_title,this.online_doctors_service_info);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorFullProfileView> {


  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'dr_id': widget.id.toString()}),
    );

    this.setState(() {
      skill_info = json.decode(response.body)["skill_info"];
      education_info = json.decode(response.body)["education_info"];
    });

    print(skill_info);

    return "Success!";
  }

  @override
  void initState() async{
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
                text: "Services",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Skills"),
              Tab(icon: Icon(Icons.school), text: "Education"),
            ],
          ),
        ),
        body: TabBarView(
          children: [Services((widget.online_doctors_service_info)), Skills(skill_info), Educations(education_info)],
        ),
      ),
    );
  }
}

Widget Services(List online_doctors_service_info) {
  print(online_doctors_service_info);
  return new ListView.builder(
    itemCount: online_doctors_service_info == null ? 0 : online_doctors_service_info.length,

    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: (){
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
                child: new Text(online_doctors_service_info[index]["service_name_info"]["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((online_doctors_service_info[index]["fees_per_unit"]).toString()+CURRENCY_USD_SIGN,
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
              trailing: RaisedButton(
                color: Colors.pink,
                child: Text("Purchase",style: TextStyle(color: Colors.white),),
                onPressed: (){
                 // makePayment();
                  fun(number)async{
                    print('order id: '+number);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalPayment("","","",

                            fun
                        ),
                      )
                  );



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
          onTap: (){
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
                child: new Text(list[index]["body"],
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((list[index]["created_at"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
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
          onTap: (){
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
                child: new Text(education_info[index]["title"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((education_info[index]["body"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
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