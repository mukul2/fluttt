import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:convert';
import 'ChamberDoctorFullProfileView.dart';
import 'OnlineDoctorFullProfileView.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;

String AUTH_KEY;

class ChamberDoctorList extends StatefulWidget {
  String selectedCategory;

  ChamberDoctorList(this.selectedCategory);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<ChamberDoctorList> {
  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-search',
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
  void initState() {
    this.getData();
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          new AppBar(title: new Text("Doctors"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
//
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ChamberDoctorFullProfileView(data[index]["id"],data[index]["name"],data[index]["photo"],data[index]["designation_title"],data[index]["online_doctors_service_info"])));
//
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(
                    data[index]["designation_title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(
                    data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      ("https://appointmentbd.com/" +
                          data[index]["photo"])),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void getAuth() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY = prefs.getString("auth");
  }
}

List data_;

Future<List> getData(String id) async {
  final http.Response response = await http.post(
    "https://appointmentbd.com/api/" + 'search-online-doctors',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(<String, String>{'department_id': id}),
  );

  data_ = json.decode(response.body);

  return data_;
}
//state here



class ChooseDoctorChamber extends StatefulWidget {
  String id;
  String auth;

  bool _enabled2 = true;
  ChooseDoctorChamber(this.id,this.auth);
  @override
  _ChooseDoctorChamberState createState() => _ChooseDoctorChamberState();
}

class _ChooseDoctorChamberState extends State<ChooseDoctorChamber> {
  List downloadedData = [];
  Future<List> getData(String id) async {
    final http.Response response = await http.post(
      "https://appointmentbd.com/api/" + 'doctor-search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': widget.auth,
      },
      body: jsonEncode(<String, String>{'department_id': id}),
    );

    setState(() {
      downloadedData = json.decode(response.body);

    });


    //showThisToast(response.body.toString());
    //showThisToast(downloadedData.length.toString());

    return data_;
  }
  @override
  void initState() {
    // TODO: implement initState
    this.getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Doctor"),
      ),
      body: downloadedData.length==0 ?Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: widget._enabled2,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 200,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 6,
                ),
              ),
            ),

          ],
        ),
      ): ListView.builder(
        itemCount:
        downloadedData== null ? 0 : downloadedData.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChamberDoctorFullProfileView(
                              downloadedData[index]["id"],
                              downloadedData[index]["name"],
                              downloadedData[index]["photo"],
                              downloadedData[index]
                              ["designation_title"])));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(
                    downloadedData[index]["designation_title"]!=null?downloadedData[index]["designation_title"]:"No designation data",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(
                    downloadedData[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      ("https://appointmentbd.com/" +
                          downloadedData[index]["photo"])),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




Widget ChamberDoctorListWidget(String id) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Choose a Doctor"),
    ),
    body: FutureBuilder(
        future: getData(id),
        builder: (context, projectSnap) {
          return (data_ == null)
              ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(00.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Padding(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  width: double.infinity,
                                  height: 12.0,
                                  color: Colors.white,
                                )
                            ),
                          ),
                        ),
                      ),
                      itemCount: 6,
                    ),
                  ),
                ),

              ],
            ),
          )
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
                                    ChamberDoctorFullProfileView(
                                        projectSnap.data[index]["id"],
                                        projectSnap.data[index]["name"],
                                        projectSnap.data[index]["photo"],
                                        projectSnap.data[index]
                                            ["designation_title"])));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: ListTile(
                          subtitle: Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                            child: new Text(
                              projectSnap.data[index]["designation_title"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                            child: new Text(
                              projectSnap.data[index]["name"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                ("https://appointmentbd.com/" +
                                    projectSnap.data[index]["photo"])),
                          ),
                        ),
                      ),
                    );
                  },
                );
        }),
  );
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