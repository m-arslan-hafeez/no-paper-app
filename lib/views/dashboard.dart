import 'package:flutter/material.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/views/dashboard/custom_question_view.dart';
import 'package:qr_covid/views/dashboard/guest_list_view.dart';
import 'package:qr_covid/views/dashboard/profilo_view.dart';

import '../common.dart';

class Dashboard extends StatefulWidget {
  static String routeName = "/main";
  final UserModel user;
  Dashboard({Key key, this.user}) : super(key: key);

  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  // List<Widget> views = [
  //   ProfiloView(user: widget.user),
  //   GuestListView(),
  //   CustomQuestionView()
  // ];

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
      padding: EdgeInsets.all(16.0),
      child: isMobile(context)
          ? Column(children: [
              Row(children: [
                Image.asset("assets/images/nopaper_512.png",
                    width: 50, height: 50),
                SizedBox(width: isMobile(context) ? 8 : 12),
                Text("NOPAPER",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffff6b6b))),
              ]),
              SizedBox(height: 12),
              InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: selectedIndex == 0 ? Colors.red : Colors.white,
                    child: Text("Profilo", style: TextStyle(fontSize: 24.0)),
                  )),
              SizedBox(height: 8),
              InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: selectedIndex == 1 ? Colors.red : Colors.white,
                    child:
                        Text("Lista Ospiti", style: TextStyle(fontSize: 24.0)),
                  )),
              SizedBox(height: 8),
              InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: selectedIndex == 2 ? Colors.red : Colors.white,
                      child: Text("Domande Dichiarazione",
                          style: TextStyle(fontSize: 18.0)))),
              SizedBox(height: 8),
              Container(
                  height: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.only(left: 4.0, right: 4.0)),
              SizedBox(height: 8),
              Expanded(
                  //  flex: 5,
                  child: [
                ProfiloView(user: widget.user),
                GuestListView(user: widget.user),
                CustomQuestionView(user: widget.user)
              ][selectedIndex])
            ])
          : Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(children: [
                      Image.asset("assets/images/nopaper_512.png",
                          width: 100, height: 100),
                      SizedBox(height: isMobile(context) ? 8 : 12),
                      SizedBox(height: isMobile(context) ? 8 : 12),
                      Text("NOPAPER",
                          style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffff6b6b))),
                      SizedBox(height: 28),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            width: double.infinity,
                            color:
                                selectedIndex == 0 ? Colors.red : Colors.white,
                            child: Text("Profilo",
                                style: TextStyle(fontSize: 24.0)),
                          )),
                      SizedBox(height: 16),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            width: double.infinity,
                            color:
                                selectedIndex == 1 ? Colors.red : Colors.white,
                            child: Text("Lista Ospiti",
                                style: TextStyle(fontSize: 24.0)),
                          )),
                      SizedBox(height: 16),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              width: double.infinity,
                              color: selectedIndex == 2
                                  ? Colors.red
                                  : Colors.white,
                              child: Text("Domande Dichiarazione",
                                  style: TextStyle(fontSize: 18.0))))
                    ])),
                Container(
                    width: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.only(left: 4.0, right: 4.0)),
                Expanded(
                    flex: 5,
                    child: [
                      ProfiloView(user: widget.user),
                      GuestListView(user: widget.user),
                      CustomQuestionView(user: widget.user)
                    ][selectedIndex])
              ],
            ),
    ));
  }
}
