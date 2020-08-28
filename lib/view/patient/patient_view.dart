import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:appxplorebd/view/patient/sharedData.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
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
import 'SubscriptionsActivityPatient.dart';
import 'departments_for_chamber_doc.dart';
import 'departments_for_online_doc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'myMapViewActivity.dart';
import 'myYoutubePlayer.dart';

var OWN_PHOTO;
String AUTH_KEY;
String A_KEY;
String UPHOTO;
String UEMAIL;
String UID;
String UNAME;
String UPHONE;
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
final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";
final String _baseUrl_image = "http://telemedicine.drshahidulislam.com/";
var header;

GlobalKey _bottomNavigationKey = GlobalKey();
Color tColor = Color(0xFF34448c);
SharedPreferences prefs;

void mainP() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await _prefs;
  AUTH_KEY = prefs.getString("auth");
  A_KEY = prefs.getString("auth");
  UID = prefs.getString("uid");
  UNAME = prefs.getString("uname");
  UPHOTO = prefs.getString("uphoto");
  UEMAIL = prefs.getString("uemail");
  UPHONE = prefs.getString("uphone");
  header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': AUTH_KEY,
  };
  // = prefs.getString("auth");
  runApp(PatientAPP());
}

class PatientAPP extends StatelessWidget {
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomSelectedIndex = 0;
  int _page = 0;
  List _titles = ["Home", "Notifications", "Profile", "Appointments", "Blog"];
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
            Icons.book,
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
        Appointment(),
        BlogActivityWithState(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
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
      //   showThisToast("backpressed");

      return Future.value(false);
    }

    return AppWidget();
  }

  Widget AppWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[bottomSelectedIndex]),
        backgroundColor: Color(0xFF34448c),
        elevation: 0.0,
      ),
      drawer: myDrawer(),
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
            Icons.verified_user,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_today,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.library_books,
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
  // After 1 second, it takes you to the bottom of the ListView
  // After 1 second, it takes you to the bottom of the ListView
  // After 1 second, it takes you to the bottom of the ListView
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // After 1 second, it takes you to the bottom of the ListView
    int total = 3;
    int current = 0;

    Timer.periodic(new Duration(seconds: 5), (timer) {
      debugPrint(timer.tick.toString());
      double total_width = _controller.position.maxScrollExtent + 320;
      double one_width = total_width / 4;
      _controller.animateTo(
        one_width * current,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );
      current++;
      if (current > total) {
        current = 0;
      }
    });
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          height: 130,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 50,
                child: Container(
                  color: Color(0xFF34448c),
                ),
              ),
              Positioned(
                top: 00,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 130,
                      child: ListView(
                        controller: _controller,
                        shrinkWrap: true,

                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/banner5.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 100,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/banner2.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 100,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/banner3.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 100,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/banner4.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 100,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GridView.count(
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
                        builder: (context) => DeptListOnlineDocWidget(context),
                      ));
                },
                child: Card(
                  margin: EdgeInsets.all(0.5),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
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
                            "Online Doctor",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeptChamberDocWidget(context)));
                },
                child: Container(
                  height: 110,
                  child: Card(
                    margin: EdgeInsets.all(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    color: Colors.white,
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
                              "Chamber Doctor",
                              style: TextStyle(color: Color(0xFF34448c)),
                            ))
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionViewPatient(AUTH_KEY,UID)));
                },
                child: Card(
                  margin: EdgeInsets.all(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  color: Colors.white,
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
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatListActivity()));
                },
                child: Card(
                  margin: EdgeInsets.all(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  color: Colors.white,
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
                            "Chat",
                            style: TextStyle(color: Color(0xFF34448c)),
                          ))
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AmbulanceWidget()));
                },
                child: Container(
                  height: 110,
                  child: Card(
                    margin: EdgeInsets.all(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 48,
                          width: 48,
                          child: Image.asset(
                            "assets/ambulance.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              "Ambulance",
                              style: TextStyle(color: Color(0xFF34448c)),
                            ))
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => HomeVisitsDoctorsList()));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeVisitViewPagerWid()));
                },
                child: Container(
                  height: 110,
                  child: Card(
                    margin: EdgeInsets.all(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 48,
                          width: 48,
                          child: Image.asset(
                            "assets/help.png",
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
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => HomeVisitsDoctorsList()));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoAppointmentListActivityPatient(A_KEY, UID)));
                },
                child: Container(
                  height: 110,
                  child: Card(
                    margin: EdgeInsets.all(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 48,
                          width: 48,
                          child: Image.asset(
                            "assets/help.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              "Online Appointment",
                              style: TextStyle(color: Color(0xFF34448c)),
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ],
    ));
  }
}

