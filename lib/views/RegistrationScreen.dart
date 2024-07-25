import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_covid/firestore/FirestoreDB.dart';
import 'package:qr_covid/models/UserModel.dart';

import '../common.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = "/registration";
  RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool loading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController vatNumber = TextEditingController();
  TextEditingController responsible = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
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
      child: Container(
        width:
            MediaQuery.of(context).size.width * (isMobile(context) ? .80 : .30),
        height:
            MediaQuery.of(context).size.height - (isMobile(context) ? 50 : 100),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0), color: Colors.white),
        child: ListView(
          padding: EdgeInsets.zero,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/nopaper_512.png",
                width: 100, height: 100),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Text("NOPAPER",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: isMobile(context) ? 16 : 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Text("Registrazione",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: firstName,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Nome",
                    hintText: "Nome"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: lastName,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Cognome",
                    hintText: "Cognome"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: businessName,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText:
                        "Nome attività commerciale/alberghiera o azienda sanitaria",
                    hintText:
                        "Nome attività commerciale/alberghiera o azienda sanitaria"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: vatNumber,
                inputFormatters: [
                  new WhitelistingTextInputFormatter(RegExp("[0-9]"))
                ],
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Partita IVA o codice fiscale",
                    hintText: "Partita IVA o codice fiscale"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: address,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Indirizzo della sede legale ",
                    hintText: "Indirizzo della sede legale "),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: responsible,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Responsabile trattamento dati personali",
                    hintText: "Responsabile trattamento dati personali"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: email,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Email del titolare del trattamento dei dati ",
                    hintText: "Email del titolare del trattamento dei dati "),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
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
                    hintText: "Your password"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 50,
              child: TextField(
                cursorColor: Theme.of(context).cursorColor,
                controller: confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    labelText: "Confirm Password",
                    hintText: "Must be same as above"),
              ),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .3 : .15),
              child: FlatButton(
                  shape: StadiumBorder(),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (firstName.text.length < 1) {
                      showToast(context, "First name is empty.");
                      return;
                    }
                    if (lastName.text.length < 1) {
                      showToast(context, "Surname is empty.");
                      return;
                    }
                    if (email.text.length < 1) {
                      showToast(context, "Email is empty.");
                      return;
                    }
                    if (!isEmail(email.text)) {
                      showToast(context, "Email is not correct.");
                      return;
                    }
                    if (businessName.text.length < 1) {
                      showToast(context, "Business name is empty.");
                      return;
                    }
                    if (vatNumber.text.length < 1) {
                      showToast(context, "VAT number is empty.");
                      return;
                    }
                    else if (vatNumber.text.length < 1) {
                      showToast(context, "VAT number is empty.");
                      return;
                    }
                    if (address.text.length < 1) {
                      showToast(context, "Office address is empty.");
                      return;
                    }
                    if (responsible.text.length < 1) {
                      showToast(context, "Responsible is empty.");
                      return;
                    }
                    if (password.text.length < 1) {
                      showToast(context, "Password is empty.");
                      return;
                    } else if (password.text.length < 6) {
                      showToast(context,
                          "Password length too short, must have 6 characters.");
                      return;
                    }
                    if (confirmPassword.text.length < 1) {
                      showToast(context, "Confirm password is empty.");
                      return;
                    }
                    if (password.text != confirmPassword.text) {
                      showToast(context, "Password not match.");
                      return;
                    }
                    if (mounted)
                      setState(() {
                        loading = true;
                      });
                    FirebaseUser user;
                    try {
                      user = (await _auth.createUserWithEmailAndPassword(
                        email: '${email.text}',
                        password: '${password.text}',
                      ))
                          .user;
                      UserUpdateInfo userInfo = UserUpdateInfo();
                      userInfo.displayName =
                          firstName.text + " " + lastName.text;
                      await user.updateProfile(userInfo);

                      UserModel uModel = UserModel(
                          firstName.text,
                          lastName.text,
                          user.uid,
                          vatNumber.text,
                          email.text,
                          businessName.text,
                          address.text,
                          responsible.text,
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          "user",
                          password.text,
                          "",
                          null);
                      await FirestoreDb.getInstace()
                          .setDocument("users", uModel, user.uid);
                    } catch (ex) {
                      showToast(context, "User already exist");
                    }

                    if (mounted)
                      setState(() {
                        loading = false;
                      });
                    if (user != null) {
                      showToast(context, "Registered Successfully.");
                      Navigator.pop(context);
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
                      : Text("Registrazione")),
            ),
            SizedBox(height: isMobile(context) ? 8 : 8),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Hai già un account ?',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Effettua il Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 16))
                    ]))
          ],
        ),
      ),
    ));
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
