import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'ChamberDoctorsList.dart';
import 'OnlineDoctorsList.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;
String AUTH_KEY;

class DeptForChamberDoc extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<DeptForChamberDoc> {
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
          title: new Text("Chamber Choose Departmemt"),
          backgroundColor: Colors.blue),
      body: new GridView.builder(
          itemCount: 20,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Card(
                elevation: 5.0,
                child: new Container(
                  alignment: Alignment.center,
                  child: new Text('Item $index'),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChamberDoctorList((data[index]["id"]).toString())));
              },
            );
          }),
    );
  }
}

List data_;

Widget DeptChamberDocWidget(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Department"),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, projectSnap) {
            return (projectSnap.data == null)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount: projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
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
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChamberDoctorListWidget(
                                      (projectSnap.data[index]["id"])
                                          .toString())));
                        },
                      );
                    });
            ;
          }));
}

Future<List> getData() async {
  final http.Response response = await http.post(
    "http://telemedicine.drshahidulislam.com/api/" + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY,
    },
  );
  data_ = json.decode(response.body);

  return data_;
}
