import 'dart:async';
import 'package:appxplorebd/chat/model/chat_message.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/chat/model/root_page.dart';
import 'package:appxplorebd/chat/service/authentication.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import 'PatientsFullProfileView.dart';
import 'SubscriptionsActivityPatient.dart';
import 'Widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'myYoutubePlayer.dart';

var OWN_PHOTO="";
String AUTH_KEY="";

String UPHOTO="";
String UEMAIL="";
String UID="";
String UNAME="";
String UPHONE="";
String UDES="";
List medicineList = [];
var PARTNER_PHOTO;
Map<int, Color> colorCodes = {
  50: Color.fromRGBO(147, 205, 72, .1),
  100: Color.fromRGBO(147, 205, 72, .2),
  200: Color.fromRGBO(147, 205, 72, .3),
  300: Color.fromRGBO(147, 205, 72, .4),
  400: Color.fromRGBO(147, 205, 72, .5),
  500: Color.fromRGBO(147, 205, 72, .6),
  600: Color.fromRGBO(147, 205, 72, .7),
  700: Color.fromRGBO(147, 205, 72, .8),
  800: Color.fromRGBO(147, 205, 72, .9),
  900: Color.fromRGBO(147, 205, 72, 1),
};
// Green color code: FF93cd48
MaterialColor customColor = MaterialColor(0xFF34448c, colorCodes);
final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
var header = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Authorization': AUTH_KEY,
};
GlobalKey _bottomNavigationKey = GlobalKey();
Color tColor = Color(0xFF34448c);
SharedPreferences prefs;

void mainD() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await _prefs;
  AUTH_KEY = prefs.getString("auth");
  UID = prefs.getString("uid");
  UNAME = prefs.getString("uname");
  UPHOTO = prefs.getString("uphoto");
  UEMAIL = prefs.getString("uemail");
  UPHONE = prefs.getString("uphone");
  UDES = prefs.getString("udes");
  // = prefs.getString("auth");
  UID_FOR_CHAT = UID;

  runApp(DoctorAPP());
}
class DoctorAPP extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      // Navigator.of(context).pop(true);
      // showThisToast("backpressed");

      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: _onWillpop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(fontFamily: 'SF Pro Display Regular'),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
 /* String AUTH_KEY;

  String UPHOTO;
  String UEMAIL;
  String UID;
  String UNAME;
  String UPHONE;

  */

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int bottomSelectedIndex = 0;
  int _page = 0;
  List _titles = ["Home", "Notifications", "Profile", "Blog", "Settings"];
  GlobalKey _bottomNavigationKey = GlobalKey();

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            color: Colors.blue,
          ),
          title: new Text(
            'Home',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.notification_important,
          color: Colors.blue,
        ),
        title: new Text(
          'Notification',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.blue,
          ),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.calendar_today,
          color: Colors.blue,
        ),
        title: new Text(
          'Appointment',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Colors.blue,
          ),
          title: Text(
            'Blog',
            style: TextStyle(color: Colors.blue),
          ))
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(),
        ProjNotification(),
        Profile(),
        BlogActivityWithState(),
        SettingsWidState()
      ],
    );
  }
  loadSession()async{

    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.subscribeToTopic(UID);
/*
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    prefs = await _prefs;
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.subscribeToTopic(prefs.getString("uid"));
    setState(() {
      AUTH_KEY = prefs.getString("auth");
      UID = prefs.getString("uid");
      UNAME = prefs.getString("uname");
      UPHOTO = prefs.getString("uphoto");
      UEMAIL = prefs.getString("uemail");
      UPHONE = prefs.getString("uphone");
      // = prefs.getString("auth");
      UID_FOR_CHAT = UID;

      widget.AUTH_KEY = prefs.getString("auth");
      widget.UID = prefs.getString("uid");
      widget.UNAME = prefs.getString("uname");
      widget.UPHOTO = prefs.getString("uphoto");
      widget.UEMAIL = prefs.getString("uemail");
      widget.UPHONE = prefs.getString("uphone");




    });

 */
  }
  onBackPress(){
    Navigator.pop(this.context, false);
  }

  @override
  void initState()
  {
    super.initState();
    this.loadSession();


    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,
      /*     onLaunch: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("on launch " + message.toString());
        Navigator.push(
            useThisContext,
            MaterialPageRoute(
                builder: (context) => IncomingCallActivity(message["data"])));
      },

      onResume: (Map<String, dynamic> message) async {
        print("on resume " + message.toString());
        Navigator.push(
            useThisContext,
            MaterialPageRoute(
                builder: (context) => IncomingCallActivity(message["data"])));
      },

  */
      onMessage: (Map<String, dynamic> message) async {
        // _navigateToItemDetail(message);
        print("on message " + message.toString());

        //showThisToast(message["data"].toString());

        if (message["data"]["type"] == "reject_call" ) {
          this.onBackPress();

          showThisToast("User is busy");
        } else {
          showThisToast("unknown type");
        }
      },
    );

  }

  void pageChanged(int index) {
    CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
    navBarState.setPage(index);
    setState(() {
      bottomSelectedIndex = index;
      _page = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      Navigator.of(context).pop(true);
      //  showThisToast("backpressed");

      return Future.value(false);
    }

    return AppWidget(widget);
  }

  Widget AppWidget(MyHomePage widget) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[bottomSelectedIndex]),
        backgroundColor: Color(0xFF34448c),
        elevation: 0.0,
      ),
      drawer: myDrawer(widget),
      body: buildPageView(),
      bottomNavigationBar: CurvedNavigationBar(
        height: 56,
        color: Color(0xFF34448c),
        backgroundColor: Colors.white,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.face,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_today,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 20,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          bottomTapped(index);
          //Handle button tap
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: GridView.count(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmedListWidget(),
                    ));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/doctor.png",
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Appointments",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //chambeer app
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingListWidget(),
                    ));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          "assets/doctor_chamber.png",
                          height: 48,
                          width: 48,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Pending",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //pending
          InkWell(
              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => SubscriptionViewDoctor()));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/subscription.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Subscriptions",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //subscriptions
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatListActivity()));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                    height: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 48,
                          width: 48,
                          child: Image.asset(
                            "assets/live_chat.png",
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              "Chats",
                              style: TextStyle(color: Color(0xFF34448c)),
                            ))
                      ],
                    )),
              )),
          //chat
//          InkWell(
//              onTap: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => AmbulanceWidget()));
//              },
//              child: Card(
//                color: Colors.white,
//                child: Container(
//                  height: 110,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Container(
//                        height: 48,
//                        width: 48,
//                        child: Image.asset(
//                          "assets/ambulance.png",
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                      Padding(
//                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                          child: Text(
//                            "Ambulance",
//                            style: TextStyle(color: Color(0xFF34448c)),
//                          ))
//                    ],
//                  ),
//                ),
//              )), //ambulance
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescriptionRequestWid()));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/rx.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Prescription Req",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //pres request
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescriptionsReviewWidget()));
                // _controller.jumpTo(_controller.position.maxScrollExtent);
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/note.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Presc Review",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //Prescription Review

          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoCallListWidget()));
                // _controller.jumpTo(_controller.position.maxScrollExtent);
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/meeting.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Video Call",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          InkWell(
              onTap: () {
                // _controller.jumpTo(_controller.position.maxScrollExtent);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyEarningsWidget()));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/portfolio.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "My Earnings",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          //earnings
          InkWell(
              onTap: () {
                // _controller.jumpTo(_controller.position.maxScrollExtent);
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeVisitWidget(),
                    ));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/home_run.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Home Visits",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                ),
              )),
          InkWell(
              onTap: () {
                // _controller.jumpTo(_controller.position.maxScrollExtent);
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FollowupVideoAppointmentListActivityDoctor(
                                AUTH_KEY, UID)));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 48,
                        width: 48,
                        child: Image.asset(
                          "assets/video_call_img.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            "Follow up Online Appointment",
                            style: TextStyle(
                              color: Color(0xFF34448c),
                            ),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                ),
              )),

          //
        ],
      ),
    );
  }
}

class MyEarningsWidget extends StatefulWidget {
  @override
  _MyEarningsWidgetState createState() => _MyEarningsWidgetState();
}

class _MyEarningsWidgetState extends State<MyEarningsWidget> {
  String totalBill = "";
  String allWidthdraw = "";
  String wallet = "";
  List billDetails = [];
  List widthdrawDetails = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_payment_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'user_type': 'doctor', 'id': UID}),
    );
    this.setState(() {
      dynamic jsonResponse = json.decode(response.body);
      totalBill = jsonResponse["total_bill"].toString();
      allWidthdraw = jsonResponse["all_widthdraw"].toString();
      billDetails = jsonResponse["bill_details"];
      wallet = jsonResponse["wallet"].toString();
      //print(appointments.toString());
    });
    return "Success!";
  }

  @override
  void initState() {
    // TODO: implement initState
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
          title: new Text("Earnings"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "Summery",
              ),
              Tab(
                icon: Icon(Icons.work),
                text: "Collections",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Withdraw"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EarningSummeryWidget(totalBill, allWidthdraw, wallet),
            EarningCollectionsWidget(billDetails),
            EarningWidthDrawWidget(widthdrawDetails, wallet),
          ],
        ),
      ),
    );
  }
}

