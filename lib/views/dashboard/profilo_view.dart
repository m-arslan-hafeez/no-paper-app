import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;
import 'package:printing/printing.dart';
import 'package:qr_covid/firestore/FirestoreDB.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/paypal/PaypalPayment.dart';
import 'package:qr_covid/views/link.dart';
import 'package:qr_covid/views/result_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../common.dart';
import '../login_view.dart';

class ProfiloView extends StatefulWidget {
  final UserModel user;
  ProfiloView({Key key, this.user}) : super(key: key);

  @override
  _ProfiloViewState createState() {
    return _ProfiloViewState();
  }
}

class _ProfiloViewState extends State<ProfiloView> {
  bool loading = false;

  static String appLink = "https://nopaper-paltolab-b3474.web.app/";
  static String appStorageLink = "gs://nopaper-paltolab-b3474.appspot.com/";

  String getFileName(String fn) {
    if (fn.length <= 0) return "Nessun menù caricato";
    var spl = fn.split('2F');
    return spl[1].split('?alt')[0];
  }

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
    return Container(
        child: Stack(
      children: [
        isMobile(context)
            ? ListView(children: [
                userInfoSection(),
                SizedBox(height: 8),
                qrSection(),
                SizedBox(height: 8),
                actionSection()
              ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(child: qrSection()),
                              Expanded(child: actionSection())
                            ],
                          ),
                        ),
                        SizedBox(width: isMobile(context) ? 8 : 12),
                        Expanded(flex: 3, child: userInfoSection())
                      ],
                    ),
                  ),
                ],
              ),
        if (loading)
          Container(
              color: Colors.black87.withOpacity(.50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3))),
      ],
    ));
  }

  static Future<Uri> uploadImageToFirebaseAndShareDownloadUrl(
      MediaInfo info, String attribute1) async {
    try {
      String mimeType = mime(path.basename(info.fileName));
      final extension = extensionFromMime(mimeType);
      var metadata = fb.UploadMetadata(
        contentType: mimeType,
      );
      fb.StorageReference ref = fb.storage().refFromURL('$appStorageLink').child(
          "files/images_${DateTime.now().millisecondsSinceEpoch}.${extension}");
      fb.UploadTask uploadTask = ref.put(info.data, metadata);
      fb.UploadTaskSnapshot taskSnapshot = await uploadTask.future;
      return taskSnapshot.ref.getDownloadURL();
    } catch (ex) {
      print("exe$ex");
      return null;
    }
  }

  bool updateLoading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController vatNumber = TextEditingController();
  TextEditingController responsible = TextEditingController();
  TextEditingController address = TextEditingController();

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  changeProfileData() {
    firstName.text = widget.user.firstName;
    lastName.text = widget.user.lastName;
    email.text = widget.user.email;
    businessName.text = widget.user.businessName;
    vatNumber.text = widget.user.vatNumber;
    responsible.text = widget.user.responsible;
    address.text = widget.user.address;

    setState(() {});

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .80 : .30),
              // height: MediaQuery.of(context).size.height -
              //    (isMobile(context) ? 50 : 100),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white),
              child: Column(
                //padding: EdgeInsets.zero,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Change Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: isMobile(context) ? 16 : 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      cursorColor: Theme.of(context).cursorColor,
                      controller: firstName,
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          labelText: "Responsabile trattamento dati personali",
                          hintText: "Responsabile trattamento dati personali"),
                    ),
                  ),
                  // SizedBox(height: isMobile(context) ? 8 : 8),
                  // SizedBox(
                  //   height: 50,
                  //   child: TextField(
                  //     cursorColor: Theme.of(context).cursorColor,
                  //     controller: email,
                  //     decoration: InputDecoration(
                  //         filled: true,
                  //         contentPadding: EdgeInsets.only(
                  //             left: 16, right: 16, top: 8, bottom: 8),
                  //         labelText:
                  //             "Email del titolare del trattamento dei dati ",
                  //         hintText:
                  //             "Email del titolare del trattamento dei dati "),
                  //   ),
                  // ),
                  // SizedBox(height: isMobile(context) ? 8 : 8),
                  // SizedBox(
                  //   height: 50,
                  //   child: TextField(
                  //     cursorColor: Theme.of(context).cursorColor,
                  //     controller: password,
                  //     obscureText: true,
                  //     decoration: InputDecoration(
                  //         filled: true,
                  //         contentPadding:
                  //         EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  //         labelText: "Password",
                  //         hintText: "Your password"),
                  //   ),
                  // ),
                  // SizedBox(height: isMobile(context) ? 8 : 8),
                  // SizedBox(
                  //   height: 50,
                  //   child: TextField(
                  //     cursorColor: Theme.of(context).cursorColor,
                  //     controller: confirmPassword,
                  //     obscureText: true,
                  //     decoration: InputDecoration(
                  //         filled: true,
                  //         contentPadding:
                  //         EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  //         labelText: "Confirm Password",
                  //         hintText: "Must be same as above"),
                  //   ),
                  // ),
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
                          if (address.text.length < 1) {
                            showToast(context, "Office address is empty.");
                            return;
                          }
                          if (responsible.text.length < 1) {
                            showToast(context, "Responsible is empty.");
                            return;
                          }

                          if (mounted)
                            setState(() {
                              updateLoading = true;
                            });

                          try {
                            UserUpdateInfo userInfo = UserUpdateInfo();
                            userInfo.displayName =
                                firstName.text + " " + lastName.text;
                            //    await user.updateProfile(userInfo);

                            UserModel uModel = widget.user;

                            uModel.firstName = firstName.text;
                            uModel.lastName = lastName.text;
                            uModel.vatNumber = vatNumber.text;
                            //       uModel.email =  email.text;
                            uModel.businessName = businessName.text;
                            uModel.address = address.text;
                            uModel.responsible = responsible.text;

                            // UserModel uModel = UserModel(
                            //     firstName.text,
                            //     lastName.text,
                            //     widget.user.uid,
                            //     vatNumber.text,
                            //     email.text,
                            //     businessName.text,
                            //     address.text,
                            //     responsible.text,
                            //     DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            //     "user",
                            //     "",
                            //     null);

                            await Firestore.instance
                                .collection("users")
                                .document(widget.user.uid)
                                .updateData(uModel.toJson());

                            await FirestoreDb.getInstace()
                                .setDocument("users", uModel, widget.user.uid);
                          } catch (ex) {
                            showToast(context, "User already exist");
                          }

                          if (mounted)
                            setState(() {
                              updateLoading = false;
                            });

                          showToast(context, "Updated Successfully.");
                          Navigator.pop(context);
                        },
                        child: updateLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text("Update Info")),
                  ),
                ],
              ),
            ),
          );
        });
  }

  changePasswordData() {
    firstName.text = widget.user.firstName;
    lastName.text = widget.user.lastName;
    email.text = widget.user.email;

    setState(() {});

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              width: MediaQuery.of(context).size.width *
                  (isMobile(context) ? .80 : .30),
              // height: MediaQuery.of(context).size.height -
              //    (isMobile(context) ? 50 : 100),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white),
              child: Column(
                //padding: EdgeInsets.zero,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Change Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: isMobile(context) ? 16 : 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      cursorColor: Theme.of(context).cursorColor,
                      controller: newPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          labelText: "New Password",
                          hintText: "Your new password"),
                    ),
                  ),
                  SizedBox(height: isMobile(context) ? 8 : 8),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      cursorColor: Theme.of(context).cursorColor,
                      controller: confirmNewPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
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
                          if (newPassword.text.length < 1) {
                            showToast(context, "Password is empty.");
                            return;
                          } else if (newPassword.text.length < 6) {
                            showToast(context,
                                "Password length too short, must have 6 characters.");
                            return;
                          }
                          if (confirmNewPassword.text.length < 1) {
                            showToast(context, "Confirm password is empty.");
                            return;
                          }
                          if (newPassword.text != confirmNewPassword.text) {
                            showToast(context, "Password not match.");
                            return;
                          }

                          if (mounted)
                            setState(() {
                              updateLoading = true;
                            });

                          try {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();

                            //Pass in the password to updatePassword.
                            user
                                .updatePassword(newPassword.text)
                                .then((_) async {
                              UserModel uModel = widget.user;
                              uModel.password = newPassword.text;

                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.user.uid)
                                  .updateData(uModel.toJson());

                              await FirestoreDb.getInstace().setDocument(
                                  "users", uModel, widget.user.uid);

                              showToast(context, "Updated Successfully.");
                              Navigator.pop(context);
                              if (mounted)
                                setState(() {
                                  updateLoading = false;
                                });
                            }).catchError((error) {
                              print("Password can't be changed" +
                                  error.toString());
                              showToast(context, "Error, Please try later.");
                              if (mounted)
                                setState(() {
                                  updateLoading = false;
                                });
                              //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                            });
                          } catch (ex) {}
                        },
                        child: updateLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text("Update Password")),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  Widget userInfoSection() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        //   height: MediaQuery.of(context).size.height * .50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            ]),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                height: 35,
                child: FlatButton.icon(
                    icon: Icon(Icons.lock),
                    color: Color(0xffff6b6b),
                    textColor: Colors.white,
                    onPressed: () async {
                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                      await _firebaseAuth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginView.routeName, (route) => false);
                    },
                    label: Text("Logout")),
              ),
            ]),
            Text("Nome : ${widget.user.firstName}",
                style: TextStyle(fontSize: 24)),
            Text("Cognome : ${widget.user.lastName}",
                style: TextStyle(fontSize: 24)),
            Text("Email : ${widget.user.email}",
                style: TextStyle(fontSize: 24)),
            Text("Password : ${widget.user.password}",
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text("Nome Attività : ${widget.user.businessName}",
                style: TextStyle(fontSize: 24)),
            Text("Partita IVA : ${widget.user.vatNumber}",
                style: TextStyle(fontSize: 24)),
            Text("Indirizzo sede legale : ${widget.user.address}",
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text("Responsabile dei dati personali : ${widget.user.responsible}",
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 35,
                    //   width: 150,
                    child: isMobile(context)
                        ? FlatButton(
                            color: Colors.amber,
                            textColor: Colors.white,
                            onPressed: changeProfileData,
                            child: Text("Change Info"))
                        : FlatButton.icon(
                            icon: Icon(Icons.edit),
                            color: Colors.amber,
                            textColor: Colors.white,
                            onPressed: changeProfileData,
                            label: Text("Change Info")),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    height: 35,
                    //   width: 150,
                    child: isMobile(context)
                        ? FlatButton(
                            color: Color(0xffff6b6b),
                            textColor: Colors.white,
                            onPressed: changePasswordData,
                            child: Text("Change Password"))
                        : FlatButton.icon(
                            icon: Icon(Icons.lock),
                            color: Color(0xffff6b6b),
                            textColor: Colors.white,
                            onPressed: changePasswordData,
                            label: Text("Change Password")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionSection() {
    return Container(
      //  height: MediaQuery.of(context).size.height * .30,
      width: MediaQuery.of(context).size.width * .30,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            )
          ]),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Upload Menu", style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text(
              "E' possibile caricare 1 solo file. \nSe il menù è composto da più pagine è consigliabile creare un unico file PDF. \n",
              style: TextStyle(fontSize: 18)),
          Text("Dimensione Massima 3Mb \n", style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: FlatButton(
                      color: Color(0xffff6b6b),
                      textColor: Colors.white,
                      onPressed: () async {
                        MediaInfo result = await ImagePickerWeb.getImageInfo;
                        if (result != null) {
                          print("result:${result.fileName}");
                          setState(() {
                            loading = true;
                          });
                          try {
                            Uri uri =
                                await uploadImageToFirebaseAndShareDownloadUrl(
                                    result, "");
                            widget.user.fileUrl = uri.toString();
                            await FirestoreDb.getInstace().setDocument(
                                "users", widget.user, widget.user.uid);
                            showToast(context, "File Caricato Correttamente.");
                          } catch (ex) {
                            print("ex${ex}");
                          }
                          setState(() {
                            loading = false;
                          });
                        } else {}
                      },
                      child: Text("Seleziona File")),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(getFileName(widget.user.fileUrl), style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }

  Widget qrSection() {
    return Column(
      children: [
        Center(
          child: QrImage(
            data: "$appLink#/link?id=" + widget.user.uid,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
        SizedBox(height: isMobile(context) ? 8 : 12),
        SizedBox(
          height: 35,
          width: 200,
          child: FlatButton(
              color: Color(0xffff6b6b),
              textColor: Colors.white,
              onPressed: () async {
                final pdf = pw.Document();

                pdf.addPage(pw.MultiPage(
                    pageFormat: PdfPageFormat.a4,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    header: (pw.Context context) {
                      if (context.pageNumber == 1) {
                        return null;
                      }
                      return pw.Container(
                          alignment: pw.Alignment.centerRight,
                          margin: const pw.EdgeInsets.only(
                              bottom: 3.0 * PdfPageFormat.mm),
                          padding: const pw.EdgeInsets.only(
                              bottom: 3.0 * PdfPageFormat.mm),
                          decoration: const pw.BoxDecoration(
                              border: pw.BoxBorder(
                                  bottom: true,
                                  width: 0.5,
                                  color: PdfColors.grey)),
                          child: pw.Text('Portable Document Format',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(color: PdfColors.grey)));
                    },
                    build: (pw.Context context) => <pw.Widget>[
                          pw.Center(
                            child: pw.Paragraph(
                                text: "Your QR",
                                style: pw.TextStyle(fontSize: 18)),
                          ),
                          pw.Center(
                            child: pw.BarcodeWidget(
                              data: "$appLink#/link?id=" + widget.user.uid,
                              width: 150,
                              height: 150,
                              barcode: pw.Barcode.qrCode(),
                            ),
                          ),
                          pw.Padding(padding: const pw.EdgeInsets.all(10)),
                        ]));

                await Printing.sharePdf(
                    bytes: pdf.save(), filename: 'my-document.pdf');
              },
              child: Text("Salva QR Code in PDF")),
        ),
        SizedBox(height: 16),
        Text(
          "Scarica il QR Code per poterlo stampare e metterlo a disposizione dei tuoi clienti",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
