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

List data = [];
String AUTH_KEY;

class SubscriptionViewPatient extends StatefulWidget {
  SubscriptionViewPatient();

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<SubscriptionViewPatient> {
  Future<String> getData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'get_subscription_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body:
          jsonEncode(<String, String>{'uid': USER_ID, 'user_type': "patient"}),
    );

    this.setState(() {
      data = json.decode(response.body);
      // showThisToast("subsc size "+ (data.length).toString());
    });

    return "Success!";
  }

  @override
  void initState() {
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text("Subscriptions"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "My Subscriptions",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Get Subscription"),
            ],
          ),
        ),
        body: TabBarView(
          children: [MySubscription((data)), NewSubscription()],
        ),
      ),
    );
  }
}

Widget MySubscription(List data) {
  return (data.length>0)?  ListView.builder(
    itemCount: data == null ? 0 : data.length,
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
                  data[index]["dr_info"]["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text(
                  (data[index]["number_of_months"]).toString() + " months",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ));
    },
  ):Center(child: Text("No Data"),);
}

Widget NewSubscription() {
  return new Text("New Subscription");
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