class EarningSummeryWidget extends StatefulWidget {
  String totalBill;

  String allWidthdraw;
  String wallet;

  EarningSummeryWidget(this.totalBill, this.allWidthdraw, this.wallet);

  @override
  _EarningSummeryWidgetState createState() => _EarningSummeryWidgetState();
}

class _EarningSummeryWidgetState extends State<EarningSummeryWidget> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(
                      "All Collections",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(widget.totalBill + " USD",
                        textAlign: TextAlign.justify),
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(
                      "All Withdrawn",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(widget.allWidthdraw + " USD",
                        textAlign: TextAlign.justify),
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(
                      "Available Balance",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 5),
                    child: Text(widget.wallet + " USD",
                        textAlign: TextAlign.justify),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EarningCollectionsWidget extends StatefulWidget {
  List billDetails = [];

  EarningCollectionsWidget(this.billDetails);

  @override
  _EarningCollectionsWidgetState createState() =>
      _EarningCollectionsWidgetState();
}

class _EarningCollectionsWidgetState extends State<EarningCollectionsWidget> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (widget.billDetails.length > 0)
            ? new ListView.builder(
                shrinkWrap: true,
                itemCount:
                    widget.billDetails == null ? 0 : widget.billDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_baseUrl_image +
                                    widget.billDetails[index]["patient_info"]
                                        ["photo"]),
                              ),
                              title: new Text(
                                widget.billDetails[index]["service_details"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: new Text(
                                widget.billDetails[index]["fees"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  );
                },
              )
            : Center(
                child: Text("No Data"),
              ));
  }
}

class EarningWidthDrawWidget extends StatefulWidget {
  List billDetails = [];
  String wallet;

  EarningWidthDrawWidget(this.billDetails, this.wallet);

  @override
  _EarningWidthDrawWidgetState createState() => _EarningWidthDrawWidgetState();
}

class _EarningWidthDrawWidgetState extends State<EarningWidthDrawWidget> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: (widget.billDetails.length > 0)
                ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.billDetails == null
                        ? 0
                        : widget.billDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Text(widget.billDetails[index]
                                          ["amount"]
                                      .toString()),
                                  title: new Text(
                                    widget.billDetails[index]["created_at"]
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: new Text(
                                    widget.billDetails[index]["status"]
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  )
                : Center(
                    child: Text("No Data"),
                  )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              final _formKey = GlobalKey<FormState>();
              String amount, bank;
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Request for Withdrawl'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          ListTile(
                            title: Text("Available in wallet"),
                            subtitle: Text(widget.wallet),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: TextFormField(
                                    initialValue: "",
                                    validator: (value) {
                                      amount = value;
                                      if (value.isEmpty) {
                                        return 'Please enter withdraw amount';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        fillColor: Colors.white10,
                                        border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.pink)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        labelText: "Amount"),
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: TextFormField(
                                    initialValue: "",
                                    validator: (value) {
                                      bank = value;
                                      if (value.isEmpty) {
                                        return 'Please enter bank details';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        fillColor: Colors.white10,
                                        border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.pink)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        labelText: "Bank Info"),
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                  ),
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
                        child: Text('Request'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (double.parse(amount) <=
                                double.parse(widget.wallet)) {
                             // showThisToast("permitted");
                            } else {
                            //  showThisToast("not permitted");
                            }
                            var status =
                                request_withdraw(AUTH_KEY, UID, amount, bank);

                            status.then((value) => Navigator.of(context).pop());
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Card(
              color: Colors.blue,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    "Withdraw Request",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeVisitWidget extends StatefulWidget {
  @override
  _HomeVisitWidgetState createState() => _HomeVisitWidgetState();
}

class _HomeVisitWidgetState extends State<HomeVisitWidget> {
  bool homeVisits = DOC_HOME_VISIT == 0 ? false : true;

  Future<void> _onRememberMeChanged(bool newValue) async {
    setState(() {
      homeVisits = newValue;
      newValue == true ? DOC_HOME_VISIT = 1 : DOC_HOME_VISIT = 0;
    });

    final http.Response response = await http.post(
      _baseUrl + 'update_home_visit_status',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'id': UID, 'status': DOC_HOME_VISIT.toString()}),
    );
    dynamic data = jsonEncode(response.body);
    print((response.body).toString());
    // showThisToast((response.statusCode).toString());
  }

  List appointments = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_home_visit_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'user_type': 'doctor', 'id': UID}),
    );
    this.setState(() {
      appointments = json.decode(response.body);
      print(appointments.toString());
    });
    return "Success!";
  }

  Future<PlacesDetailsResponse> _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = new GoogleMapsPlaces(
        apiKey:
            "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0"); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);

//    final Map<String, dynamic> data =
//    new Map<String, dynamic>();
//    data['lat'] = latitude;
//    data['log'] = longitude;
//    data['address'] = address;

    return detail;
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Visits"),
        actions: <Widget>[
          Checkbox(
            value: homeVisits,
            onChanged: _onRememberMeChanged,
          )
        ],
      ),
      body: ((appointments.length > 0)
          ? new ListView.builder(
              shrinkWrap: true,
              itemCount: appointments == null ? 0 : appointments.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(_baseUrl_image +
                                  appointments[index]["patient_info"]["photo"]),
                            ),
                            title: new Text(
                              appointments[index]["date"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Text(
                              appointments[index]["home_address"] +
                                  " , " +
                                  appointments[index]["phone"] +
                                  "\n" +
                                  appointments[index]["problems"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          CheckboxListTile(
                            title: Text("Served"),
                            value: appointments[index]["status"] == 0
                                ? false
                                : true,
                            onChanged: (bool newValue) async {
                              final http.Response response = await http.post(
                                _baseUrl + 'change_home_visit_status',
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': AUTH_KEY,
                                },
                                body: jsonEncode(<String, String>{
                                  'status': newValue ? "1" : "0",
                                  'id': (appointments[index]["id"]).toString()
                                }),
                              );
                              //  showThisToast((response.statusCode).toString());
                              this.getData();
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                        ],
                      )),
                );
              },
            )
          : Center(
              child: Text("No Data"),
            )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.home),
        label: Text("Add Home Address"),
        onPressed: () async {
          Prediction prediction = await PlacesAutocomplete.show(
              context: context,
              apiKey: "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0",
              mode: Mode.overlay,
              // Mode.overlay
              language: "en",
              components: [Component(Component.country, "bd")]);
          //  showThisToast((prediction.description).toString());
          GoogleMapsPlaces _places = new GoogleMapsPlaces(
              apiKey:
                  "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0"); //Same API_KEY as above
          PlacesDetailsResponse detail =
              await _places.getDetailsByPlaceId(prediction.placeId);

          double latitude = detail.result.geometry.location.lat;
          double longitude = detail.result.geometry.location.lng;
          String address = prediction.description;

          final http.Response response = await http.post(
            _baseUrl + 'addHomeVisitAddress',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': AUTH_KEY,
            },
            body: jsonEncode(<String, String>{
              'lat': latitude.toString(),
              'log': longitude.toString(),
              'address': address,
              'id': UID
            }),
          );
        },
      ),
    );
  }
}

class ConfirmedListWidget extends StatefulWidget {
  @override
  _ConfirmedListWidgetState createState() => _ConfirmedListWidgetState();
}

class _ConfirmedListWidgetState extends State<ConfirmedListWidget> {
  List confirmedList = [];

  Future getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-appointment-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'user_type': "doctor", 'id': UID, 'status': "1"}),
    );
    this.setState(() {
      confirmedList = json.decode(response.body);
      print(confirmedList.toString());
      // showThisToast((confirmedList.length).toString());
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
        title: Text("Confirmed Appointments"),
      ),
      body: (confirmedList != null && confirmedList.length > 0)
          ? ListView.builder(
              itemCount: confirmedList == null ? 0 : confirmedList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientFullProfileView(
                                  AUTH_KEY,
                                  confirmedList[index]["patient_info"]["id"]
                                      .toString(),
                                  confirmedList[index]["patient_info"]["name"],
                                  confirmedList[index]["patient_info"]
                                      ["photo"])));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              trailing: Icon(Icons.keyboard_arrow_right),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_baseUrl_image +
                                    confirmedList[index]["patient_info"]
                                        ["photo"]),
                              ),
                              title: new Text(
                                confirmedList[index]["patient_info"]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: new Text(
                                "Appointment Date : " +
                                    confirmedList[index]["date"] +
                                    "\n" +
                                    confirmedList[index]["problems"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0,
                                  onPressed: () async {
                                    final http.Response response =
                                        await http.post(
                                      _baseUrl + 'change-appointment-status',
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization': AUTH_KEY,
                                      },
                                      body: jsonEncode(<String, String>{
                                        'status': "3",
                                        'appointment_id': (confirmedList[index]
                                                ["id"])
                                            .toString()
                                      }),
                                    );
                                    dynamic res = json.decode(response.body);
                                    //   showThisToast(res["message"]);
                                    this.getData();
                                  },
                                  child: Text("Mark as Served"),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0,
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChamberAppointmentPrescriptionWriteWidget(
                                                    confirmedList[index])));
                                  },
                                  child: Text("Make Prescription"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text("No Appointment Data"),
            ),
    );
  }
}

