import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:appxplorebd/chat/model/chat_message.dart';
import 'package:appxplorebd/myCalling/call.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:appxplorebd/view/patient/sharedData.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import 'OnlineDoctorFullProfileView.dart';
import 'OnlineDoctorsList.dart';
import 'SubscriptionsActivityPatient.dart';
import 'departments_for_chamber_doc.dart';
import 'departments_for_online_doc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'myMapViewActivity.dart';
import 'myYoutubePlayer.dart';

int lastApiHitted1 = 0;
int lastApiHitted2 = 0;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("_backgroundMessageHandler");
  print("nadia");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: ${data}");
  }
}

BuildContext useThisContext;
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
final String _baseUrl = "https://appointmentbd.com/api/";
final String _baseUrl_image = "https://appointmentbd.com/";
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
  UID_FOR_CHAT = UID;

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
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'SF Pro Display Regular',
            primaryColor: Colors.orange,
            accentColor: Colors.orangeAccent),
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

PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
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

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
        //showThisToast("changed now to " + index.toString());
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

  loadSession() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.subscribeToTopic(prefs.getString("uid"));
    setState(() {
      AUTH_KEY = prefs.getString("auth");
      A_KEY = prefs.getString("auth");
      UID = prefs.getString("uid");
      UNAME = prefs.getString("uname");
      UPHOTO = prefs.getString("uphoto");
      UEMAIL = prefs.getString("uemail");
      UPHONE = prefs.getString("uphone");
      UID_FOR_CHAT = UID;
    });
  }

  onBackPress() {
    Navigator.pop(this.context, false);
  }

  @override
  void initState() {
    super.initState();
    this.loadSession();

    bool isCallShowing = false;

    // initPlatformState();
    final databaseReference = FirebaseDatabase.instance.reference();
    // databaseReference.child("hasCall").onChildChanged..then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    //   showThisToast('Data : ${snapshot.value}');
    // });
    // databaseReference.child("hasCall").onValue.listen((event) {
    //   print(event.snapshot.value.toString());
    //   //showThisToast(event.snapshot.value.toString());
    //   showThisToast(event.snapshot.value.toString());
    //   Navigator.push(
    //       useThisContext,
    //       MaterialPageRoute(
    //           builder: (context) => IncomingCallActivity(null)));
    // });

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,

      onLaunch: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("on launch " + message.toString());
        if (message["data"]["type"] == "incomming_call" &&
            isCallingEngagged == false) {
          isCallingEngagged = true;
          // isCallShowing = true ;
          Navigator.push(
              useThisContext,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else {
          // showThisToast("unknown type");
        }
      },

      onResume: (Map<String, dynamic> message) async {
        print("on resume " + message.toString());
        if (message["data"]["type"] == "incomming_call" &&
            isCallingEngagged == false) {
          isCallingEngagged = true;
          // isCallShowing = true ;
          Navigator.push(
              useThisContext,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else {
          // showThisToast("unknown type");
        }
      },

      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        // _navigateToItemDetail(message);
        //  this.displayIncomingCall();
        print("on message " + message.toString());

        //showThisToast(message["data"]["room"]);

        if (message["data"]["type"] == "incomming_call" &&
            isCallingEngagged == false) {
          isCallingEngagged = true;
          // isCallShowing = true ;
          Navigator.push(
              useThisContext,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else {
          // showThisToast("unknown type");
        }
        /*
        if (message["data"]["type"] == "reject_call" && isCallShowing ==true ) {
          //this.onBackPress();
          //mainP();
          isCallShowing = false ;
          isCallingEngagged = false ;
          showThisToast("Call is terminated by the caller");
        }

         */
        if (message["data"]["type"] == "end_call" &&
            isCallingEngagged == true) {
          //this.onBackPress();
          //mainP();
          isCallShowing = false;
          isCallingEngagged = false;
          showThisToast("Call is finished");
        }
        if (message["data"]["type"] == "cancel_call" &&
            isCallingEngagged == true) {
          this.onBackPress();
          //mainP();
          isCallShowing = false;
          isCallingEngagged = false;
          showThisToast("Call is canceled");
        }
      },
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await Callkeep.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void pageChanged(int index) {
    //CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
    //navBarState.setPage(index);
    setState(() {
      bottomSelectedIndex = index;
      _page = index;
    });
    showThisToast("changed to " + index.toString());
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    useThisContext = context;
    Future<bool> _onWillpop() {
      Navigator.of(context).pop(true);
      //   showThisToast("backpressed");

      return Future.value(false);
    }

    return AppWidget();
  }

  int mainAppWidCount = 0;

  Widget AppWidget() {
    mainAppWidCount++;
    //  showThisToast("start app "+mainAppWidCount.toString()+" th time");

    return Scaffold(
        appBar: AppBar(
          title: Text(
            _titles[bottomSelectedIndex],
            style: TextStyle(color: Colors.orange),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        drawer: myDrawer(),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          onTap: bottomTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: bottomSelectedIndex == 0 ? Colors.orange : Colors.grey,
                ),
                title: new Text(
                  'Home',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.notification_important,
                color: bottomSelectedIndex == 1 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Notification',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: bottomSelectedIndex == 2 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.calendar_today,
                color: bottomSelectedIndex == 3 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Appointment',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  color: bottomSelectedIndex == 4 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ));
  }
}

class IncomingCallActivity extends StatefulWidget {
  dynamic data;

  IncomingCallActivity(this.data);

  @override
  _IncomingCallActivityState createState() => _IncomingCallActivityState();
}

class _IncomingCallActivityState extends State<IncomingCallActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incomming Call"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              widget.data["doc_name"],
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: CircleAvatar(
              radius: 100,
              backgroundImage:
                  NetworkImage(_baseUrl_image + widget.data["doc_photo"]),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Card(
                child: ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                    String chatRoom = createChatRoomName(int.parse(UID),
                        int.parse(widget.data["doc_id"].toString()));
                    CHAT_ROOM = widget.data["room"];
                    ClientRole _role = ClientRole.Broadcaster;
                    // await for camera and mic permissions before pushing video page
                    await _handleCameraAndMic();
                    // push video page with given channel name
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallPage(
                          channelName: widget.data["room"],
                          role: _role,
                          isCameraOn: true,
                          UID: UID,
                          isCaller: false,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.done),
                  title: Text("Attend Call"),
                ),
              )),
              Expanded(
                  child: Card(
                child: ListTile(
                  onTap: () async {
                    http.Response response = await http.post(
                      'https://fcm.googleapis.com/fcm/send',
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                        'Authorization':
                            'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw',
                        // Constant string
                      },
                      body: jsonEncode(
                        <String, dynamic>{
                          'notification': <String, dynamic>{},
                          'priority': 'high',
                          'data': <String, dynamic>{
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            // 'doc_id': widget.UID,
                            // 'doc_name': widget.ownName,
                            // 'doc_photo': widget.partnerPhoto,
                            'type': 'reject_call',
                            //'room': widget.channelName
                          },
                          'to': "/topics/" + widget.data["doc_id"].toString()
                        },
                      ),
                    );
                    // showThisToast(response.statusCode.toString());
                    isCallingEngagged = false;
                    Navigator.of(context).pop();

                    mainP();
                  },
                  leading: Icon(Icons.close),
                  title: Text("Reject Call"),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}

Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
}

class Home extends StatefulWidget {
  List deptList = [];
  List videoAppList = [];

  @override
  _HomeState createState() => _HomeState();
}

bool _enabled = true;
int apiHitCount = 0;

class _HomeState extends State<Home> {
  getData() async {
    if (true) {
      if (lastApiHitted1 + 3000 < DateTime.now().millisecondsSinceEpoch) {
        final http.Response response = await http.post(
          "https://appointmentbd.com/api/" + 'department-list',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': AUTH_KEY,
          },
        );
        isLoading = false;
        setState(() {
          lastApiHitted1 = DateTime.now().millisecondsSinceEpoch;
          widget.deptList = json.decode(response.body);
          widget.deptList = widget.deptList.sublist(0, 4);
        });
      }
    }
    // data_ = json.decode(response.body);

    // showThisToast("dept size "+response.body);
  }

  getVdoAppData() async {
    if (true) {
      if (lastApiHitted1 + 3000 < DateTime.now().millisecondsSinceEpoch) {
        body = <String, String>{
          'user_type': "patient",
          'isFollowup': "0",
          'id': UID
        };
        String apiResponse =
            await makePostReq("get_video_appointment_list", AUTH_KEY, body);
        this.setState(() {
          widget.videoAppList = json.decode(apiResponse);
          // showThisToast("this time video app size "+widget.videoAppList.length.toString());
          lastApiHitted2 = DateTime.now().millisecondsSinceEpoch;
        });
      }
    }
  }

  // After 1 second, it takes you to the bottom of the ListView
  // After 1 second, it takes you to the bottom of the ListView
  // After 1 second, it takes you to the bottom of the ListView
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 60;
    var _aspectRatio = _width / cellHeight;
    return SingleChildScrollView(
        child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorSearchActivity(),
                    ));
              },
              leading: Icon(Icons.search),
              title: Text("Search Doctor,Medicine or Pharmacy"),
            ),
          ),
        ),

        Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: ListTile(
                title: Text("Get Urgent Care"),
                leading: Icon(
                  Icons.work,
                  color: Colors.orange,
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: Colors.orange,
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    ),
                  ]),
            )),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                  title: Text("Consult a Physician"),
                  leading: Icon(
                    Icons.work,
                    color: Colors.orange,
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeptListOnlineDocWidget(),
                          ));
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(color: Colors.orange),
                    ),
                  )),
              FutureBuilder(
                  future: getData(),
                  builder: (context, projectSnap) {
                    return new GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _crossAxisCount,
                          childAspectRatio: _aspectRatio),
                      shrinkWrap: true,
                      itemCount:
                          widget.deptList == null ? 0 : widget.deptList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseDoctorOnline(
                                                (widget.deptList[index]["id"])
                                                    .toString())));
                              },
                              child: Container(
                                height: 50,
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: new Text(
                                    widget.deptList[index]["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListTile(
            title: Text("Appointments"),
            leading: Icon(
              Icons.calendar_today,
              color: Colors.orange,
            ),
            trailing: Text(
              "See All",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
        FutureBuilder(
            future: getVdoAppData(),
            builder: (context, projectSnap) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: widget.videoAppList == null
                    ? 0
                    : widget.videoAppList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    onTap: () {
                      String chatRoom = createChatRoomName(int.parse(UID),
                          widget.videoAppList[index]["dr_info"]["id"]);
                      CHAT_ROOM = chatRoom;
                      showThisToast(chatRoom);
                      // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  widget.videoAppList[index]["dr_info"]["id"]
                                      .toString(),
                                  widget.videoAppList[index]["dr_info"]["name"],
                                  _baseUrl_image +
                                      widget.videoAppList[index]["dr_info"]
                                          ["photo"],
                                  UID,
                                  UNAME,
                                  UPHOTO,
                                  chatRoom)));
                    },
                    // child: Card(
                    //   elevation: 3,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //   ),
                    //   child: Padding(
                    //     padding: EdgeInsets.all(0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Padding(
                    //           padding: EdgeInsets.all(15),
                    //           child: Text(
                    //               widget.videoAppList[index]["created_at"]),
                    //         ),
                    //         Divider(
                    //           color: Colors.grey,
                    //           height: 1,
                    //         ),
                    //         ListTile(
                    //           leading: CircleAvatar(
                    //             backgroundImage: NetworkImage(_baseUrl_image +
                    //                 widget.videoAppList[index]["dr_info"]
                    //                     ["photo"]),
                    //           ),
                    //           title: Text(widget.videoAppList[index]["dr_info"]
                    //               ["name"]),
                    //           subtitle: Text(
                    //             "Send a Message",
                    //             style: TextStyle(color: Colors.blue),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                  widget.videoAppList[index]["created_at"]),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_baseUrl_image +
                                    widget.videoAppList[index]["dr_info"]
                                        ["photo"]),
                              ),
                              title: Text(widget.videoAppList[index]["dr_info"]
                                  ["name"]),
                              subtitle: Text(
                                "Send a Message",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              );
            }),

