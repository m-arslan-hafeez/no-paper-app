import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_covid/firestore/FirebaseOperations.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/views/RegistrationScreen.dart';
import 'package:qr_covid/views/dashboard.dart';

import '../common.dart';

class LoginView extends StatefulWidget {
  static String routeName = "/login";
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView> {
  bool loading = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkLoginStatus() async {
    FirebaseAuth.instance.currentUser().then((user) async {
      if (user != null) {
        fetchUser(user.uid);
      }
    });
  }

  void fetchUser(String uid) async {
    UserModel uModel = await FirebaseOperations.getInstance().getUser(uid);
    Navigator.pushNamedAndRemoveUntil(
        context, Dashboard.routeName, (route) => false,
        arguments: uModel);
    // replaceTo(context, Dashboard(user: uModel));
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
      child: Container(
        width:
            MediaQuery.of(context).size.width * (isMobile(context) ? isTablet(context) ?  0.6:.80 : .30),
        height: MediaQuery.of(context).size.height *
            (isMobile(context) ? isTablet(context) ?  0.6:.70  : .70),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/nopaper_512.png",
                width: 100, height: 100),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Text("NOPAPER",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: isMobile(context) ? 16 : 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Text("Login",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: username,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  labelText: "Email",
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .3 : .15),
              child: FlatButton(
                  shape: StadiumBorder(),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (username.text.length < 1) {
                      showToast(context, "Email is empty.");
                      return;
                    }
                    if (password.text.length < 1) {
                      showToast(context, "Password is empty.");
                      return;
                    }
                    if (mounted)
                      setState(() {
                        loading = !loading;
                      });

                    FirebaseUser user;
                    try {
                      user = (await _auth.signInWithEmailAndPassword(
                        email: '${username.text}',
                        password: '${password.text}',
                      ))
                          .user;
                    } catch (ex) {
                      print(ex);
                      showToast(context, "Email/Password incorrect.");
                    }
                    if (mounted)
                      setState(() {
                        loading = !loading;
                      });
                    if (user != null) {
                      fetchUser(user.uid);
                    }
                  },
                  child: loading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text("Login")),
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Non hai un account ?',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Registrati subito',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, RegistrationScreen.routeName);
                              //  navigateTo(context, RegistrationScreen());
                            },
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16))
                    ]))
          ],
        ),
      ),
    ));
  }
}
