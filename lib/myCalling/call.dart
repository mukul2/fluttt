import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:appxplorebd/appPhoneVerification.dart';
import 'package:appxplorebd/myCalling/settings.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
bool isCallingEngagged= false ;
int userCount = 0;
class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String UID;
  final String ownName;
  final String partnerID;
  final String partnerPhoto;
  final bool isCameraOn;
  final bool isCaller;


  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallPage(
      {Key key, this.channelName, this.role, this.isCameraOn, this.UID,this.ownName,this.partnerID,this.partnerPhoto,this.isCaller})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
    isCallingEngagged = false ;
  }

  sendPush()async{
    //send push
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    http.Response response  =   await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw', // Constant string
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
'title':"Incomming Call",
            'body':'Call from '+widget.ownName
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'doc_id': widget.UID,
            'doc_name': widget.ownName,
            'doc_photo': widget.partnerPhoto,
            'type': 'incomming_call',
            'room': widget.channelName
          },
          'to': "/topics/"+widget.partnerID
        },
      ),
    );
   // showThisToast(response.statusCode.toString());

    //send push ends
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    this.sendPush();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(320, 240);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(
        null, widget.channelName, null, int.parse(widget.UID));
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    if (widget.isCameraOn) {
      await AgoraRtcEngine.enableVideo();
    } else {}
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
      isCallingEngagged = false;
      userCount = _users.length;
      Navigator.of(context).pop();
      isCallingEngagged = false ;

    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
      userCount = _users.length;
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
      userCount = _users.length;
      Navigator.of(context).pop();
      isCallingEngagged = false;
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(AgoraRenderWidget(0, local: true, preview: true));
    }
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    //showThisToast(views.length.toString());
    switch (views.length) {
      // case 1:
      //   return Stack(
      //     children: [
      //       _videoView(views[0]),
      //       Center(
      //         child: Text("Calling",style: TextStyle(color: Colors.white),),
      //       )
      //
      //     ],
      //   );
//      case 2:
//        return Container(
//            child: Column(
//          children: <Widget>[
//            _expandedVideoRow([views[1]]),
//            _expandedVideoRow([views[0]])
//          ],
//        ));
      case 2:
        return Stack(
          children: [
            views[1],
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 100,
                height: 180,
                child: views[0],
              ),
            )
          ],
        );
      case 3:
        return Stack(
          children: [
            views[1],
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 100,
                height: 180,
                child: views[0],
              ),
            )
          ],
        );
      case 4:
        return Stack(
          children: [
            views[1],
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 100,
                height: 180,
                child: views[0],
              ),
            )
          ],
        );
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context)async {
    //showThisToast("user count "+_getRenderViews().length.toString());
    Navigator.pop(context);
    isCallingEngagged =  false ;

    //Navigator.of(context).pop();

    if( widget.isCaller==true && _getRenderViews().length==2 ){
      //showThisToast(widget.partnerID);
      http.Response response  =   await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw', // Constant string
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{

            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              // 'doc_id': widget.UID,
              // 'doc_name': widget.ownName,
              // 'doc_photo': widget.partnerPhoto,
              'type': 'end_call',
              //'room': widget.channelName
            },
            'to': "/topics/"+widget.partnerID
          },
        ),
      );
    }else if( widget.isCaller==true && _getRenderViews().length==1 ){
      //showThisToast(widget.partnerID);
      http.Response response  =   await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw', // Constant string
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{

            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              // 'doc_id': widget.UID,
              // 'doc_name': widget.ownName,
              // 'doc_photo': widget.partnerPhoto,
              'type': 'cancel_call',
              //'room': widget.channelName
            },
            'to': "/topics/"+widget.partnerID
          },
        ),
      );
    }else {
      //showThisToast("Doc ended the call but no noti ");
    }





  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);

  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conference'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
          ],
        ),
      ),
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