class HomeVisitsDoctorsList extends StatefulWidget {
  @override
  _HomeVisitsDoctorsListState createState() => _HomeVisitsDoctorsListState();
}

class _HomeVisitsDoctorsListState extends State<HomeVisitsDoctorsList> {
  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" +
          'home_visits_doctor_search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
    );

    this.setState(() {
      data = json.decode(response.body);
      ALL_HOME_DOC_LIST = data;
    });

    print(data);
    print("home doc size " + (data.length).toString());

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (data != null && data.length > 0)
          ? new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  onTap: () {
                    //   showThisToast(data[index].toString());
                    // print(data[index].toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeVisitDoctorDetailPage(data[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(00.0),
                    ),
                    child: ListTile(
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                        child: new Text(
                          data[index]["designation_title"] == null
                              ? ("General Practician")
                              : data[index]["designation_title"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                        child: new Text(
                          data[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "http://telemedicine.drshahidulislam.com/" +
                                data[index]["photo"]),
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

class HomeVisitDoctorDetailPage extends StatefulWidget {
  dynamic data;

  HomeVisitDoctorDetailPage(this.data);

  @override
  _HomeVisitDoctorDetailPageState createState() =>
      _HomeVisitDoctorDetailPageState();
}

class _HomeVisitDoctorDetailPageState extends State<HomeVisitDoctorDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String problems, homeAddress, date, phone;
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Home Visit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "http://telemedicine.drshahidulislam.com/" +
                        widget.data["photo"]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
              child: Text(
                widget.data["name"],
                style: TextStyle(fontSize: 18, color: tColor),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 3, 20, 2),
                child: Text(
                  widget.data["designation_title"] == null
                      ? ("General Practician")
                      : widget.data["designation_title"],
                )),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        problems = value;
                        if (value.isEmpty) {
                          return 'Please write your problems';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Problems"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        homeAddress = value;
                        if (value.isEmpty) {
                          return 'Please enter home address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Home Address"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        date = value;
                        if (value.isEmpty) {
                          return 'Please enter Date';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Date"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        phone = value;
                        if (value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Contact Number"),
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
                          color: Color(0xFF34448c),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              setState(() {
                                StandbyWid = Text("Please wait",
                                    style: TextStyle(color: Colors.white));
                              });
                              //add_home_appointment_info

                              final http.Response response = await http.post(
                                _baseUrl + 'add_home_appointment_info',
                                headers: header,
                                body: jsonEncode(<String, String>{
                                  'patient_id': UID,
                                  'dr_id': widget.data["id"].toString(),
                                  'problems': problems,
                                  'phone': phone,
                                  'date': date,
                                  'home_address': homeAddress
                                }),
                              );
                              setState(() {
                                myMessage = response.body;
                              });
                              if (response.statusCode == 200) {
                                setState(() {
                                  StandbyWid = Text("Submit Success",
                                      style: TextStyle(color: Colors.white));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                              } else {
                                setState(() {
                                  StandbyWid = Text(response.body,
                                      style: TextStyle(color: Colors.white));
                                  // Navigator.of(context).pop();
                                  //Navigator.of(context).pop();
                                });
                              }
                            }
                          },
                          child: StandbyWid,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    borderRadius:
        BorderRadius.all(Radius.circular(5.0) //         <--- border radius here
            ),
    border: Border.all(
      color: Colors.blue,
    ),
  );
}

class AddDiseasesActivity extends StatefulWidget {
  Function function;

  //ChooseDeptActivity(this.deptList__, this.function);
  AddDiseasesActivity({Key key, this.function}) : super(key: key);

//  final Map<String, dynamic> data =
//  new Map<String, dynamic>();
//  data['id'] = widget.deptList__[index]["id"].toString();
//  data['name'] =
//  widget.deptList__[index]["name"].toString();
//  widget.function(data);
//  Navigator.of(context).pop(true);
  @override
  _AddDiseasesActivityState createState() => _AddDiseasesActivityState();
}

class _AddDiseasesActivityState extends State<AddDiseasesActivity> {
  final _formKey = GlobalKey<FormState>();
  String diseaesName, currentStatus, firstNoticeDate;
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime.now().toIso8601String();
  String dateToUpdate = (DateTime.now().year).toString() +
      "-" +
      (DateTime.now().month).toString() +
      "-" +
      (DateTime.now().day).toString();

  //String dateToUpdate = "Choose First Notice Date";
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

  @override
  Widget build(BuildContext context) {
    // errr
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Diseases"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  diseaesName = value;
                  if (value.isEmpty) {
                    return 'Please enter Diseases Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Diseases Name"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Text("First notice date"),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Container(
                decoration: myBoxDecoration(),
                child: ListTile(
                  onTap: () {
                    _selectDate(context);
                  },
                  trailing: Icon(Icons.arrow_downward),
                  title: Text(dateToUpdate),
                  subtitle: Text("First Notice Date"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  currentStatus = value;
                  if (value.isEmpty) {
                    return 'Please enter current status';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Current status"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ),
    );
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DiseasesWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Disease History"),
            subtitle: Text("Add/View your diseases history"),
            leading: Icon(Icons.supervised_user_circle),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrescriptionsWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Prescriptions"),
            subtitle: Text("Add/View your prescriptions"),
            leading: Icon(Icons.supervised_user_circle),
          ),
          Divider(),
          ListTile(
            //
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrescriptionsReviewWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Prescription Review"),
            subtitle: Text("View your prescription request and responses"),
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
                                  "http://telemedicine.drshahidulislam.com/" +
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
                                    backgroundImage: (projectSnap.data[index]
                                                ["dr_info"] !=
                                            null)
                                        ? NetworkImage(
                                            _baseUrl_image +
                                                projectSnap.data[index]
                                                    ["dr_info"]["photo"],
                                          )
                                        : (NetworkImage(
                                            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"))),
                                title: new Text(
                                  (projectSnap.data[index]["dr_info"] != null)
                                      ? projectSnap.data[index]["dr_info"]
                                          ["name"]
                                      : ("No Doctor Name"),
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
  // showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "1"}),
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
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "0"}),
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

Future<dynamic> fetchNotices() async {
  // showThisToast("going to fetch noticies list");
  final http.Response response = await http.post(
    _baseUrl + 'getMyNotices',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(<String, String>{'user_id': USER_ID}),
  );

  if (response.statusCode == 200) {
    List noti = json.decode(response.body);
    // showThisToast("noti sixe " + noti.length.toString());
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
    // showThisToast("noti sixe " + noti.length.toString());
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

Widget myDrawer() {
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
                          NetworkImage(_baseUrl_image + USER_PHOTO),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                    child: new Center(
                      child: Text(
                        USER_NAME,
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
          leading: Icon(Icons.description),
          title: Text('Logout'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            setLoginStatus(false);
            runApp(LoginUI());
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Online Doctor'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.facebook.com";

            // launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Chamber Doctor'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.youtube.com";

            // launch(url);
            //Share.share("https://www.youtube.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Subscriptions'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Chat'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Ambulance'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Blood Bank'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Pharmacey'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Hospitals'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Guidline'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
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
      body: DeptListOnlineDocWidget(context),
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
  String user_picture = UPHOTO;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //this one is ok
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
              showThisToast(AUTH_KEY + "/n" + UID);

              var response = await request.send();

              print(response.statusCode);
              showThisToast(response.statusCode.toString());

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
                                USER_NAME = newName;
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
                      child: Text("Phone Name"),
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
                      initialValue: USER_NAME,
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
                      prefs.setString("uname", newName);
                      Navigator.of(context).pop();
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

  // showThisToast("user id " + UID);

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
            //   showThisToast("chat histoory siz " + (lists.length).toString());
            return lists.length > 0
                ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          String own_id = UID;
                          String own_name = USER_NAME;
                          OWN_PHOTO = USER_PHOTO;
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
                          //   showThisToast("chat room " + CHAT_ROOM);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      UID,
                                      UNAME,
                                      UPHOTO,
                                      partner_id,
                                      partner_name,
                                      parner_photo,
                                      chatRoom)));
                        },
                        child: Card(
                            child: (UID ==
                                    ((lists[index]["sender_id"])
                                        .toString())) //im this ms sender
                                ? ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      "http://telemedicine.drshahidulislam.com/" +
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
                                      "http://telemedicine.drshahidulislam.com/" +
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
          // error

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDiseasesActivity(function: (data) {
                        //  showThisToast("im hit hit hit wioth "+data);
                        setState(() {});
                      })));
/*
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
                        var status = addDiseasesHistory(
                            diseaesName, dateToUpdate, currentStatus);

                        status.then((value) => this.closeAndUpdate(context));
                      }
                    },
                  ),
                ],
              );
            },
          );
          */
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
      body: jsonEncode(<String, String>{'id': USER_ID, 'user_type': 'patient'}),
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
                      List attachment = prescriptionList[index]["attachment"];
                      if (attachment != null && attachment.length > 0) {
                        //  showThisToast("analog");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrescriptionsodyWidget(
                                    prescriptionList[index])));
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
                                              title: Text("Doctor Comment"),
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
                                          medicinesListOfAPrescriptionWidget(
                                              prescriptionList[index]),
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
                          request.headers.addAll(header);
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

Widget medicinesListOfAPrescriptionWidget(medicineList) {
  return medicineList != null
      ? ListView.builder(
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
                        leading: Icon(Icons.accessible_forward),
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

class PrescriptionsodyWidget extends StatefulWidget {
  dynamic prescriptionBody;

  PrescriptionsodyWidget(this.prescriptionBody);

  @override
  _PrescriptionsBodyWidgetState createState() =>
      _PrescriptionsBodyWidgetState();
}

class _PrescriptionsBodyWidgetState extends State<PrescriptionsodyWidget> {
  List prescriptionList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-prescription-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': USER_ID, 'user_type': 'patient'}),
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
        title: Text("Prescription Body"),
      ),
      body: (widget.prescriptionBody["attachment"] != null
          ? Image.network(
              _baseUrl_image + widget.prescriptionBody["attachment"][0]["file"])
          : Text("Digital Prescription")),
    );
  }
}

Widget PrescriptionsRevieBodyWidget(dynamic reviewRequest) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Review Request"),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: <Widget>[
                  Text("Old Prescription"),
                  ListTile(
                    title: Text("Doctors Comment"),
                    subtitle: Text(""),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PrescriptionsReviedBodyState extends StatefulWidget {
  dynamic prescriptionReview;

  PrescriptionsReviedBodyState(this.prescriptionReview);

  @override
  _PrescriptionsReviedBodyState createState() =>
      _PrescriptionsReviedBodyState();
}

class _PrescriptionsReviedBodyState
    extends State<PrescriptionsReviedBodyState> {
  List prescriptionReviewList = [];
  dynamic singlePrescription;
  dynamic newPrescription;

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': USER_ID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      //showThisToast(prescriptionReviewList.toString());
    });
    return "Success!";
  }

  Future<String> getSinglePrescription() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["old_prescription_id"].toString(),
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      singlePrescription = json.decode(response.body);

      print(singlePrescription);
    });
    return "Success!";
  }

  Future<String> getNewPrescription() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["new_prescription_id"].toString(),
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      newPrescription = json.decode(response.body);
      showThisToast(
          "length " + newPrescription["medicine_info"].length.toString());

      print(newPrescription);
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
    print("review page api hit starts");
    print("orescription id " +
        widget.prescriptionReview["old_prescription_id"].toString());

    this.getData();
    this.getSinglePrescription();
    this.getNewPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Review Request"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Card(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: Text(
                            "New Prescription",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                        child: ListTile(
                          title: Text("Doctors Comment"),
                          subtitle: Text(newPrescription != null
                              ? newPrescription["diseases_name"]
                              : "Loading"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Text("Medicines"),
                      ),
                      medicinesListOfAPrescriptionWidget(newPrescription)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Card(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: Text(
                            "Old Prescription",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                        child: ListTile(
                          title: Text("Doctors Comment"),
                          subtitle: Text(singlePrescription != null
                              ? singlePrescription["diseases_name"]
                              : "Loading"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Text("Medicines"),
                      ),
                      medicinesListOfAPrescriptionWidget(singlePrescription)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

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
      body: jsonEncode(<String, String>{'id': USER_ID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      // showThisToast(prescriptionReviewList.toString());
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
        title: Text("All Review Request"),
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
                      print(prescriptionReviewList[index]);
                      if (prescriptionReviewList[index]["is_reviewed"] == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PrescriptionsReviedBodyState(
                                        prescriptionReviewList[index])));
                      } else
                        showThisToast("Not Reviewed Yet");
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
                                prescriptionReviewList[index]["dr_info"]
                                    ["photo"]),
                          ),
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

class HomeVisitViewPagerWid extends StatefulWidget {
  @override
  _HomeVisitViewPagerWidState createState() => _HomeVisitViewPagerWidState();
}

class _HomeVisitViewPagerWidState extends State<HomeVisitViewPagerWid> {
  double latitude;

  double longitude;

  String address;

  int selected = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget buildPageView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 60,
          child: HomeVisitsDoctorsList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: Colors.white,
              height: 60,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (latitude != null)
                        ? Text("Current location")
                        : Text("Getting your location"),
                    FlatButton(
                      onPressed: () async {
                        Prediction prediction = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0",
                            mode: Mode.overlay,
                            // Mode.overlay
                            language: "en",
                            components: [Component(Component.country, "bd")]);
                        //    showThisToast((prediction.description).toString());
                        GoogleMapsPlaces _places = new GoogleMapsPlaces(
                            apiKey:
                                "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0"); //Same API_KEY as above
                        PlacesDetailsResponse detail = await _places
                            .getDetailsByPlaceId(prediction.placeId);

                        // double latitude = detail.result.geometry.location.lat;
                        // double longitude = detail.result.geometry.location.lng;
                        String address = prediction.description;

                        setState(() {
                          latitude = detail.result.geometry.location.lat;
                          longitude = detail.result.geometry.location.lng;
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 00, 0),
                          child: Text("Change Location",
                              style: TextStyle(
                                  color: tColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))),
                    )
                  ],
                ),
              )),
        ),
        Positioned(
          right: 00,
          bottom: 60,
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: InkWell(
                  onTap: () {
                    final Geolocator geolocator = Geolocator()
                      ..forceAndroidLocationManager;

                    geolocator
                        .getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best)
                        .then((Position position) {
                      List<LatLng> _sharedMarkerLocations = [];
                      for (int i = 0; i < ALL_HOME_DOC_LIST.length; i++) {
                        _sharedMarkerLocations.add(new LatLng(
                            double.parse(
                                (ALL_HOME_DOC_LIST[i]["home_lat"].toString())),
                            double.parse((ALL_HOME_DOC_LIST[i]["home_log"]
                                .toString()))));
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePageMapCl(
                                _sharedMarkerLocations,
                                new LatLng(
                                    position.latitude, position.longitude)),
                          ));
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Card(
                      color: tColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              Text("View on Map",
                                  style: TextStyle(color: Colors.white))
                            ],
                          ))))),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Doctor"),
      ),
      body: buildPageView(context),
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
