import 'package:appxplorebd/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneVerificationScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String verificationId_;

  AuthResult result;

  String userType;

  PhoneVerificationScreen(this.userType);

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
   // showThisToast("trying with " + phone);

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          //Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            // user is available
            Navigator.of(context).pop();
            if (userType == "p") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupActivityPatient()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupActivityDoctor()));
            }
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          showThisToast("error occured " + exception.message);
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          verificationId_ = verificationId;
//          showDialog(
//              context: context,
//              barrierDismissible: false,
//              builder: (context) {
//                showThisToast("code sent");
//                return AlertDialog(
//                  title: Text("Give the code?"),
//                  content: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      TextField(
//                        controller: _codeController,
//                      ),
//                    ],
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("Confirm"),
//                      textColor: Colors.white,
//                      color: Colors.blue,
//                      onPressed: () async {
//                        final code = _codeController.text.trim();
//                        AuthCredential credential =
//                            PhoneAuthProvider.getCredential(
//                                verificationId: verificationId, smsCode: code);
//
//                        AuthResult result =
//                            await _auth.signInWithCredential(credential);
//
//                        FirebaseUser user = result.user;
//
//                        if (user != null) {
//                          //veri done
//                          Navigator.of(context).pop();
//                          Navigator.push(context, MaterialPageRoute(
//                              builder: (context) => SignupActivityPatient()
//                          ));
//                        } else {
//                          print("Error");
//                        }
//                      },
//                    )
//                  ],
//                );
//              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    loginUser(PHONE_NUMBER_VERIFIED, context);
    return Scaffold(
        body: Center(
      child: Text("Please wait"),
    ));
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