class PendingListWidget extends StatefulWidget {
  @override
  _PendingListWidgetState createState() => _PendingListWidgetState();
}

class _PendingListWidgetState extends State<PendingListWidget> {
  List pendingList = [];

  Future getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-appointment-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'user_type': "doctor", 'id': UID, 'status': "0"}),
    );
    this.setState(() {
      pendingList = json.decode(response.body);
      print(pendingList.toString());
      // showThisToast((confirmedList.length).toString());
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
        title: Text("Pending Appointments"),
      ),
      body: (pendingList != null && pendingList.length > 0)
          ? ListView.builder(
              itemCount: pendingList == null ? 0 : pendingList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              trailing: Icon(Icons.keyboard_arrow_right),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_baseUrl_image +
                                    pendingList[index]["patient_info"]
                                        ["photo"]),
                              ),
                              title: new Text(
                                pendingList[index]["patient_info"]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: new Text(
                                "Appointment Date : " +
                                    pendingList[index]["date"] +
                                    "\n" +
                                    pendingList[index]["problems"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PatientFullProfileView(
                                                AUTH_KEY,
                                                pendingList[index]
                                                        ["patient_info"]["id"]
                                                    .toString(),
                                                pendingList[index]
                                                    ["patient_info"]["name"],
                                                pendingList[index]
                                                        ["patient_info"]
                                                    ["photo"])));
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0,
                                  onPressed: () async {
                                    final http.Response response =
                                        await http.post(
                                      _baseUrl + 'change-appointment-status',
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization': AUTH_KEY,
                                      },
                                      body: jsonEncode(<String, String>{
                                        'status': "1",
                                        'appointment_id': (pendingList[index]
                                                ["id"])
                                            .toString()
                                      }),
                                    );
                                    dynamic res = json.decode(response.body);
                                    //  showThisToast(res["message"]);
                                    this.getData();
                                  },
                                  child: Text("Confirm"),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GiveTestRecomdActivity(
                                                  pendingList[index]["id"]
                                                      .toString(),
                                                  function: (data) {
                                                    //showThisToast("im hit hit hit wioth "+data.length.toString());
                                                    setState(() {
//                                                selectedDepartment =
//                                                    data["id"].toString();
//                                                txtSelectDepartment =
//                                                    data["name"].toString();
                                                    });
                                                  },
                                                )));
                                  },
                                  child: Text("Test Recommendation"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text("No Appointment Data"),
            ),
    );
  }
}

//start
class GiveTestRecomdActivity extends StatefulWidget {
  String appp_id;

  List testList = [];
  Function function;
  List<String> selected = [];
  List selectedForUp = [];

  //ChooseDeptActivity(this.deptList__, this.function);
  GiveTestRecomdActivity(this.appp_id, {Key key, this.function})
      : super(key: key);

  @override
  _GiveTestRecomdActivityState createState() => _GiveTestRecomdActivityState();
}

class _GiveTestRecomdActivityState extends State<GiveTestRecomdActivity> {
  getData() async {
    String da = await getTestRecListData(AUTH_KEY);
    widget.testList = json.decode(da);
   // showThisToast("test count " + widget.testList.length.toString());
    setState(() {
      widget.testList = json.decode(da);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              onTap: () async {
                print(widget.selected.toString());
                //widget.function(widget.selected);
                for (int i = 0; i < widget.selected.length; i++) {
                  final Map<String, dynamic> data = new Map<String, dynamic>();
                  //data['id'] = widget.testList[index]["id"].toString();
                  data['test_id'] = widget.selected[i].toString();
                  widget.selectedForUp.add(data);
                }
                //add-test-recommendation

                final http.Response response = await http.post(
                  _baseUrl + 'add-test-recommendation',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': AUTH_KEY,
                  },
                  body: jsonEncode(<String, String>{
                    'appointment_id': widget.appp_id,
                    'test_ids': widget.selected.toString(),
                  }),
                );
                print(widget.selected);
                if (response.statusCode == 200) {
                  Navigator.of(context).pop(true);
                } else {
                  print(response.body);
                }
              },
              child: Icon(Icons.done_all),
            ),
          )
        ],
        title: Text("Choose Tests"),
      ),
      body: true
          ? ListView.builder(
              itemCount: widget.testList == null ? 0 : widget.testList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.selected.contains(
                            widget.testList[index]["id"].toString())) {
                          widget.selected
                              .remove(widget.testList[index]["id"].toString());
                        } else {
                          widget.selected
                              .add(widget.testList[index]["id"].toString());
                        }
                      });
                      final Map<String, dynamic> data =
                          new Map<String, dynamic>();
                      //data['id'] = widget.testList[index]["id"].toString();
                      data['name'] = widget.testList[index]["name"].toString();

                      // Navigator.of(context).pop(true);
                    },
                    child: Card(
                      color: widget.selected
                              .contains(widget.testList[index]["id"].toString())
                          ? Colors.blue
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: Icon(Icons.add),
                          title: new Text(
                            widget.testList[index]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text(widget.testList.toString()),
            ),
    );
  }
}
//ends

class LocationSelectionWidget extends StatefulWidget {
  @override
  _LocationSelectionWidgetState createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

class VideoCallListWidget extends StatefulWidget {
  @override
  _VideoCallListWidgetState createState() => _VideoCallListWidgetState();
}

class _VideoCallListWidgetState extends State<VideoCallListWidget> {
  List VideoCallListList = [];

  Future getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_video_appointment_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'user_type': "doctor",
        'id': UID,
        'isFollowup': "0",
      }),
    );
    this.setState(() {
      VideoCallListList = json.decode(response.body);
      print(VideoCallListList.toString());
      showThisToast((VideoCallListList.length).toString());
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
        title: Text("Video Calls"),
      ),
      body: (VideoCallListList != null && VideoCallListList.length > 0)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount:
                  VideoCallListList == null ? 0 : VideoCallListList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          String chatRoom = createChatRoomName(
                              int.parse(UID),
                              int.parse(VideoCallListList[index]["patient_info"]
                                      ["id"]
                                  .toString()));
                          CHAT_ROOM = chatRoom;
                         // showThisToast(chatRoom);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      VideoCallListList[index]["patient_info"]
                                              ["id"]
                                          .toString(),
                                      VideoCallListList[index]["patient_info"]
                                          ["name"],
                                      VideoCallListList[index]["patient_info"]
                                          ["photo"],
                                      UID,
                                      UNAME,
                                      UPHOTO,
                                      chatRoom)));
                        },
                        trailing: Icon(Icons.call),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage((_baseUrl_image +
                                  VideoCallListList[index]["patient_info"]
                                      ["photo"])
                              .toString()),
                        ),
                        title: new Text(
                          VideoCallListList[index]["patient_info"]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: new Text(
                          VideoCallListList[index]["created_at"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: CheckboxListTile(
                                title: Text("Done"),
                                value: VideoCallListList[index]
                                            ["appointment_status"] ==
                                        1
                                    ? true
                                    : false,
                                onChanged: (bool newValue) async {
                                  final http.Response response =
                                      await http.post(
                                    _baseUrl +
                                        'change_video_appointment_status',
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization': AUTH_KEY,
                                    },
                                    body: jsonEncode(<String, String>{
                                      'status': newValue ? "1" : "0",
                                      'appointment_id':
                                          (VideoCallListList[index]["id"])
                                              .toString()
                                    }),
                                  );
                                  //     showThisToast((response.statusCode).toString());
                                  this.getData();
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                            ),
                            Flexible(
                              child: RaisedButton(
                                color: Colors.white,
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PatientFullProfileView(
                                                  AUTH_KEY,
                                                  VideoCallListList[index]
                                                          ["patient_info"]["id"]
                                                      .toString(),
                                                  VideoCallListList[index]
                                                      ["patient_info"]["name"],
                                                  VideoCallListList[index]
                                                          ["patient_info"]
                                                      ["photo"])));
                                },
                                child: Text("View Profile"),
                              ),
                            ),
                            Flexible(
                              child: RaisedButton(
                                color: Colors.white,
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoAppointmentPrescriptionWriteWidget(
                                                  VideoCallListList[index])));
                                },
                                child: Text("Give Prescription"),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text("No Appointment Data"),
            ),
    );
  }
}

class PrescriptionRequestWid extends StatefulWidget {
  @override
  _PrescriptionRequestWidState createState() => _PrescriptionRequestWidState();
}

