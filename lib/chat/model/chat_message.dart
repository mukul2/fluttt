import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/view/patient/patient_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String UID = USER_ID;

class ChatMessage extends StatelessWidget {
  final String message_body_;
  final String message_type_;
  final String recever_id_;
  final String sender_id_;
  final String time_;
  final AnimationController animationController;

  ChatMessage({
    String message_body,
    String message_type,
    String recever_id,
    String sender_id,
    String time,
    AnimationController animationController,
  })
      : message_body_ = message_body,
        message_type_ = message_type,
        recever_id_ = recever_id,
        sender_id_ = sender_id,
        time_ = time,
        animationController = animationController;

  Map<String, dynamic> toMap() =>
      {
        'message_body': message_body_,
        'message_type': message_type_,
        'recever_id': recever_id_,
        'sender_id': sender_id_,
        'time': time_,
      };

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor:
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: (UID == sender_id_
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end),
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: (UID == sender_id_
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end),
                  children: <Widget>[

                    Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: returnChatBody(
                            message_type_, sender_id_, message_body_)
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget returnChatBody(String m_type, String s_id, String m_body)  {

    //return Text(m_type+"  ==  "+m_body +"  ==  "+s_id);
    if (m_type == "TYPE_TEXT") {
      if (UID == s_id) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.pink,
            child: Container(
              margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(message_body_,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ));
      } else {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueAccent,
            child: Container(
              margin: EdgeInsets.fromLTRB(00, 0, 00, 0),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(message_body_,
                    style:
                    TextStyle(color: Colors.white)),
              ),
            ));
      }
    } else if (m_type == "TYPE_IMAGE") {
      if (UID == s_id) {
        return Container(
          height: 300,
          margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
          child: Image.network(message_body_),
        );
      } else {
        return Container(
          height: 300,
          margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
          child: Image.network(message_body_),
        );
      }
    } else if (m_type == "TYPE_FILE") {
      if (UID == s_id) {
        return InkWell(
          onTap: (){
            launch(m_body);
          },
          child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.pink,
              child: Container(
                margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Click to Open Attachment",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        );
      } else {
        return InkWell(
          onTap: (){
            launch(m_body);
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.blueAccent,
              child: Container(
                margin: EdgeInsets.fromLTRB(00, 0, 00, 0),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Click to open Attachment",
                      style:
                      TextStyle(color: Colors.white)),
                ),
              )),
        );
      }
    }

//    message_type_ == "TYPE_TEXT"
//        ? (UID == sender_id_
//        ? (Card(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0),
//        ),
//        color: Colors.pink,
//        child: Container(
//          margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
//          child: Padding(
//            padding: EdgeInsets.all(10),
//            child: Text(
//              message_body_,
//              style: TextStyle(
//                color: Colors.white,
//              ),
//            ),
//          ),
//        )))
//        : (Card(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0),
//        ),
//        color: Colors.blueAccent,
//        child: Container(
//          margin: EdgeInsets.fromLTRB(00, 0, 00, 0),
//          child: Padding(
//            padding: EdgeInsets.all(10),
//            child: Text(message_body_,
//                style:
//                TextStyle(color: Colors.white)),
//          ),
//        ))))
//        : UID == sender_id_
//        ? (Container(
//      height: 300,
//      margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
//      child: Image.network(message_body_),
//    ))
//        : Container(
//      height: 300,
//      margin: EdgeInsets.fromLTRB(00, 00, 00, 0),
//      child: Image.network(message_body_),
//    )
//    ,

//
//    return
//    null;

  }
}
