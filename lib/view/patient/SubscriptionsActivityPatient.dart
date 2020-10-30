import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;
final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
List data = [];
String AUTH_KEY;
String uid, uname;
class SubscriptionViewPatient extends StatefulWidget {
  String AUTH,UID ;
  SubscriptionViewPatient(this.AUTH,this.UID);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<SubscriptionViewPatient> {
  Future<String> getData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
    uid = prefs.getString("uid");
    uname = prefs.getString("uname");
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'get_subscription_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.AUTH,
      },
      body:
          jsonEncode(<String, String>{'uid': widget.UID, 'user_type': "patient"}),
    );

    this.setState(() {
      showThisToast(response.statusCode.toString());
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
          children: [MySubscription(data,uid), NewSubscription()],
        ),
      ),
    );
  }
}

Widget MySubscription(List data,String uid) {
  return (data.length>0)?  ListView.builder(
    itemCount: data == null ? 0 : data.length,
    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: () {



            String chatRoom = createChatRoomName(
                int.parse(uid),
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
                        uid,
                        uname,
                        _baseUrl_image +
                            data[index]["dr_info"]["photo"],
                        chatRoom)));



//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              trailing: Icon(Icons.navigate_next),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_baseUrl_image+data[index]["dr_info"]["photo"]),
              ),
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(
                  data[index]["dr_info"]["name"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(10, 00, 0, 10),
                child:  getSubtitleWidget(data[index]),
              ),
            ),
          ));
    },
  ):Center(child: Text("No Data"),);
}

Widget getSubtitleWidget(dynamic data) {
  List<Widget>allWid = [];
  allWid.add(Text(
    (data["number_of_months"]).toString() + " months",
    style: TextStyle(fontWeight: FontWeight.bold),
  ));

  allWid.add(Text(
    "Open Chat/Call",style: TextStyle(color: Colors.blue),

  ));

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        (data["number_of_months"]).toString() + " months",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "Open Chat/Call",style: TextStyle(color: Colors.blue),

      )
    ],
  );
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
