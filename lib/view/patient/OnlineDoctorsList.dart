import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'OnlineDoctorFullProfileView.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;
String AUTH_KEY;


class OnlineDoctorList extends StatefulWidget {
  String selectedCategory;

  OnlineDoctorList(this.selectedCategory);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorList> {

  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'search-online-doctors',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'department_id': widget.selectedCategory}),


    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data);

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
          title: new Text("Doctors"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      OnlineDoctorFullProfileView(
                          data[index]["id"], data[index]["name"],
                          data[index]["photo"],
                          data[index]["designation_title"],
                          data[index]["online_doctors_service_info"])));
            },
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(data[index]["designation_title"],
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                leading: Image.network(
                    "http://telemedicine.drshahidulislam.com/" +
                        data[index]["photo"], fit: BoxFit.fill),

              ),
            ),
          );
        },
      ),
    );
  }
}

List data_;



Future<List> getData(String id) async {
  final http.Response response = await http.post(
    "http://telemedicine.drshahidulislam.com/api/" + 'search-online-doctors',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'department_id': id}),


  );

  data_ = json.decode(response.body);

  return data_;
}

Widget OnlineDoctorListWidget(String id) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Select a Doctor"),
    ),
    body: FutureBuilder(
        future: getData(id),
        builder: (context, projectSnap) {
          return(data_==null) ? Center(child: CircularProgressIndicator()):new ListView.builder(
            itemCount: projectSnap.data == null ? 0 : projectSnap.data.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          OnlineDoctorFullProfileView(
                              projectSnap.data[index]["id"], projectSnap.data[index]["name"],
                              projectSnap.data[index]["photo"],
                              projectSnap.data[index]["designation_title"],
                              projectSnap.data[index]["online_doctors_service_info"])));
                },
                child: Card(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(00.0),
                  ),
                  child: ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                      child: new Text(projectSnap.data[index]["designation_title"],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                      child: new Text(projectSnap.data[index]["name"],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(("http://telemedicine.drshahidulislam.com/" +
                          projectSnap.data[index]["photo"])),
                    ),

                  ),
                ),
              );
            },
          );
        }
    ),
  );
}

