import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'OnlineDoctorsList.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

List data_;
String AUTH_KEY ;

class DeptForOnlineDoc extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<DeptForOnlineDoc> {
  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'department-list',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': AUTH_KEY,
      },
    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[1]["name"]);

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Choose Departmemt"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OnlineDoctorList((data[index]["id"]).toString())));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: new Text(
                    data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ));
        },
      ),
    );
  }
}

bool isLoading = true;

Widget DeptListOnlineDocWidget(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Department"),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, projectSnap) {
            return (data_ == null)
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
                                    builder: (context) =>
                                        OnlineDoctorListWidget(
                                            (projectSnap.data[index]["id"])
                                                .toString())));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(00.0),
                            ),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_right),
                              title: Padding(
                                padding: EdgeInsets.all(0),
                                child: new Text(
                                  projectSnap.data[index]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Future<List> getData() async {
  isLoading = true;
  final http.Response response = await http.post(
    "http://telemedicine.drshahidulislam.com/api/" + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY,
    },
  );
  isLoading = false;
  data_ = json.decode(response.body);

//  showThisToast(data_.length.toString());

  return data_;
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
