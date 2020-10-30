import 'dart:async';
import 'package:appxplorebd/utils/mySharedPreffManager.dart';
import 'package:appxplorebd/view/login_view.dart';
import 'package:appxplorebd/view/patient/sharedActivitys.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


Future<dynamic>apiRequestWithMultipart(File image,header,body,String base,String api,Function function)async{
//  File image =
//      await ImagePicker.pickImage(source: ImageSource.gallery);
  var uri = Uri.parse(base + api);
  var request = new http.MultipartRequest("POST", uri);
  if(image!=null){
   var stream =
   new http.ByteStream(DelegatingStream.typed(image.openRead()));
   var length = await image.length();
   var multipartFile = new http.MultipartFile(
       'photo', stream, length,
       filename: basename(image.path));
   request.files.add(multipartFile);
 }
  request.fields.addAll(body);
  request.headers.addAll(header);
  var response = await request.send();
  showThisToast(response.statusCode.toString());
  response.stream.transform(utf8.decoder).listen((value) {
    function(jsonDecode(value));



  });
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