//         GridView.count(
//           shrinkWrap: true,
//           primary: false,
//           padding: const EdgeInsets.all(5),
//           crossAxisSpacing: 1,
//           mainAxisSpacing: 1,
//           crossAxisCount: 3,
//           children: <Widget>[
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DeptListOnlineDocWidget(),
//                       ));
//                 },
//                 child: Card(
//                   margin: EdgeInsets.all(0.5),
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0.0),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         height: 48,
//                         width: 48,
//                         child: Image.asset(
//                           "assets/doctor.png",
//                         ),
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                           child: Text(
//                             "Online Doctor",
//                             style: TextStyle(color: Color(0xFF34448c)),
//                           ))
//                     ],
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => DeptChamberDocWidget(context)));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           child: Image.asset(
//                             "assets/doctor_chamber.png",
//                             height: 48,
//                             width: 48,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                             child: Text(
//                               "Chamber Doctor",
//                               style: TextStyle(color: Color(0xFF34448c)),
//                             ))
//                       ],
//                     ),
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               SubscriptionViewPatient(AUTH_KEY, UID)));
//                 },
//                 child: Card(
//                   margin: EdgeInsets.all(0.5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0.0),
//                   ),
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         height: 48,
//                         width: 48,
//                         child: Image.asset(
//                           "assets/subscription.png",
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                           child: Text(
//                             "Subscriptions",
//                             style: TextStyle(color: Color(0xFF34448c)),
//                           ))
//                     ],
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ChatListActivity()));
//                 },
//                 child: Card(
//                   margin: EdgeInsets.all(0.5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0.0),
//                   ),
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         height: 48,
//                         width: 48,
//                         child: Image.asset(
//                           "assets/live_chat.png",
//                         ),
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                           child: Text(
//                             "Chat",
//                             style: TextStyle(color: Color(0xFF34448c)),
//                           ))
//                     ],
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AmbulanceWidget()));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 48,
//                           width: 48,
//                           child: Image.asset(
//                             "assets/ambulance.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                             child: Text(
//                               "Ambulance",
//                               style: TextStyle(color: Color(0xFF34448c)),
//                             ))
//                       ],
//                     ),
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
// //                  Navigator.push(
// //                      context,
// //                      MaterialPageRoute(
// //                          builder: (context) => HomeVisitsDoctorsList()));
//
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => HomeVisitViewPagerWid()));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 48,
//                           width: 48,
//                           child: Image.asset(
//                             "assets/window.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               child: Text(
//                                 "Home Visits",
//                                 style: TextStyle(
//                                   color: Color(0xFF34448c),
//                                 ),
//                                 textAlign: TextAlign.center,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
// //                  Navigator.push(
// //                      context,
// //                      MaterialPageRoute(
// //                          builder: (context) => HomeVisitsDoctorsList()));
//
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               VideoAppointmentListActivityPatient(A_KEY, UID)));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 48,
//                           width: 48,
//                           child: Image.asset(
//                             "assets/video_call_img.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               child: Text(
//                                 "Online Appointment",
//                                 style: TextStyle(
//                                   color: Color(0xFF34448c),
//                                 ),
//                                 textAlign: TextAlign.center,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
// //                  Navigator.push(
// //                      context,
// //                      MaterialPageRoute(
// //                          builder: (context) => HomeVisitsDoctorsList()));
//
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               FollowupVideoAppointmentListActivityPatient(
//                                   A_KEY, UID, UPHOTO)));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 48,
//                           width: 48,
//                           child: Image.asset(
//                             "assets/video_call_img.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               child: Text(
//                                 "Follow up Online Appointment",
//                                 style: TextStyle(
//                                   color: Color(0xFF34448c),
//                                 ),
//                                 textAlign: TextAlign.center,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 )),
//             InkWell(
//                 onTap: () {
// //                  Navigator.push(
// //                      context,
// //                      MaterialPageRoute(
// //                          builder: (context) => HomeVisitsDoctorsList()));
//
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PendingpaymentsActivity()));
//                 },
//                 child: Container(
//                   height: 110,
//                   child: Card(
//                     margin: EdgeInsets.all(0.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(0.0),
//                     ),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 48,
//                           width: 48,
//                           child: Image.asset(
//                             "assets/payment.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               child: Text(
//                                 "Pending Payments",
//                                 style: TextStyle(
//                                   color: Color(0xFF34448c),
//                                 ),
//                                 textAlign: TextAlign.center,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 )),
//           ],
//         ),
      ],
    ));
  }
}

