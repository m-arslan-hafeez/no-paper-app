import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:qr_covid/firestore/FirebaseOperations.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/views/InserisciView.dart';

import '../common.dart';

class Link extends StatefulWidget {
  static String routeName = "/link";
  final String userUid;
  Link({Key key, this.userUid}) : super(key: key);

  @override
  _LinkState createState() {
    return _LinkState();
  }
}

class _LinkState extends State<Link> {
  bool loading = false;
  @override
  void initState() {
    super.initState();

    getUserData();
  }

  UserModel user;

  void getUserData() async {
    setState(() {
      loading = true;
    });
    user = await FirebaseOperations.getInstance().getUser(widget.userUid);
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.grey, Colors.grey],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
      child: loading
          ? SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0))
          : Container(
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .80 : .30),
              height: MediaQuery.of(context).size.height *
                  (isMobile(context) ? .50 : .50),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/nopaper_512.png",
                      width: 100, height: 100),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  Text(user.businessName,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: isMobile(context) ? 18 : 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width *
                        (isMobile(context) ? .6 : .3),
                    child: FlatButton(
                        shape: StadiumBorder(),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () async {
                          Navigator.pushNamed(context, Inserisciview.routeName,
                              arguments: user);
                        },
                        child: Text("Compila il modulo",
                            style: TextStyle(fontSize: 22))),
                  ),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width *
                        (isMobile(context) ? .6 : .3),
                    child: FlatButton(
                        shape: StadiumBorder(),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () async {
                          // if (user.fileUrl ?? "" == "") {
                          //   showToast(context, "File url not found");
                          //   return;
                          // }
                          js.context.callMethod('open', [
                            user.fileUrl ?? "",
                          ]);
                        },
                        child: Text("Scarica il Menù",
                            style: TextStyle(fontSize: 22))),
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: TextField(
                  //     cursorColor: Theme.of(context).cursorColor,
                  //     controller: password,
                  //     obscureText: true,
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       contentPadding:
                  //       EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  //       labelText: "Password",
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 40,
                  //   width: MediaQuery.of(context).size.width *
                  //       (isMobile(context) ? .3 : .15),
                  //   child: FlatButton(
                  //       shape: StadiumBorder(),
                  //       color: Colors.green,
                  //       textColor: Colors.white,
                  //       onPressed: () async {
                  //         if (username.text.length < 1) {
                  //           showToast(context, "Username is empty.");
                  //           return;
                  //         }
                  //         if (password.text.length < 1) {
                  //           showToast(context, "Password is empty.");
                  //           return;
                  //         }
                  //         if (mounted)
                  //           setState(() {
                  //             loading = !loading;
                  //           });
                  //
                  //         FirebaseUser user;
                  //         try {
                  //           user = (await _auth.signInWithEmailAndPassword(
                  //             email: '${username.text}',
                  //             password: '${password.text}',
                  //           ))
                  //               .user;
                  //         } catch (ex) {
                  //           print(ex);
                  //           showToast(context, "Username/Password incorrect.");
                  //         }
                  //         if (mounted)
                  //           setState(() {
                  //             loading = !loading;
                  //           });
                  //         if (user != null) {
                  //           fetchUser(user.uid);
                  //         }
                  //       },
                  //       child: loading
                  //           ? SizedBox(
                  //         width: 24,
                  //         height: 24,
                  //         child: CircularProgressIndicator(
                  //           valueColor:
                  //           AlwaysStoppedAnimation<Color>(Colors.white),
                  //           strokeWidth: 2.0,
                  //         ),
                  //       )
                  //           : Text("Login")),
                  // ),
                  // RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //         text: 'Don\'t have an account?',
                  //         style: TextStyle(color: Colors.black, fontSize: 14),
                  //         children: <TextSpan>[
                  //           TextSpan(
                  //               text: ' Register Now',
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   Navigator.pushReplacementNamed(
                  //                       context, RegistrationScreen.routeName);
                  //                   //  navigateTo(context, RegistrationScreen());
                  //                 },
                  //               style:
                  //               TextStyle(color: Colors.blueAccent, fontSize: 16))
                  //         ]))
                ],
              ),
            ),
    ));
  }
}