class _PrescriptionRequestWidState extends State<PrescriptionRequestWid> {
  List prescriptionReqList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'view-prescription-request',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'doctor'}),
    );
    print(response.body);
    this.setState(() {
      prescriptionReqList = json.decode(response.body);
      //  showThisToast("pres req size " + (prescriptionReqList.length).toString());
    });
    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription Request"),
      ),
      body: (prescriptionReqList != null && prescriptionReqList.length > 0)
          ? new ListView.builder(
              itemCount:
                  prescriptionReqList == null ? 0 : prescriptionReqList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrescriptionWriteWidget(
                                  prescriptionReqList[index])));
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
                            backgroundImage: NetworkImage(_baseUrl_image +
                                prescriptionReqList[index]["patient_info"]
                                    ["photo"]),
                          ),
                          title: new Text(
                            (prescriptionReqList[index]["dr_info"] == null
                                ? "No Doctor Name"
                                : prescriptionReqList[index]["patient_info"]
                                    ["name"]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            prescriptionReqList[index]["problem"],
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
                child: Text("No Prescription Request"),
              )),
    );
  }
}

class ChamberAppointmentPrescriptionWriteWidget extends StatefulWidget {
  dynamic confirmedList;

  ChamberAppointmentPrescriptionWriteWidget(this.confirmedList);

  @override
  _ChamberAppointmentPrescriptionWriteWidgetState createState() =>
      _ChamberAppointmentPrescriptionWriteWidgetState();
}

