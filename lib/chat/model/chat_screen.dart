import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:appxplorebd/myCalling/call.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/projPaypal/config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appxplorebd/chat/model/chat_message.dart';
import 'package:appxplorebd/chat/service/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
String CLIEND_ID = "xploreDoc";

class ChatScreen extends StatefulWidget {
  ChatScreen( this.partner_id,
      this.partner_name,
      this.partner_photo,
      this.own_id,
      this.own_name,
      this.own_photo,
      this.chatRoom);



  String partner_id = "";
  String partner_name = "";
  String partner_photo = "";
  String own_id = "";
  String own_name = "";
  String own_photo = "";
  String chatRoom = "";

  @override
  State createState() => ChatScreenState();
}

const List<Choice> choices = const <Choice>[
  const Choice('Sign out'),
  const Choice('Settings')
];

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _title;
  final List<ChatMessage> _messages;
  final TextEditingController _textController;
  final DatabaseReference _messageDatabaseReference;
  final DatabaseReference _messageDatabaseReference_last;
  final StorageReference _photoStorageReference;


  bool _isComposing = false;

  ChatScreenState()
      : _title = "app",
        _isComposing = false,
        _messages = <ChatMessage>[],
        _textController = TextEditingController(),
        _messageDatabaseReference =FirebaseDatabase.instance.reference().child(CLIEND_ID).child("chatHistory"),
        _messageDatabaseReference_last =FirebaseDatabase.instance.reference().child(CLIEND_ID).child("lastChatHistory"),
        _photoStorageReference =
        FirebaseStorage.instance.ref().child("chat_photos",
        ) {
    _messageDatabaseReference.child(CHAT_ROOM).onChildAdded.listen(_onMessageAdded);
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  decoration:
                  InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _sendImageFromCamera,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _sendImageFromGallery,
                      ),
                      Theme
                          .of(context)
                          .platform == TargetPlatform.iOS
                          ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                          : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _onMessageAdded(Event event) {
    final message_body = event.snapshot.value["message_body"];
    final message_type = event.snapshot.value["message_type"];
    final recever_id = event.snapshot.value["recever_id"];
    final sender_id = event.snapshot.value["sender_id"];
    final time = event.snapshot.value["time"];
//    ChatMessage message = imageUrl == null
//        ? _createMessageFromText(text)
//        : _createMessageFromImage(imageUrl);

    ChatMessage message = _createMessageFromText(message_body,message_type,recever_id,sender_id,time);

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    final ChatMessage message = _createMessageFromText(text,"TYPE_TEXT",widget.partner_id,widget.own_id,new DateTime.now().toUtc().toIso8601String());
    _messageDatabaseReference.child(CHAT_ROOM).push().set(message.toMap());

    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("message_body").set(text);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("message_type").set("TYPE_TEXT");
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("receiver_name").set(widget.partner_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("receiver_photo").set(widget.partner_photo);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("recever_id").set((widget.partner_id));
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_id").set(widget.own_id);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_name").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_photo").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("time").set(new DateTime.now().toUtc().toIso8601String());

    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("message_body").set(text);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("message_type").set("TYPE_TEXT");
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("receiver_name").set(widget.partner_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("receiver_photo").set(widget.partner_photo);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("recever_id").set((widget.partner_id));
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_id").set(widget.own_id);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_name").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_photo").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("time").set(new DateTime.now().toUtc().toIso8601String());
  }

  void _sendImage(ImageSource imageSource) async {
    File image = await ImagePicker.pickImage(source: imageSource);
    final String fileName = Uuid().v4();
    StorageReference photoRef = _photoStorageReference.child(fileName);
    final StorageUploadTask uploadTask = photoRef.putFile(image);
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    String img_Link=await downloadUrl.ref.getDownloadURL() ;
    final ChatMessage message = _createMessageFromImage(
        img_Link, "TYPE_IMAGE", widget.partner_id, widget.own_id, new DateTime.now().toUtc().toIso8601String()
    );
    _messageDatabaseReference.child(CHAT_ROOM).push().set(message.toMap());

    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("message_body").set(img_Link);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("message_type").set("TYPE_IMAGE");
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("receiver_name").set(widget.partner_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("receiver_photo").set(widget.partner_photo);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("recever_id").set((widget.partner_id));
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_id").set(widget.own_id);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_name").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("sender_photo").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.own_id).child(widget.partner_id).child("time").set(new DateTime.now().toUtc().toIso8601String());

    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("message_body").set(img_Link);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("message_type").set("TYPE_IMAGE");
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("receiver_name").set(widget.partner_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("receiver_photo").set(widget.partner_photo);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("recever_id").set((widget.partner_id));
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_id").set(widget.own_id);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_name").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("sender_photo").set(widget.own_name);
    _messageDatabaseReference_last.child(widget.partner_id).child(widget.own_id).child("time").set(new DateTime.now().toUtc().toIso8601String());
  }

  void _sendImageFromCamera() async {
    _sendImage(ImageSource.camera);
  }

  void _sendImageFromGallery() async {
    _sendImage(ImageSource.gallery);
  }

  ChatMessage _createMessageFromText(String message_body, String message_type,String recever_id,String sender_id,String time) =>
      ChatMessage(
        message_body: message_body,
        sender_id:sender_id,
        recever_id: recever_id,
        message_type: message_type,
        time: time,
        animationController: AnimationController(
          duration: Duration(milliseconds: 180),
          vsync: this,
        ),
      );

  ChatMessage _createMessageFromImage(String message_body, String message_type,String recever_id,String sender_id,String time) =>
      ChatMessage(
        message_body: message_body,
        sender_id: sender_id,
        recever_id: recever_id,
        message_type: "TYPE_IMAGE",
        time: time,
        animationController: AnimationController(
          duration: Duration(milliseconds: 1000),
          vsync: this,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partner_name),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  ClientRole _role = ClientRole.Broadcaster;
                  // await for camera and mic permissions before pushing video page
                  await _handleCameraAndMic();
                  // push video page with given channel name
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(
                        channelName:widget.chatRoom,
                        role: _role,
                      ),
                    ),
                  );

                },
                child: Icon(
                  Icons.call,
                  size: 26.0,
                ),
              )
          ),
        ],
        elevation: Theme
            .of(context)
            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme
                  .of(context)
                  .cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme
            .of(context)
            .platform == TargetPlatform.iOS
            ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]),
            ))
            : null,
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void _select(Choice choice) {
    switch (choice.title) {
      case 'Sign out':
       // _signOut();
        break;
    }
  }


}
Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
}
class Choice {
  const Choice(this.title);

  final String title;
}