class HomeVisitsDoctorsList extends StatefulWidget {
  String address;

  HomeVisitsDoctorsList(this.address);

  @override
  _HomeVisitsDoctorsListState createState() => _HomeVisitsDoctorsListState();
}

class _HomeVisitsDoctorsListState extends State<HomeVisitsDoctorsList> {
  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'home_visits_doctor_search',
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
                            builder: (context) => HomeVisitDoctorDetailPage(
                                widget.address, data[index])));
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
                            "https://appointmentbd.com/" +
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
  String address;

  HomeVisitDoctorDetailPage(this.address, this.data);

  @override
  _HomeVisitDoctorDetailPageState createState() =>
      _HomeVisitDoctorDetailPageState();
}

class _HomeVisitDoctorDetailPageState extends State<HomeVisitDoctorDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String problems, homeAddress, date, phone;
  String myMessage = "Submit";
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selctedDate_ = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
        setState(() {
          date = selctedDate_;
        });
        //  showThisToast(selctedDate_);
      });
  }

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
                    "https://appointmentbd.com/" + widget.data["photo"]),
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
                      initialValue: widget.address,
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
                    child: Container(
                      decoration: myBoxDecoration(),
                      child: ListTile(
                        onTap: () {
                          _selectDate(context);
                        },
                        trailing: Icon(Icons.arrow_downward),
                        title: Text(selctedDate_),
                      ),
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
                      keyboardType: TextInputType.number,
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
                                  'date': selctedDate_,
                                  'home_address': homeAddress
                                }),
                              );
                              print(response.body);
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