class _ChamberAppointmentPrescriptionWriteWidgetState
    extends State<ChamberAppointmentPrescriptionWriteWidget> {
  final _formKey_ = GlobalKey<FormState>();
  String choice;
  int mealTime = 0;
  String diseases = "no datas";
  bool morning = false;
  bool noon = true;
  bool evening = false;
  bool checkedValue = false;
  String dr_id = UID;
  String patient_id;

  @override
  void initState() {
    // showThisToast("patient id "+ widget.prescriptionreqModel["patient_info"]["id"].toString());
    print("pre model");
    print(widget.confirmedList);
    setState(() {
      patient_id = widget.confirmedList["patient_info"]["id"].toString();
      medicineList = [];
      noon = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Provide a Prescription",
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey_.currentState.validate()) {
                    setState(() {});
                  }

                  final http.Response response = await http.post(
                    _baseUrl + 'add-prescription-info',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': AUTH_KEY,
                    },
                    body: jsonEncode(<String, String>{
                      'patient_id': patient_id,
                      'dr_id': UID,
                      'diseases_name': diseases,
                      'medicine_info': jsonEncode(medicineList),
                      'dr_name': UNAME,
                      'service_id': "5",
                      'appointment_id': widget.confirmedList["id"].toString(),
                      'dr_name': widget.confirmedList["dr_info"]["name"],
                    }),
                  );
                  Navigator.pop(context, false);
                  Navigator.pop(context, false);
                 // Navigator.pop(context, false);
                 // showThisToast(response.body.["message"].toString());
                  print((jsonDecode(response.body))["message"]);
                  if (response.statusCode == 200) {
                    data_Confirmd = json.decode(response.body);
                    Navigator.pop(context, false);
                    Navigator.pop(context, false);
                    Navigator.pop(context, false);
                    return json.decode(response.body);

                    // return LoginResponse.fromJson(json.decode(response.body));
                  } else {
                    throw Exception('Failed to load album');
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey_,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  diseases = value;
                  if (value.isEmpty) {
                    return 'Please write detected diseases';
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
                    labelText: "Write The Diagnosed Diseases"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: medicineList == null ? 0 : medicineList.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                  onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AmbulanceBodyWidget(
//                            projectSnap.data[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        trailing: Icon(Icons.delete),
                        leading: Icon(Icons.note_add),
                        title: new Text(
                          medicineList[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            medicineList[index]["morning"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Morning"),
                                  )
                                : Text(""),
                            medicineList[index]["noon"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Noon"),
                                  )
                                : Text(""),
                            medicineList[index]["evening"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Evening"),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle_outline),
        label: Text("Add Medicine"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMedicineWidget(
                        function: (data) {
                          // showThisToast("im hit hit hit");
                          setState(() {
                            data["id"] = widget.confirmedList["id"].toString();
                            medicineList.add(data);
                          });
                        },
                      )));
        },
      ),
    );
  }
}

class VideoAppointmentPrescriptionWriteWidget extends StatefulWidget {
  dynamic confirmedList;

  VideoAppointmentPrescriptionWriteWidget(this.confirmedList);

  @override
  _VideoAppointmentPrescriptionWriteWidgetState createState() =>
      _VideoAppointmentPrescriptionWriteWidgetState();
}

class _VideoAppointmentPrescriptionWriteWidgetState
    extends State<VideoAppointmentPrescriptionWriteWidget> {
  final _formKey_ = GlobalKey<FormState>();
  String choice;
  int mealTime = 0;
  String diseases = "no datas";
  bool morning = false;
  bool noon = true;
  bool evening = false;
  bool checkedValue = false;
  String dr_id = UID;
  String patient_id;

  @override
  void initState() {
    // showThisToast("patient id "+ widget.prescriptionreqModel["patient_info"]["id"].toString());
    print("pre model");
    print(widget.confirmedList);
    setState(() {
      patient_id = widget.confirmedList["patient_info"]["id"].toString();
      medicineList = [];
      noon = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Provide a Prescription",
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey_.currentState.validate()) {
                    setState(() {});
                  }

                  final http.Response response = await http.post(
                    _baseUrl + 'add-prescription-info',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': AUTH_KEY,
                    },
                    body: jsonEncode(<String, String>{
                      'patient_id': patient_id,
                      'dr_id': UID,
                      'diseases_name': diseases,
                      'medicine_info': jsonEncode(medicineList),
                      'dr_name': UNAME,
                      'service_id': "5",
                      'appointment_id': widget.confirmedList["id"].toString(),
                      'dr_name': widget.confirmedList["dr_info"]["name"],
                    }),
                  );
                  Navigator.pop(context, false);
                  Navigator.pop(context, false);
                 // Navigator.pop(context, false);
                 // showThisToast(response.body["message"].toString());
                  print((jsonDecode(response.body))["message"]);
                  if (response.statusCode == 200) {
                    data_Confirmd = json.decode(response.body);
                    Navigator.pop(context, false);
                    Navigator.pop(context, false);
                    Navigator.pop(context, false);
                    // return json.decode(response.body);

                    // return LoginResponse.fromJson(json.decode(response.body));
                  } else {
                    Navigator.of(context).pop(true);
                    throw Exception('Failed to load album');
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey_,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  diseases = value;
                  if (value.isEmpty) {
                    return 'Please write detected diseases';
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
                    labelText: "Write The Diagnosed Diseases"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: medicineList == null ? 0 : medicineList.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                  onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AmbulanceBodyWidget(
//                            projectSnap.data[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        trailing: Icon(Icons.delete),
                        leading: Icon(Icons.note_add),
                        title: new Text(
                          medicineList[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            medicineList[index]["morning"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Morning"),
                                  )
                                : Text(""),
                            medicineList[index]["noon"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Noon"),
                                  )
                                : Text(""),
                            medicineList[index]["evening"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Evening"),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle_outline),
        label: Text("Add Medicine"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMedicineWidget(
                        function: (data) {
                          // showThisToast("im hit hit hit");
                          setState(() {
                            data["id"] = widget.confirmedList["id"].toString();
                            medicineList.add(data);
                          });
                        },
                      )));
        },
      ),
    );
  }
}

class PrescriptionWriteWidget extends StatefulWidget {
  dynamic prescriptionreqModel;

  PrescriptionWriteWidget(this.prescriptionreqModel);

  @override
  _PrescriptionWriteWidgettState createState() =>
      _PrescriptionWriteWidgettState();
}

class _PrescriptionWriteWidgettState extends State<PrescriptionWriteWidget> {
  final _formKey_ = GlobalKey<FormState>();
  String choice;
  int mealTime = 0;
  String diseases = "no datas";
  bool morning = false;
  bool noon = true;
  bool evening = false;
  bool checkedValue = false;
  String dr_id = UID;
  String patient_id;

  @override
  void initState() {
    // showThisToast("patient id "+ widget.prescriptionreqModel["patient_info"]["id"].toString());
    setState(() {
      patient_id = widget.prescriptionreqModel["patient_info"]["id"].toString();
      medicineList = [];
      noon = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Prescription - ",
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey_.currentState.validate()) {
                    setState(() {});

                    final http.Response response = await http.post(
                      _baseUrl + 'reply-prescription-request',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': patient_id,
                        'dr_id': UID,
                        'diseases_name': diseases,
                        'medicine_info': jsonEncode(medicineList),
                        'dr_name': UNAME,
                        'service_id': "5",
                      }),
                    );

                    showThisToast(response.body.toString());
                    print((jsonDecode(response.body))["message"]);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    if (response.statusCode == 200) {
                      mainD();
                    } else {
                      showThisToast("Error occured");
                    }
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey_,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  diseases = value;
                  if (value.isEmpty) {
                    return 'Please write detected diseases';
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
                    labelText: "Write The Diagnosed Diseases"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: medicineList == null ? 0 : medicineList.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                  onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AmbulanceBodyWidget(
//                            projectSnap.data[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        trailing: Icon(Icons.delete),
                        leading: Icon(Icons.note_add),
                        title: new Text(
                          medicineList[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            medicineList[index]["morning"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Morning"),
                                  )
                                : Text(""),
                            medicineList[index]["noon"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Noon"),
                                  )
                                : Text(""),
                            medicineList[index]["evening"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Evening"),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle_outline),
        label: Text("Add Medicine"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMedicineWidget(
                        function: (data) {
                          // showThisToast("im hit hit hit");
                          setState(() {
                            data["id"] =
                                widget.prescriptionreqModel["id"].toString();
                            medicineList.add(data);
                          });
                        },
                      )));

//          return showDialog<void>(
//            context: context,
//            barrierDismissible: false, // user must tap button!
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text('Add Medicine'),
//                content: SingleChildScrollView(
//                  child: ListBody(
//                    children: <Widget>[
//                      Text(morning.toString()),
//                      Form(
//                        key: _formKey,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Widgets.textFormField(
//                              darkBackground: false,
//                              labelText: 'Medicine Name',
//                              inputType: TextInputType.emailAddress,
//                              validator: (value) {
//                                medName = value;
//                                if (value.isEmpty) {
//                                  return 'Please enter Medicine Name';
//                                }
//                                return null;
//                              },
//                            ),
//                            Checkbox(
//                              value: morning,
//                              onChanged: (bool val){
//                                this. setState(() {
//                                  morning = val;
//                                });
//                              },
//                            ),
//                            CheckboxListTile(
//                              title: Text("Morning 1"),
//                              value: morning,
//                              onChanged: (bool newValue)  {
//                                showThisToast(newValue.toString());
//                                morning = false;
//                               this. setState(() {
//                                  morning = false;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//                            CheckboxListTile(
//                              title: Text("Noon"),
//                              value: noon,
//                              onChanged: (bool newValue)  {
//                                this. setState(() {
//                                  noon = newValue;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//
//                            CheckboxListTile(
//                              title: Text("Evening"),
//                              value: evening,
//                              onChanged: (bool newValue)  {
//                                this. setState(() {
//                                  evening = newValue;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text('Cancel'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                  FlatButton(
//                    child: Text('Add'),
//                    onPressed: () {
//                      if (_formKey.currentState.validate()) {
//                        setState(() {
//                          final Map<String, dynamic> data =
//                              new Map<String, dynamic>();
//                          data['name'] = medName;
//                          medicineList.add(data);
//                        });
//
//                        Navigator.of(context).pop();
//                      }
//                    },
//                  ),
//                ],
//              );
//            },
//          );
        },
      ),
    );
  }
}

class prescriptionModel {
  int medicine_id;
  String duration_type;
  int duration_length;
  String dose;
  bool isAfterMeal;

  prescriptionModel(
      {this.medicine_id,
      this.duration_type,
      this.duration_length,
      this.dose,
      this.isAfterMeal});
}

class SettingsWidState extends StatefulWidget {
  @override
  _SettingsWidStateState createState() => _SettingsWidStateState();
}

class _SettingsWidStateState extends State<SettingsWidState> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: tColor,
            height: 50.0,
            child: new TabBar(
              tabs: [
                Tab(
                  text: "Services",
                ),
                Tab(text: "Documents"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            myServicesWidget(AUTH_KEY, UID),
            Center(child: Text("Documents")),
          ],
        ),
      ),
    ));
  }
}

class ProjNotification extends StatefulWidget {
  @override
  _ProjNotificationState createState() => _ProjNotificationState();
}

class _ProjNotificationState extends State<ProjNotification> {
  @override
  Widget build(BuildContext context) {
    return NoticeList();
  }
}

class AddMedicineWidget extends StatefulWidget {
  Function function;

  AddMedicineWidget({
    Key key,
    this.function,
  }) : super(key: key);

  @override
  _AddMedicineWidgetState createState() => _AddMedicineWidgetState();
}

class _AddMedicineWidgetState extends State<AddMedicineWidget> {
  final _formKey = GlobalKey<FormState>();

  String medName = "No Medicine Selected";
  String medID = "0";
  int morning = 0;
  int noon = 0;
  int evening = 0;
  bool checkedValue = false;
  bool beforeMeal = false;
  String duration;

  String durationType = 'd';

  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(errorText: "Beans"),
      controller: TextEditingController(text: "Starting Text"),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  List<String> suggestions = [];
  List medicineList = [];

  Future<String> getData() async {
    final http.Response response = await http.get(
      _baseUrl + 'all-medicine-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
    );
    medicineList = json.decode(response.body);
    print(medicineList.toString());
    this.setState(() {
      for (int i = 0; i < medicineList.length; i++) {
        suggestions.add(
            medicineList[i]["name"] + " #" + medicineList[i]["id"].toString());
      }
    });
    return "Success!";
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                textField.triggerSubmitted();
                showWhichErrorText = !showWhichErrorText;
                textField.updateDecoration(
                    decoration: new InputDecoration(
                        errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Medicine"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ListTile(
                  title: Text("Medicine Name"),
                  subtitle: Text(
                    medName,
                  ),
                )),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SimpleAutoCompleteTextField(
                      key: key,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Add or Change Medicine",
                      ),
                      controller: TextEditingController(text: ""),
                      suggestions: suggestions,
                      textChanged: (text) => currentText = text,
                      clearOnSubmit: true,
                      textSubmitted: (text) => setState(() {
                        medName = text;
                        List all = text.split(" ");
                        //showThisToast(all[all.length - 1]);
                        medID =
                            all[all.length - 1].toString().replaceAll("#", "");
                        if (text != "") {
                          added.add(text);
                        }
                      }),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text("Morning"),
                    value: morning == 0 ? false : true,
                    onChanged: (bool newValue) {
                      this.setState(() {
                        morning = newValue ? 1 : 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  CheckboxListTile(
                    title: Text("Noon"),
                    value: noon == 0 ? false : true,
                    onChanged: (bool newValue) {
                      this.setState(() {
                        noon = newValue ? 1 : 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  CheckboxListTile(
                    title: Text("Evening"),
                    value: evening == 0 ? false : true,
                    onChanged: (bool newValue) {
                      this.setState(() {
                        evening = newValue ? 1 : 0;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Before Meal"),
                          value: beforeMeal,
                          onChanged: (bool newValue) {
                            this.setState(() {
                              beforeMeal = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("After Meal"),
                          value: !beforeMeal,
                          onChanged: (bool newValue) {
                            this.setState(() {
                              beforeMeal = !newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 150,
                          child: Widgets.textFormField(
                            darkBackground: false,
                            labelText: 'Duration',
                            inputType: TextInputType.number,
                            validator: (value) {
                              duration = value;
                              if (value.isEmpty) {
                                return 'Please enter duration';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Days"),
                          value: durationType == 'd' ? true : false,
                          onChanged: (bool newValue) {
                            this.setState(() {
                              if (newValue) {
                                durationType = 'd';
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Week"),
                          value: durationType == 'w' ? true : false,
                          onChanged: (bool newValue) {
                            this.setState(() {
                              if (newValue) {
                                durationType = 'w';
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text("Month"),
                          value: durationType == 'm' ? true : false,
                          onChanged: (bool newValue) {
                            this.setState(() {
                              if (newValue) {
                                durationType = 'm';
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            final Map<String, dynamic> data =
                                new Map<String, dynamic>();
                            //data['prescription_id'] = widget.prescription_id;
                            data['medicine_id'] = medID;
                            data['name'] = medName;
                            data['morning'] = morning;
                            data['noon'] = noon;
                            data['evening'] = evening;
                            data['duration_type'] = durationType;
                            data['duration_length'] = duration;
                            data['dose'] = "" +
                                morning.toString() +
                                "-" +
                                noon.toString() +
                                "-" +
                                evening.toString();
                            data['isAfterMeal'] = beforeMeal ? "1" : "0";
                            widget.function(data);
                            showThisToast(data['isAfterMeal']);
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FollowupVideoAppointmentListActivityDoctor extends StatefulWidget {
  String AUTH, USER_ID;

  FollowupVideoAppointmentListActivityDoctor(this.AUTH, this.USER_ID);

  @override
  _FollowupVideoAppointmentListActivityDoctorState createState() =>
      _FollowupVideoAppointmentListActivityDoctorState();
}

class _FollowupVideoAppointmentListActivityDoctorState
    extends State<FollowupVideoAppointmentListActivityDoctor> {
  List data = [];

  Future getData() async {
    body = <String, String>{
      'user_type': "doctor",
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
        title: Text("Followup Video Calls"),
      ),
      body: (data != null && data.length > 0)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          String chatRoom = createChatRoomName(
                              int.parse(widget.USER_ID),
                              int.parse(data[index]["patient_info"]["id"]
                                  .toString()));
                          CHAT_ROOM = chatRoom;
                          showThisToast(chatRoom);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      data[index]["patient_info"]["id"]
                                          .toString(),
                                      data[index]["patient_info"]["name"],
                                      data[index]["patient_info"]["photo"],
                                      widget.USER_ID,
                                      UNAME,
                                      UPHOTO,
                                      chatRoom)));
                        },
                        trailing: Icon(Icons.call),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage((_baseUrl_image +
                                  data[index]["patient_info"]["photo"])
                              .toString()),
                        ),
                        title: new Text(
                          data[index]["patient_info"]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: new Text(
                          data[index]["created_at"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: CheckboxListTile(
                                title: Text("Done"),
                                value: data[index]["appointment_status"] == 1
                                    ? true
                                    : false,
                                onChanged: (bool newValue) async {
                                  final http.Response response =
                                      await http.post(
                                    _baseUrl +
                                        'change_video_appointment_status',
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization': widget.AUTH,

                                    },
                                    body: jsonEncode(<String, String>{
                                      'status': newValue ? "1" : "0",
                                      'appointment_id':
                                          (data[index]["id"]).toString()
                                    }),
                                  );
                                  //     showThisToast((response.statusCode).toString());
                                  this.getData();
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                            ),
                            Flexible(
                              child: RaisedButton(
                                color: Colors.white,
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PatientFullProfileView(
                                                  widget.AUTH,
                                                  data[index]["patient_info"]
                                                          ["id"]
                                                      .toString(),
                                                  data[index]["patient_info"]
                                                      ["name"],
                                                  data[index]["patient_info"]
                                                      ["photo"])));
                                },
                                child: Text("View Profile"),
                              ),
                            ),
                            Flexible(
                              child: RaisedButton(
                                color: Colors.white,
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoAppointmentPrescriptionWriteWidget(
                                                  data[index])));
                                },
                                child: Text("Give Prescription"),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text("No Appointment Data"),
            ),
    );
  }
}

Widget AmbulanceBodyWidget(dynamic ambulanceBody) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Ambulance"),
    ),
    body: ListView(
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/ambulance.png",
            width: 250,
            height: 250,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title"),
              Text(ambulanceBody["Title"], style: TextStyle(color: tColor)),
              Text("phone"),
              Text(ambulanceBody["phone"], style: TextStyle(color: tColor)),
              Text("area"),
              Text(ambulanceBody["area"], style: TextStyle(color: tColor)),
              Text("address"),
              Text(ambulanceBody["address"], style: TextStyle(color: tColor)),
              Text("District"),
              Text(ambulanceBody["district_info"]["name"],
                  style: TextStyle(color: tColor)),
              Center(
                child: InkWell(
                  onTap: () {
                    launch("tel://" + ambulanceBody["phone"]);
                  },
                  child: Card(
                    color: Color(0xFF34448c),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text("Call Ambulance",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget AmbulanceWidget() {
  return Scaffold(
      appBar: AppBar(
        title: Text("Ambulances"),
      ),
      body: FutureBuilder(
          future: fetchAmbulance(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AmbulanceBodyWidget(
                                        projectSnap.data[index])));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: Icon(Icons.directions_bus),
                                title: new Text(
                                  projectSnap.data[index]["area"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["address"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Widget NoticeList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchNotices(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: Icon(Icons.notifications),
                                title: new Text(
                                  projectSnap.data[index]["message"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["created_at"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              //BasicProfileActivity
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BasicProfile()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Basic Information"),
            subtitle: Text("Update name,photo"),
            leading: Icon(Icons.supervised_user_circle),
          ),
          Divider(),
          ListTile(
            onTap: () {
              //SkillsActivity
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EducationsActivity(AUTH_KEY, UID)));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Education"),
            subtitle: Text("Add/View your education history"),
            leading: Icon(Icons.supervised_user_circle),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SkillsActivity(AUTH_KEY, UID)));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Skills"),
            subtitle: Text("Add/View your skills"),
            leading: Icon(Icons.supervised_user_circle),
          ),
          Divider(),
          ListTile(
            //
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChamberActivity(AUTH_KEY, UID)));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Chamber"),
            subtitle: Text("Add/View your chamber"),
            leading: Icon(Icons.supervised_user_circle),
          ),
        ],
      ),
    );
  }
}

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Color(0xFF34448c),
            height: 50.0,
            child: new TabBar(
              tabs: [
                Tab(text: "Confirmed"),
                Tab(text: "Pending"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ConfirmedList(),
            PedingList(),
          ],
        ),
      ),
    ));
  }
}

bool isConfirmedLoading = true;

bool isPendingLoading = true;

List data_Confirmd;

Widget ConfirmedList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchConfirmed(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  "https://appointmentbd.com/" +
                                      projectSnap.data[index]["dr_info"]
                                          ["photo"],
                                )),
                                title: new Text(
                                  projectSnap.data[index]["dr_info"]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["date"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Widget PedingList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchPeding(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  _baseUrl_image +
                                      projectSnap.data[index]["dr_info"]
                                          ["photo"],
                                )),
                                title: new Text(
                                  projectSnap.data[index]["dr_info"]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["date"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Future<dynamic> fetchConfirmed() async {
//  showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': UID, 'status': "1"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    //  showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchPeding() async {
  // showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': UID, 'status': "0"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    // showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchNotices() async {
  // showThisToast("going to fetch noticies list");
  final http.Response response = await http.post(
    _baseUrl + 'getMyNotices',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(<String, String>{'user_id': UID}),
  );

  if (response.statusCode == 200) {
    List noti = json.decode(response.body);
    //  showThisToast("noti sixe " + noti.length.toString());
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchAmbulance() async {
  final http.Response response = await http.get(
    _baseUrl + 'view-ambulance',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );

  if (response.statusCode == 200) {
    List noti = json.decode(response.body);
    //  showThisToast("noti sixe " + noti.length.toString());
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Blog"),
    );
  }
}

Widget myDrawer(MyHomePage widget) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          color: tColor,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(_baseUrl_image + UPHOTO),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                    child: new Center(
                      child: Text(
                        UNAME,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )),
              ],
            ),
          ),
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/logo2.jpeg"),
          ),
          title: Text('Website'),
          onTap: () {
            const url = "https://abettahealth.com/";

            launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/facebook.png"),
          ),
          title: Text('Facebook'),
          onTap: () {
            const url = "https://web.facebook.com/Betta-Health-112876333823426/";

            launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),

        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/twitter.png"),
          ),
          title: Text('Twitter'),
          onTap: () {
            const url = "https://twitter.com/HealthBetta";

            launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/info.png"),
          ),
          title: Text('Privacy Policy'),
          onTap: () {
            const url = "https://abettahealth.com/privacy-policy/";

             launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/logout.png"),
          ),
          title: Text('Logout'),
          onTap: () {
            setLoginStatus(false);
            runApp(LoginUI());
          },
        ),
      ],
    ),
  );
}

class DeptOnlineActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Department (Online)"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
    );
  }
}

Widget BlogDetailsWidget(blogdata) {
  return Scaffold(
    appBar: AppBar(
      title: Text(blogdata["title"].toString()),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          (blogdata["youtube_video"] == null)
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Image.network(
                      _baseUrl_image + blogdata["photo_info"][0]["photo"]),
                )
              : Container(
                  height: 250,
                  child: MyHomePageYoutube(),
                ),
          Text(
            blogdata["body"].toString(),
          )
        ],
      ),
    ),
  );
}

class ChatListActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
      body: ChatListWidget(context),
    );
  }
}

class BasicProfile extends StatefulWidget {
  @override
  _BasicProfileState createState() => _BasicProfileState();
}

class _BasicProfileState extends State<BasicProfile> {
  String user_name_from_state = UNAME;
  String user_designation_from_state = UDES;
  String user_picture = UPHOTO;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: InkWell(
            onTap: () async {
              File image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
              var stream =
                  new http.ByteStream(DelegatingStream.typed(image.openRead()));
              var length = await image.length();

              var uri = Uri.parse(_baseUrl + "update-user-info");

              var request = new http.MultipartRequest("POST", uri);
              var multipartFile = new http.MultipartFile(
                  'photo', stream, length,
                  filename: basename(image.path));
              //contentType: new MediaType('image', 'png'));

              request.files.add(multipartFile);
              request.fields.addAll(<String, String>{'user_id': UID});
              request.headers.addAll(header);
              //showThisToast(AUTH_KEY+"/n"+UID);

              var response = await request.send();

              print(response.statusCode);
              //showThisToast(response.statusCode.toString());

              response.stream.transform(utf8.decoder).listen((value) {
                //print(value);
                //showThisToast(value);

                var data = jsonDecode(value);
                //showThisToast(data.t);
                showThisToast((data["photo"]).toString());
                setState(() {
                  user_picture = (data["photo"]).toString();
                  UPHOTO = user_picture;
                });
              });
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(_baseUrl_image + UPHOTO),
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
            child: Card(
              child: ListTile(
                onTap: () {
                  final _formKey = GlobalKey<FormState>();
                  String newName;
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Display Name'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      initialValue: user_name_from_state,
                                      validator: (value) {
                                        newName = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Display Name';
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                var status =
                                    updateDisplayName(AUTH_KEY, UID, newName);
                                UNAME = newName;
                                prefs.setString("uname", newName);

                                setState(() {
                                  user_name_from_state = newName;
                                  UNAME = newName;
                                });
                                status.then(
                                    (value) => Navigator.of(context).pop());
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(user_name_from_state),
                ),
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                      child: Text("Display Name"),
                    ),
                    Padding(
                      child: Text(
                        "EDIT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                    )
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
            child: Card(
              child: ListTile(
                onTap: () {
                  final _formKey = GlobalKey<FormState>();
                  String newName;
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Designation'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      initialValue: user_designation_from_state,
                                      validator: (value) {
                                        newName = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Designation';
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                var status =
                                updateDesignationName(AUTH_KEY, UID, newName);
                                UNAME = newName;
                                prefs.setString("udes", newName);

                                setState(() {
                                  user_designation_from_state = newName;
                                  UDES = newName;
                                });
                                status.then(
                                        (value) => Navigator.of(context).pop());
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(user_designation_from_state),
                ),
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                      child: Text("Designation"),
                    ),
                    Padding(
                      child: Text(
                        "EDIT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 00, 10, 00),
            child: Card(
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(UPHONE),
                ),
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                      child: Text("Phone"),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 00, 10, 10),
            child: Card(
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(UEMAIL),
                ),
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                      child: Text("Email"),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BasicProfileActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: Image.network(
            "https://cdnph.upi.com/svc/sv/upi/7371577364249/2019/1/054ab8e380c0922db843a715455feaf7/Gal-Gadot-to-co-produce-adaptation-of-novel-banned-in-Israeli-schools.jpg",
            width: 150,
            height: 150,
          )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Card(
              child: ListTile(
                onTap: () {
                  showNameEditDialog(context);
                },
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(UNAME),
                ),
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                      child: Text("Display Name"),
                    ),
                    Padding(
                      child: Text(
                        "EDIT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BlogActivityWithState extends StatefulWidget {
  @override
  _BlogActivityWithStateState createState() => _BlogActivityWithStateState();
}

class _BlogActivityWithStateState extends State<BlogActivityWithState> {
  List blogCategoryList = [];
  List blogList = [];
  int _value = 0;

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'allBlogCategory',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
    );
    this.setState(() {
      blogCategoryList = json.decode(response.body);
      getBlogs();
    });
    return "Success!";
  }

  Future<String> getBlogs() async {
    // showThisToast("Hit to download blogs " + (blogCategoryList[_value]["id"]).toString());
    final http.Response response = await http.post(
      _baseUrl + 'all-blog-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'blog_category': (blogCategoryList[_value]["id"]).toString()
      }),
    );
    this.setState(() {
      blogList = json.decode(response.body);
      // showThisToast("blog size " + (blogList.length).toString());
    });
    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: (blogCategoryList.length > 0)
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      blogCategoryList == null ? 0 : blogCategoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: InkWell(
                          onTap: () async {
                            setState(() {
                              _value = index;
                            });
                            final http.Response response = await http.post(
                              _baseUrl + 'all-blog-info',
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': AUTH_KEY,
                              },
                              body: jsonEncode(<String, String>{
                                'blog_category':
                                    (blogCategoryList[_value]["id"]).toString()
                              }),
                            );
                            this.setState(() {
                              blogList = json.decode(response.body);
                              //    showThisToast("blog size " + (blogList.length).toString());
                            });
                          },
                          child: _value == index
                              ? Card(
                                  color: Color(0xFF34448c),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Center(
                                        child: Text(
                                          blogCategoryList[index]["name"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Center(
                                        child: Text(
                                          blogCategoryList[index]["name"],
                                          style: TextStyle(
                                              color: Color(0xFF34448c)),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                    );
                  },
                )
              : Text("No Category"),
        ),
        (blogList.length > 0)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: blogList == null ? 0 : blogList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 300,
                    child: InkWell(
                        onTap: () {
                          LinkToPlay =
                              (blogList[index]["youtube_video"].toString())
                                  .replaceAll("https://youtu.be/", "");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BlogDetailsWidget(blogList[index])));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        (_baseUrl_image +
                                            (blogList[index]["dr_info"]
                                                    ["photo"])
                                                .toString())),
                                  ),
                                  title: new Text(
                                    blogList[index]["title"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: new Text(
                                    (blogList[index]["dr_info"]["name"])
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Expanded(
                                  child: new Image.network(
                                    (_baseUrl_image +
                                        (blogList[index]["photo_info"][0]
                                                ["photo"])
                                            .toString()),
                                    fit: BoxFit.fitWidth,
                                    height: 250,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
                },
              )
            : Container(
                height: 200,
                child: Center(
                  child: Text("No Blog Post"),
                ),
              )
      ],
    );
  }
}

Future<void> showNameEditDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  String newName;

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Display Name'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: UNAME,
                      validator: (value) {
                        newName = value;
                        if (value.isEmpty) {
                          return 'Please enter Display Name';
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
            onPressed: () {
              if (_formKey.currentState.validate()) {
                var status = updateDisplayName(AUTH_KEY, UID, newName);
                status.then((value) => () {
                      Navigator.of(context).pop();
                      prefs.setString("uname", newName);
                    });
              }
            },
          ),
        ],
      );
    },
  );
}

Widget ChatListWidget(BuildContext context) {
  // String UID = USER_ID;

  // FirebaseDatabase.instance.reference().child("xploreDoc").once()
  return Scaffold(
    body: FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child("xploreDoc")
            .child("lastChatHistory")
            .child(UID)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.value != null) {
            List lists = [];
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            showThisToast("chat histoory siz " + (lists.length).toString());
            return lists.length > 0
                ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          String own_id = UID;
                          String own_name = UNAME;
                          OWN_PHOTO = UPHOTO;
                          String partner_id = "";
                          String partner_name = "";
                          String parner_photo = "";

                          if (UID == (lists[index]["sender_id"])) {
                            partner_id = lists[index]["recever_id"];
                            partner_name = lists[index]["receiver_name"];
                            parner_photo = lists[index]["receiver_photo"];
                          } else {
                            partner_id = lists[index]["sender_id"];
                            partner_name = lists[index]["sender_name"];
                            parner_photo = lists[index]["sender_photo"];
                          }

                          String own_photo = UPHOTO;
                          PARTNER_PHOTO = parner_photo;

                          String chatRoom = createChatRoomName(
                              int.parse(UID), int.parse(partner_id));
                          CHAT_ROOM = chatRoom;

                          //showThisToast(lists[index].toString());



                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(

                                      partner_id,
                                      partner_name,
                                      parner_photo,
                                      own_id,
                                      own_name,
                                      own_photo,
                                      chatRoom)));
                        },
                        child: Card(
                            child: (UID ==
                                    ((lists[index]["sender_id"])
                                        .toString())) //im this ms sender
                                ? ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      "https://appointmentbd.com/" +
                                          lists[index]["receiver_photo"],
                                    )),
                                    title: Text(lists[index]["receiver_name"]),
                                    subtitle: (lists[index]["message_body"])
                                            .toString()
                                            .startsWith("http")
                                        ? Text("Photo")
                                        : Text((lists[index]["message_body"])
                                            .toString()),
                                  )
                                : ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      "https://appointmentbd.com/" +
                                          lists[index]["sender_photo"],
                                    )),
                                    title: Text(lists[index]["sender_name"]),
                                    subtitle: (lists[index]["message_body"])
                                            .toString()
                                            .startsWith("http")
                                        ? Text("Photo")
                                        : Text((lists[index]["message_body"])
                                            .toString()),
                                  )),
                      );
                    })
                : Center(
                    child: Text("No Chat History"),
                  );
          } else {
            //showThisToast(snapshot.data.value.toString());
          }
          return Center(
            child: Text("No Chat History"),
          );
        }),
  );
}

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}

Widget getChatList() {
  final dbRef = FirebaseDatabase.instance.reference().child("xploreDoc");
}

class DiseasesWidget extends StatefulWidget {
  @override
  _DiseasesWidgetState createState() => _DiseasesWidgetState();
}

class _DiseasesWidgetState extends State<DiseasesWidget> {
  List diseasesList = [];
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime.now().toIso8601String();
  String dateToUpdate = (DateTime.now().year).toString() +
      "-" +
      (DateTime.now().month).toString() +
      "-" +
      (DateTime.now().day).toString();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selctedDate_ = selectedDate.toIso8601String();
        dateToUpdate = (picked.year).toString() +
            "-" +
            (picked.month).toString() +
            "-" +
            (picked.day).toString();
      });
  }

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'patient-disease-record',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'patient_id': UID}),
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
      appBar: AppBar(
        title: Text("Diseaes History"),
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _formKey = GlobalKey<FormState>();
          String diseaesName, currentStatus, firstNoticeDate;
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Diseases Information'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Diseases name"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  diseaesName = value;
                                  if (value.isEmpty) {
                                    return 'Please enter Diseases Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text("First notice date"),
                            RaisedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select date'),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                                child: Text(dateToUpdate)),
                            Text("Current status"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  currentStatus = value;
                                  if (value.isEmpty) {
                                    return 'Please enter current status';
                                  }
                                  return null;
                                },
                              ),
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        var status = addDiseasesHistory(AUTH_KEY, UID,
                            diseaesName, dateToUpdate, currentStatus);

                        status.then((value) => this.closeAndUpdate(context));
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class PrescriptionsWidget extends StatefulWidget {
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
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
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
      appBar: AppBar(
        title: Text("Prescription History"),
      ),
      body: (prescriptionList != null && prescriptionList.length > 0)
          ? new ListView.builder(
              itemCount: prescriptionList == null ? 0 : prescriptionList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrescriptionsodyWidget(
                                  prescriptionList[index])));
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _formKey = GlobalKey<FormState>();
          String diseaesName;
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Prescription'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Diseases Name"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  diseaesName = value;
                                  if (value.isEmpty) {
                                    return 'Please enter diseases name';
                                  }
                                  return null;
                                },
                              ),
                            )
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
                      child: Text('Choose Photo From Gallary'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          File image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          var stream = new http.ByteStream(
                              DelegatingStream.typed(image.openRead()));
                          var length = await image.length();

                          var uri = Uri.parse(
                              _baseUrl + "add_prescription_photo_only");

                          var request = new http.MultipartRequest("POST", uri);
                          var multipartFile = new http.MultipartFile(
                              'photo', stream, length,
                              filename: basename(image.path));
                          //contentType: new MediaType('image', 'png'));

                          request.files.add(multipartFile);
                          request.fields
                              .addAll(<String, String>{'patient_id': UID});
                          request.fields.addAll(
                              <String, String>{'diseases_name': diseaesName});
                          request.headers.addAll(<String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization': AUTH_KEY,
                          });
                          //     showThisToast(request.toString());

                          var response = await request.send();

                          print(response.statusCode);
                          //   showThisToast(response.statusCode.toString());
                          this.closeAndUpdate(context);
                        }
                      })
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class PrescriptionsodyWidget extends StatefulWidget {
  dynamic prescriptionBody;
  dynamic oldPrescription;

  PrescriptionsodyWidget(this.prescriptionBody);

  @override
  _PrescriptionsBodyWidgetState createState() =>
      _PrescriptionsBodyWidgetState();
}