class ChooseConsultationDateTimeActivity extends StatefulWidget {
  dynamic docProfile;
  List allSunday = [];
  List allMonday = [];
  List allTuesday = [];
  List allWednesDay = [];
  List allThursDay = [];
  List allFriday = [];
  List allSatDay = [];
  int today = 1;
  int selectedDate = 1;
  int selectedMonth = 1;
  int selectedYear = 1;

  ChooseConsultationDateTimeActivity(this.docProfile);

  @override
  _ChooseConsultationDateTimeActivityState createState() =>
      _ChooseConsultationDateTimeActivityState();
}

int getMonthCount(int month) {
  int count = 0;
  if (month == 1) count = 31;
  if (month == 2) count = 29;
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

class _ChooseConsultationDateTimeActivityState
    extends State<ChooseConsultationDateTimeActivity> {
  getAlldays() {
    DateTime dateTimereal = new DateTime.now();

    setState(() {
      widget.selectedMonth = dateTimereal.month;
      widget.selectedYear = dateTimereal.year;
      widget.today = dateTimereal.day;
      widget.selectedDate = dateTimereal.day;
    });
    DateTime dateTime = new DateTime.now();
    int thisMonth = dateTime.month;
    dateTime = new DateTime(dateTimereal.year, dateTimereal.month, 1);
    for (int i = 0; i <= getMonthCount(dateTimereal.month); i++) {
      if (dateTime.weekday == 1) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
          }

          widget.allMonday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 2) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
          }
          widget.allTuesday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 3) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
          }
          widget.allWednesDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 4) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
          }
          widget.allThursDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 5) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
          }
          widget.allFriday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 6) {
        setState(() {
          if (i == 0) {
            // widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
            widget.allFriday.add(0);
          }
          widget.allSatDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 7) {
        setState(() {
          if (i == 0) {
            //  widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
            widget.allFriday.add(0);
            widget.allSatDay.add(0);
          }
          widget.allSunday.add(dateTime.day);
        });
      }
      dateTime = dateTime.add(new Duration(days: 1));
    }
    print(widget.allSunday.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAlldays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Appointment Date & Time"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.chevron_left),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.chevron_right),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text("This Month"),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: Text("Mon"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Tue"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Wed"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Thu"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Fri"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Sat"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text("Sun"),
                          )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allMonday == null
                                  ? 0
                                  : widget.allMonday.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allMonday[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allMonday[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allMonday[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allMonday[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allMonday[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allMonday[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allMonday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allTuesday == null
                                  ? 0
                                  : widget.allTuesday.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allTuesday[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allTuesday[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allTuesday[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allTuesday[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allTuesday[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allTuesday[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allTuesday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allWednesDay == null
                                  ? 0
                                  : widget.allWednesDay.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allWednesDay[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allWednesDay[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allWednesDay[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allWednesDay[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allWednesDay[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allWednesDay[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allWednesDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allThursDay == null
                                  ? 0
                                  : widget.allThursDay.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allThursDay[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allThursDay[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allThursDay[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allThursDay[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allThursDay[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allThursDay[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allThursDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allFriday == null
                                  ? 0
                                  : widget.allFriday.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allFriday[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allFriday[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allFriday[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allFriday[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allFriday[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allFriday[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allFriday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allSatDay == null
                                  ? 0
                                  : widget.allSatDay.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allSatDay[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allSatDay[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allSatDay[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allSatDay[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allSatDay[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allSatDay[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allSatDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.allSunday == null
                                  ? 0
                                  : widget.allSunday.length,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.allSunday[index] == 0
                                    ? Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allSunday[index] >=
                                                widget.today)
                                              widget.selectedDate =
                                                  widget.allSunday[index];
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allSunday[
                                                                  index] ==
                                                              widget.today
                                                          ? Colors.blue
                                                          : (widget.allSunday[
                                                                      index] <
                                                                  widget.today
                                                              ? Colors.grey
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget.allSunday[
                                                                      index] ==
                                                                  widget
                                                                      .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                                  255,
                                                                  236,
                                                                  236,
                                                                  236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allSunday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                              },
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                "Choose Slot",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConsultationFormActivity(
                            widget.selectedDate.toString() +
                                "/" +
                                widget.selectedMonth.toString() +
                                "/" +
                                widget.selectedYear.toString(),
                            "12:00 PM",
                            widget.docProfile["id"].toString(),widget.docProfile["name"],widget.docProfile["video_appointment_rate"]
                            .toString() +
                            " £")));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text("12:00 PM"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultationFormActivity extends StatefulWidget {
  int currentPage = 0;
  String name = "Aminul islam", age = "27", gender = "Male";

  List appointmentForUserType = [];
  List diseasesType = [];
  List conditionsType = [];
  List medications = [];
  String tempMedName = "";

  String weight = "66";
  String temperature = "34 C";
  String bloodPressure = "120/80";
  String date;

  String time;

  String reasonForVisit = "No reason selected";

  String conditions = "No conditions selected";

  String medicationsName = "No medicines selected";
  String docID;
  String docName;
  String fees;


  ConsultationFormActivity(this.date, this.time, this.docID,this.docName,this.fees);

  @override
  _ConsultationFormActivityState createState() =>
      _ConsultationFormActivityState();
}

class _ConsultationFormActivityState extends State<ConsultationFormActivity> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Me", 'isSelected': true});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "My Child", 'isSelected': false});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Adult", 'isSelected': false});

      widget.diseasesType
          .add(<String, dynamic>{'name': "Allergies", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Cough,Cold", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});

      widget.conditionsType
          .add(<String, dynamic>{'name': "Alcohol use disorder", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Alergies", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation Form"),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.currentPage == 0
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.currentPage == 1
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.currentPage == 2
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.currentPage == 3
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.currentPage == 4
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                  )),
                ],
              ),
            ),
            Container(
                height: 1000,
                child: PageView(
                  physics: new NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      widget.currentPage = index;
                    });
                  },
                  controller: _controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Text(
                            "Patient Info",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                          child: Text(
                            "Who is this Visit for",
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.appointmentForUserType == null
                              ? 0
                              : widget.appointmentForUserType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (int i = 0;
                                          i <
                                              widget.appointmentForUserType
                                                  .length;
                                          i++) {
                                        widget.appointmentForUserType[i]
                                            ["isSelected"] = false;
                                      }
                                      widget.appointmentForUserType[index]
                                          ["isSelected"] = true;
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value:
                                          widget.appointmentForUserType[index]
                                              ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                                      child: new Text(
                                        widget.appointmentForUserType[index]
                                            ["userType"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.name = value;
                                      },
                                      validator: (value) {
                                        widget.name = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Name';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Full Name",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.age = value;
                                      },
                                      validator: (value) {
                                        widget.age = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Age",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.gender = value;
                                      },
                                      validator: (value) {
                                        widget.gender = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Gender",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              //  widget.currentPage = old+1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Reason for Visit",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "This information will help doctor to understand your problem more"),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.diseasesType == null
                              ? 0
                              : widget.diseasesType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.reasonForVisit =
                                          widget.diseasesType[index]["name"];

                                      widget.diseasesType[index]
                                                  ["isSelected"] ==
                                              true
                                          ? (widget.diseasesType[index]
                                              ["isSelected"] = false)
                                          : widget.diseasesType[index]
                                              ["isSelected"] = true;
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value: widget.diseasesType[index]
                                          ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                      child: new Text(
                                        widget.diseasesType[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              // widget.currentPage = old+1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });

                            // _controller.animateTo(MediaQuery
                            //     .of(context)
                            //     .size
                            //     .width, duration: new Duration(milliseconds: 300),
                            //     curve: Curves.easeIn);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Conditions",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "Have you ever diagonised with any of these conditions"),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.conditionsType == null
                              ? 0
                              : widget.conditionsType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.conditionsType[index]
                                                  ["isSelected"] ==
                                              true
                                          ? (widget.conditionsType[index]
                                              ["isSelected"] = false)
                                          : widget.conditionsType[index]
                                              ["isSelected"] = true;

                                      widget.conditions = "";
                                      for (int i = 0;
                                          i < widget.conditionsType.length;
                                          i++) {
                                        if (widget.conditionsType[i]
                                            ["isSelected"]) {
                                          widget.conditions +=
                                              widget.diseasesType[i]["name"] +
                                                  " ";
                                        }
                                      }
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value: widget.conditionsType[index]
                                          ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                      child: new Text(
                                        widget.conditionsType[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              widget.currentPage = old + 1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);

                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Medications",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child:
                              Text("Please disclose any Medications you take"),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          child: Row(
                            children: [
                              Container(
                                width: 200,
                                child: TextFormField(
                                  onChanged: (value) {
                                    widget.tempMedName = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.medications
                                          .add(widget.tempMedName);
                                      widget.tempMedName = "";

                                      //  widget.conditions = "";
                                      for (int i = 0;
                                          i < widget.medications.length;
                                          i++) {
                                        widget.tempMedName +=
                                            widget.medications[i] + " ";
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: Colors.blue,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.medications == null
                              ? 0
                              : widget.medications.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // widget.diseasesType[index]["isSelected"] == true?( widget.diseasesType[index]["isSelected"] = false): widget.diseasesType[index]["isSelected"] = true;
                                    });
                                  },
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.medications.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.close),
                                      ),
                                      title: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: new Text(
                                          widget.medications[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              widget.medicationsName = "";
                              for (int i = 0;
                                  i < widget.medications.length;
                                  i++) {
                                widget.medicationsName +=
                                    widget.medications[i] + " , ";
                              }

                              int old = widget.currentPage;
                              widget.currentPage = old + 1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);

                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Vitals",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "Would you like to share your vitals for this visit"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.weight = value;
                                      },
                                      validator: (value) {
                                        widget.weight = value;
                                        if (value.isEmpty) {
                                          return 'Weight in KG';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Weight in KG",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.temperature = value;
                                      },
                                      validator: (value) {
                                        widget.temperature = value;
                                        if (value.isEmpty) {
                                          return 'Temperature';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Temperature",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.bloodPressure = value;
                                      },
                                      validator: (value) {
                                        widget.bloodPressure = value;
                                        if (value.isEmpty) {
                                          return 'Blood Pressure';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Blood Pressure",
                                          focusColor:
                                              Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            title: Text("Appointment Details"),
                                            backgroundColor: Colors.white,
                                          ),
                                          body: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                  child: Text(
                                                                      "Patient's Historty"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                              title: Text(
                                                                  "Patient Name"),
                                                              subtitle: Text(
                                                                  widget.name),
                                                            )),
                                                            Expanded(
                                                                child: ListTile(
                                                              title: Text(
                                                                  "Age and gender"),
                                                              subtitle: Text(
                                                                  widget.age +
                                                                      " , " +
                                                                      widget
                                                                          .gender),
                                                            )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                              title:
                                                                  Text("Date"),
                                                              subtitle: Text(
                                                                  widget.date),
                                                            )),
                                                            Expanded(
                                                                child: ListTile(
                                                              title:
                                                                  Text("Time"),
                                                              subtitle: Text(

                                                                      widget
                                                                          .time),
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                  child: Text(
                                                                      "Medical History"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                              title: Text(
                                                                  "Reason for Visit"),
                                                              subtitle: Text(widget
                                                                  .reasonForVisit),
                                                            )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                              title: Text(
                                                                  "Condition"),
                                                              subtitle: Text(widget
                                                                  .conditions),
                                                            )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                              title: Text(
                                                                  "Medications"),
                                                              subtitle: Text(widget
                                                                  .medicationsName),
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                  child: Text(
                                                                      "Vitals"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Weight"),
                                                                  subtitle: Text(
                                                                      widget.weight),
                                                                )),
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Temparature"),
                                                                  subtitle: Text(
                                                                      widget.temperature ),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title:
                                                                  Text("Blood Pressure"),
                                                                  subtitle: Text(
                                                                      widget.date),
                                                                )),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                  child: Text(
                                                                      "Doctor's Profile"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Name"),
                                                                  subtitle: Text(
                                                                     widget.docName),
                                                                )),

                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title:
                                                                  Text("Consultation Fees"),
                                                                  subtitle: Text(
                                                                      widget.fees),
                                                                )),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    color: Colors.blue,
                                                    elevation: 8,
                                                    child: InkWell(
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(15),
                                                          child: Text(
                                                            "Submit",
                                                            style: TextStyle(color: Colors.white,fontSize: 18),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        var appointmentSubmitRespons =
                                                            await performAppointmentSubmitNewVersion(
                                                                AUTH_KEY,
                                                                UID,
                                                                widget.docID,
                                                                widget.conditions,
                                                                "012",
                                                                widget.name,
                                                                null,
                                                                widget.date,
                                                                "0",
                                                                "n",
                                                                widget.time,
                                                            widget.age,
                                                            widget.gender,
                                                            widget.reasonForVisit,
                                                            widget.conditions,
                                                            widget.medicationsName,
                                                            widget.weight,
                                                            widget.temperature,
                                                            widget.bloodPressure,
                                                            widget.fees
                                                            );
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();

                                                        showThisToast(
                                                            appointmentSubmitRespons
                                                                .toString());
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white,fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

//TabBarView
class SimpleDocProfileActivity extends StatefulWidget {
  dynamic profileData;

  SimpleDocProfileActivity(this.profileData);

  @override
  _SimpleDocProfileActivityState createState() =>
      _SimpleDocProfileActivityState();
}

class _SimpleDocProfileActivityState extends State<SimpleDocProfileActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    _baseUrl_image +
                                        widget.profileData["photo"],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.profileData["name"]
                                            .toString()
                                            .trim(),
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.profileData["department_info"]
                                            ["name"],
                                        style: TextStyle(),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Video Call Fees",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.profileData["video_appointment_rate"]
                                            .toString() +
                                        " £",
                                    style: TextStyle(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Specialization",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: Text(
                              widget.profileData["designation_title"] == null
                                  ? "No Information"
                                  : widget.profileData["designation_title"],
                              style: TextStyle(),
                            ),
                          )
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChooseConsultationDateTimeActivity(
                                widget.profileData)));
              },
              child: Card(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DoctorSearchActivity extends StatefulWidget {
  List downloadedData = [];

  bool _enabled2 = true;

  @override
  _DoctorSearchActivityState createState() => _DoctorSearchActivityState();
}

class _DoctorSearchActivityState extends State<DoctorSearchActivity> {
  String key;

  getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.downloadedData = json.decode(response.body);
      //showThisToast("doc size "+widget.downloadedData.length.toString());
    });

    //showThisToast(downloadedData.length.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: TextFormField(
            onChanged: (text) {
              print("First text field: $text");
              showThisToast("First text field: $text");
            },
            style: TextStyle(
              color: Color.fromARGB(255, 189, 62, 68),
            ),
            initialValue: "",
            validator: (value) {
              key = value;
              if (value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 234, 234, 234),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 234, 234, 234), width: 10.0),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                focusColor: Color.fromARGB(255, 189, 62, 68),
                labelStyle: TextStyle(color: Colors.black)),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Text(
            //     "What are you looking for",
            //     style: TextStyle(color: Colors.black, fontSize: 18),
            //   ),
            // ),
            // Padding(padding: EdgeInsets.fromLTRB(15, 2, 0, 5),child: Container(
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            //     child: Text("Doctor"),
            //   ),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(3),
            //       shape: BoxShape.rectangle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.blue,
            //           blurRadius: 1.0,
            //           spreadRadius: 1.0,
            //         ),
            //       ]),
            // ),),
            //
            Center(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                          child: new Wrap(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Reset",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        " Filters",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new ListTile(
                                leading: new Icon(Icons.settings),
                                title: new Text('Setting 1'),
                                onTap: () => {},
                              ),
                              new ListTile(
                                leading: new Icon(Icons.settings),
                                title: new Text('Setting 2'),
                                onTap: () => {},
                              ),
                              new ListTile(
                                leading: new Icon(Icons.settings),
                                title: new Text('Setting 3'),
                                onTap: () => {},
                              ),
                              Center(
                                child: Card(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            widget.downloadedData.length == 0
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Center(
                      child: Text("Loading"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.downloadedData == null
                        ? 0
                        : widget.downloadedData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             OnlineDoctorFullProfileView(
                                  //                 widget.downloadedData[index][
                                  //                     "id"],
                                  //                 widget.downloadedData[index]
                                  //                     ["name"],
                                  //                 widget.downloadedData[index]
                                  //                     ["photo"],
                                  //                 widget.downloadedData[index]
                                  //                     ["designation_title"],
                                  //                 widget.downloadedData[index][
                                  //                     "online_doctors_service_info"])));
                                  //
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SimpleDocProfileActivity(widget
                                                  .downloadedData[index])));
                                },
                                child: ListTile(
                                  trailing: Text(widget.downloadedData[index]
                                              ["video_appointment_rate"]
                                          .toString() +
                                      " £"),
                                  subtitle: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                                    child: new Text(
                                      widget.downloadedData[index]
                                          ["department_info"]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                                    child: new Text(
                                      widget.downloadedData[index]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        (_baseUrl_image +
                                            widget.downloadedData[index]
                                                ["photo"])),
                                  ),
                                )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                ])),
                      );

                      return new InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OnlineDoctorFullProfileView(
                                          widget.downloadedData[index]["id"],
                                          widget.downloadedData[index]["name"],
                                          widget.downloadedData[index]["photo"],
                                          widget.downloadedData[index]
                                              ["designation_title"],
                                          widget.downloadedData[index][
                                              "online_doctors_service_info"])));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(00.0),
                          ),
                          child: ListTile(
                            subtitle: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                              child: new Text(
                                widget.downloadedData[index]
                                            ["designation_title"] !=
                                        null
                                    ? widget.downloadedData[index]
                                        ["designation_title"]
                                    : "No Designation data",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                              child: new Text(
                                widget.downloadedData[index]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage((_baseUrl_image +
                                  widget.downloadedData[index]["photo"])),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

void _filterModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Music'),
                  onTap: () => {}),
              new ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}

class PendingpaymentsActivity extends StatefulWidget {
  @override
  PendingpaymentsActivityState createState() => PendingpaymentsActivityState();
}

class PendingpaymentsActivityState extends State<PendingpaymentsActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Pending Payments"),
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
            leading: Image.asset(
              "assets/man_.png",
              width: 30,
              height: 30,
            ),
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
            leading: Image.asset(
              "heart_disease.png",
              width: 30,
              height: 30,
            ),
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
            leading: Image.asset(
              "prescription_.png",
              width: 30,
              height: 30,
            ),
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
            leading: Image.asset(
              "prescription_.png",
              width: 30,
              height: 30,
            ),
          ),
          Divider(),
          ListTile(
            //
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TestRecomendationWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Test Recommendations"),
            subtitle: Text("View your recommended tests from doctors"),
            leading: Image.asset(
              "chemistry.png",
              width: 30,
              height: 30,
            ),
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
                      backgroundImage: NetworkImage(_baseUrl_image + UPHOTO),
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
            const url =
                "https://web.facebook.com/Betta-Health-112876333823426/";

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
      body: DeptListOnlineDocWidget(),
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
        backgroundColor: Colors.white,
        elevation: 10,
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
              //  showThisToast(AUTH_KEY + "/n" + UID);

              var response = await request.send();

              print(response.statusCode);
              // showThisToast(response.statusCode.toString());

              response.stream.transform(utf8.decoder).listen((value) {
                //print(value);
                //showThisToast(value);

                var data = jsonDecode(value);
                //showThisToast(data.t);
                // showThisToast((data["photo"]).toString());
                setState(() {
                  user_picture = (data["photo"]).toString();
                  UPHOTO = user_picture;
                });
              });
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                      //  top: 0,bottom: 0,left: 0,right: 0,
                      child: CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.orange,
                  )),
                  Center(
                    // top: 0,bottom: 0,left: 0,right: 0,

                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(_baseUrl_image + UPHOTO),
                    ),
                  )
                ],
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    var status = updateDisplayName(
                                        AUTH_KEY, UID, newName);
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
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
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
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
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
                ],
              ),
            ),
          ),
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
                                      partner_id,
                                      partner_name,
                                      parner_photo,
                                      UID,
                                      UNAME,
                                      UPHOTO,
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
        'Authorization': A_KEY,
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
                          trailing: Icon(Icons.arrow_right),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                            _baseUrl_image +
                                ((prescriptionList[index]["dr_info"] == null ||
                                        prescriptionList[index]["dr_info"]
                                                ["photo"] ==
                                            null)
                                    ? ""
                                    : prescriptionList[index]["dr_info"]
                                        ["photo"]),
                          )),
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.label_important),
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
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
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
          child: ListView(
            shrinkWrap: true,
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
                    physics: ClampingScrollPhysics(),
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

class TestRecomendationWidget extends StatefulWidget {
  @override
  _TestRecomendationState createState() => _TestRecomendationState();
}

class _TestRecomendationState extends State<TestRecomendationWidget> {
  List prescriptionReviewList = [];

  Future<String> getData() async {
    // showThisToast("user id " + UID);
    final http.Response response = await http.post(
      _baseUrl + 'test-recommendation-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'patient_id': UID}),
    );
    //showThisToast(response.statusCode.toString());
    //showThisToast(response.body);
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
        title: Text("All Test Recommendation"),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestRecomendationView(
                                  prescriptionReviewList[index])));
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
                            prescriptionReviewList[index]["problems"]
                                .toString(),
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

class TestRecomendationView extends StatefulWidget {
  dynamic testRecomBody;

  TestRecomendationView(this.testRecomBody);

  @override
  _TestRecomendationViewWidgetState createState() =>
      _TestRecomendationViewWidgetState();
}

class _TestRecomendationViewWidgetState extends State<TestRecomendationView> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Recommendation Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Problems"),
              subtitle: Text(widget.testRecomBody["problems"]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text("Recommened Tests"),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.testRecomBody["test_recommendation_info"] ==
                        null
                    ? 0
                    : widget.testRecomBody["test_recommendation_info"].length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  TestRecomendationView(
//                                      prescriptionReviewList[index])));
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(05),
                          child: ListTile(
                            subtitle: new Text(
                                widget.testRecomBody["test_recommendation_info"]
                                    [index]["test_info"]["type"]),
                            // trailing: Icon(Icons.keyboard_arrow_right),
                            leading: Icon(Icons.label_important),
                            title: new Text(
                              widget.testRecomBody["test_recommendation_info"]
                                  [index]["test_info"]["name"],
                            ),
                          ),
                        )),
                  );
                })
          ],
        ),
      ),
    );
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
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    //showThisToast(response.statusCode.toString());
    // showThisToast(response.body);
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      // showThisToast(prescriptionReviewList.toString());
    });
    print(response.body);
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
                                    PrescriptionsReviewBodyWidget2(
                                        prescriptionReviewList[index])));

//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    PrescriptionsReviedBodyState(
//                                        prescriptionReviewList[index])));
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

class PrescriptionsReviewBodyWidget2 extends StatefulWidget {
  dynamic prescriptionReview;

  PrescriptionsReviewBodyWidget2(this.prescriptionReview);

  @override
  _PrescriptionsReviewBodyWidget2State createState() =>
      _PrescriptionsReviewBodyWidget2State();
}

class _PrescriptionsReviewBodyWidget2State
    extends State<PrescriptionsReviewBodyWidget2> {
  List prescriptionReviewList = [];
  dynamic oldPrescription;
  dynamic newPrescription;

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      //showThisToast(prescriptionReviewList.toString());
    });
    return "Success!";
  }

  Future<String> getOldPrescription() async {
    // showThisToast(widget.prescriptionReview["old_prescription_id"].toString());

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
      oldPrescription = json.decode(response.body);

      print(oldPrescription);
    });
    showThisToast(response.statusCode.toString());
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
    // showThisToast("new pr download "+response.statusCode.toString());

    this.setState(() {
      print("Single Prescriptin");
      newPrescription = json.decode(response.body);

      print(newPrescription);
    });
    return "Success!";
  }

  @override
  void initState() {
    // TODO: implement initState
    print("review page api hit starts");
    print("orescription id " +
        widget.prescriptionReview["old_prescription_id"].toString());

    // this.getData();
    this.getOldPrescription();
    this.getNewPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Review From Doctor"),
          bottom: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              height: 50.0,
              child: new TabBar(
                tabs: [
                  Tab(
                    text: "Summery",
                  ),
                  Tab(
                    text: "Old Prescription",
                  ),
                  Tab(text: "New Prescription"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Patient's Comment :"),
                  Text(widget.prescriptionReview["patient_comment"]),
                  Text("Doctors's Comment :"),
                  Text(widget.prescriptionReview["dr_comment"].toString()),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                  child: ListTile(
                    title: Text("Doctors Comment"),
                    subtitle: Text(oldPrescription != null
                        ? oldPrescription["diseases_name"]
                        : "Loading"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                  child: Text("Medicines"),
                ),
                medicinesListOfAPrescriptionWidget(oldPrescription)
              ],
            ),
            ListView(
              children: [
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
            )
          ],
        ),
      ),
    ));
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
  String currentLocation = "Current location";

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = p[0];
      //  showThisToast("${place.locality}, ${place.postalCode}, ${place.country}");
      setState(() {
        currentLocation =
            "${place.name}, ${place.postalCode}, ${place.country}";
        //currentLocation = place.locality;
        address = "${place.name}, ${place.postalCode}, ${place.country}";
        //address =place.administrativeArea;
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
          child: HomeVisitsDoctorsList(address),
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
                        ? Text(currentLocation)
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
                        //  showThisToast(address);

                        setState(() {
                          currentLocation = address;
                          latitude = detail.result.geometry.location.lat;
                          longitude = detail.result.geometry.location.lng;
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 00, 0),
                          child: Text("Change",
                              style: TextStyle(
                                  color: tColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14))),
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