class _PrescriptionsBodyWidgetState extends State<PrescriptionsodyWidget> {
  List prescriptionList = [];

  Future<String> getOldPrescription(String id) async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      //showThisToast(response.body);
      widget.oldPrescription = json.decode(response.body);
    });
    //showThisToast(response.statusCode.toString());
    return "Success!";
  }

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-prescription-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
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
    this.getOldPrescription(
        widget.prescriptionBody["old_prescription_id"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription Body 0 "),
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 60,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                              widget.prescriptionBody["patient_info"]["name"]),
                          subtitle:
                              Text(widget.prescriptionBody["patient_comment"]),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(_baseUrl_image +
                                widget.prescriptionBody["patient_info"]
                                    ["photo"]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(00),
                              child: Container(
                                color: Colors.blue,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Old Prescription",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                              child: ListTile(
                                title: Text("Doctors Comment"),
                                subtitle: Text(widget.oldPrescription != null
                                    ? widget.oldPrescription["diseases_name"]
                                    : "Loading"),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: Text("Prescribed Medicines List"),
                            ),
                            medicinesListOfAPrescriptionWidget(
                                widget.oldPrescription),
                            (widget.prescriptionBody["attachment"] != null
                                ? Image.network(_baseUrl_image +
                                    widget.prescriptionBody["attachment"][0]
                                        ["file"])
                                : Text(""))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PrescriptionWriteWidgetForReview(widget.prescriptionBody)));
                },
                child: Card(
                  color: Colors.blue,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Give Prescription",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

//
class PrescriptionWriteWidgetForReview extends StatefulWidget {
  dynamic prescriptionreqModel;

  PrescriptionWriteWidgetForReview(this.prescriptionreqModel);

  @override
  _PrescriptionWriteWidgetForReviewState createState() =>
      _PrescriptionWriteWidgetForReviewState();
}

class _PrescriptionWriteWidgetForReviewState
    extends State<PrescriptionWriteWidgetForReview> {
  final _formKey_ = GlobalKey<FormState>();
  String choice;
  int mealTime = 0;
  String diseases = "no datas";
  bool morning = false;
  bool noon = true;
  bool evening = false;
  bool checkedValue = false;
  String dr_id = UID;
  String patient_id;

  @override
  void initState() {
    // showThisToast("patient id "+ widget.prescriptionreqModel["patient_info"]["id"].toString());
    setState(() {
      patient_id = widget.prescriptionreqModel["patient_info"]["id"].toString();
      medicineList = [];
      noon = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Prescription - Review",
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey_.currentState.validate()) {
                    setState(() {});

                    final http.Response response = await http.post(
                      _baseUrl + 'reply-prescription-recheck-request',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': AUTH_KEY,
                      },
                      body: jsonEncode(<String, String>{
                        'patient_id': patient_id,
                        'dr_id': UID,
                        'diseases_name': diseases,
                        'medicine_info': jsonEncode(medicineList),
                        'recheck_id': widget.prescriptionreqModel["id"].toString(),
                        'dr_name': UNAME,
                        'dr_comment': "written in prescription",
                        'need_of_prescription': "1",
                        'service_id': "1",
                      }),
                    );

                    showThisToast(response.body.toString());
                    print((jsonDecode(response.body))["message"]);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    if (response.statusCode == 200) {
                      mainD();
                    } else {
                      showThisToast("Error occured");
                    }
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey_,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  diseases = value;
                  if (value.isEmpty) {
                    return 'Please write detected diseases';
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
                    labelText: "Write The Diagnosed Diseases"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: medicineList == null ? 0 : medicineList.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                  onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AmbulanceBodyWidget(
//                            projectSnap.data[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        trailing: Icon(Icons.delete),
                        leading: Icon(Icons.note_add),
                        title: new Text(
                          medicineList[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            medicineList[index]["morning"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Morning"),
                                  )
                                : Text(""),
                            medicineList[index]["noon"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Noon"),
                                  )
                                : Text(""),
                            medicineList[index]["evening"] == 1
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(00, 0, 10, 0),
                                    child: Text("Evening"),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle_outline),
        label: Text("Add Medicine"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMedicineWidget(
                        function: (data) {
                          // showThisToast("im hit hit hit");
                          setState(() {
                            data["id"] =
                                widget.prescriptionreqModel["id"].toString();
                            medicineList.add(data);
                          });
                        },
                      )));

//          return showDialog<void>(
//            context: context,
//            barrierDismissible: false, // user must tap button!
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text('Add Medicine'),
//                content: SingleChildScrollView(
//                  child: ListBody(
//                    children: <Widget>[
//                      Text(morning.toString()),
//                      Form(
//                        key: _formKey,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Widgets.textFormField(
//                              darkBackground: false,
//                              labelText: 'Medicine Name',
//                              inputType: TextInputType.emailAddress,
//                              validator: (value) {
//                                medName = value;
//                                if (value.isEmpty) {
//                                  return 'Please enter Medicine Name';
//                                }
//                                return null;
//                              },
//                            ),
//                            Checkbox(
//                              value: morning,
//                              onChanged: (bool val){
//                                this. setState(() {
//                                  morning = val;
//                                });
//                              },
//                            ),
//                            CheckboxListTile(
//                              title: Text("Morning 1"),
//                              value: morning,
//                              onChanged: (bool newValue)  {
//                                showThisToast(newValue.toString());
//                                morning = false;
//                               this. setState(() {
//                                  morning = false;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//                            CheckboxListTile(
//                              title: Text("Noon"),
//                              value: noon,
//                              onChanged: (bool newValue)  {
//                                this. setState(() {
//                                  noon = newValue;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//
//                            CheckboxListTile(
//                              title: Text("Evening"),
//                              value: evening,
//                              onChanged: (bool newValue)  {
//                                this. setState(() {
//                                  evening = newValue;
//                                });
//
//                              },
//                              controlAffinity: ListTileControlAffinity
//                                  .leading, //  <-- leading Checkbox
//                            ),
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text('Cancel'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                  FlatButton(
//                    child: Text('Add'),
//                    onPressed: () {
//                      if (_formKey.currentState.validate()) {
//                        setState(() {
//                          final Map<String, dynamic> data =
//                              new Map<String, dynamic>();
//                          data['name'] = medName;
//                          medicineList.add(data);
//                        });
//
//                        Navigator.of(context).pop();
//                      }
//                    },
//                  ),
//                ],
//              );
//            },
//          );
        },
      ),
    );
  }
}
//

class PrescriptionsReviewWidget extends StatefulWidget {
  @override
  _PrescriptionsReviewWidgetState createState() =>
      _PrescriptionsReviewWidgetState();
}

class _PrescriptionsReviewWidgetState extends State<PrescriptionsReviewWidget> {
  List prescriptionReviewList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'doctor'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
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
      appBar: AppBar(
        title: Text("Prescription Review List"),
      ),
      body: (prescriptionReviewList != null &&
              prescriptionReviewList.length > 0)
          ? new ListView.builder(
              itemCount: prescriptionReviewList == null
                  ? 0
                  : prescriptionReviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      if (prescriptionReviewList[index]["is_reviewed"] == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrescriptionsodyWidget(
                                    prescriptionReviewList[index])));
                      }
                    },
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
                            (prescriptionReviewList[index]["dr_info"] == null
                                ? "No Doctor Name"
                                : prescriptionReviewList[index]["dr_info"]
                                    ["name"]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            prescriptionReviewList[index]["is_reviewed"] == 1
                                ? "Review Done"
                                : "Review Pending",
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
                child: Text("No Prescription Review History"),
              )),
    );
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
