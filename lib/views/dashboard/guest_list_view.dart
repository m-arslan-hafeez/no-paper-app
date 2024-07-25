import 'package:flutter/material.dart';
import 'package:qr_covid/firestore/FirebaseOperations.dart';
import 'package:qr_covid/models/InserisciModel.dart';
import 'package:qr_covid/models/QuestionModel.dart';
import 'package:qr_covid/models/QuestionUserModel.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/widget/QuestionAnswerDialog.dart';

class GuestListView extends StatefulWidget {
  final UserModel user;
  GuestListView({Key key, this.user}) : super(key: key);

  @override
  _GuestListViewState createState() {
    return _GuestListViewState();
  }
}

class _GuestListViewState extends State<GuestListView> {
  List<InseriscriModel> users = List();
  List<InseriscriModel> filteredUsers = List();
  List<QuestionModel> questions = List();
  String filterText = "";
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    try {
      users = await FirebaseOperations.getInstance()
          .getQuestionUsers(widget.user.uid);
      questions = await FirebaseOperations.getInstance()
          .getQuestionByUser(widget.user.uid);
      filteredUsers = users;

      // for (int i = 0; i < filteredUsers.length; i++) {
      //   for (int t = 0; t < filteredUsers[i].questions.length; t++) {
      //     for (int k = 0; k < questions.length; k++) {
      //       if (filteredUsers[i].questions[t].questionText ==
      //           questions[k].questionText) {
      //       } else {
      //         filteredUsers[i].questions[t].answer = "q1Try";
      //       }
      //     }
      //   }
      // }

      // for (int t = 0; t < questions.length; t++)
      //   DataCell(Text(
      //       getAnswer(filteredUsers[i].questions, questions[t].id) )),
      //
      // for (int i = 0; i < filteredUsers.length; i++) {
      //   //  filteredUsers[i].questions =
      //
      //   filteredUsers[i]
      //       .questions
      //       .removeWhere((element) => element.answer == "q1Try");
      // }

      // filteredUsers.forEach((element) {
      //
      //   var bav = element.questions.
      //
      // });

      if (mounted)
        setState(() {
          //sectionLoading = false;
        });
    } catch (ex) {
      // if (mounted)
      //   setState(() {
      //     sectionLoading = false;
      //   });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(children: [
              // Text("Search"),
              // SizedBox(width: 16.0),
              SizedBox(
                height: 40,
                width: 200,
                child: TextField(
                  onChanged: (value) {
                    filteredUsers = users
                        .where((element) => element.firstName
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38))),
                ),
              )
            ]),
          ),
          SizedBox(height: 16),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                sortAscending: sort,
                sortColumnIndex: columnIndex,
                columns: [
                  DataColumn(onSort: onSortColumn, label: Text("Data")),
                  DataColumn(onSort: onSortColumn, label: Text("Cognome")),
                  DataColumn(onSort: onSortColumn, label: Text("Nome")),

                  // for (int i = 0; i < questions.length; i++)
                  //   DataColumn(label: Text(questions[i].questionText)),
                ],
                rows: [
                  for (int i = 0; i < filteredUsers.length; i++)
                    DataRow(
                        onSelectChanged: (value) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return QuestionAnswerDialog(
                                    filteredUser: filteredUsers[i]);
                              });
                        },
                        cells: [
                          DataCell(Text(filteredUsers[i].date)),
                          DataCell(Text(filteredUsers[i].lastName)),
                          DataCell(Text(filteredUsers[i].firstName)),

                          // for (int t = 0; t < questions.length; t++)
                          //   DataCell(Text(
                          //       getAnswer(filteredUsers[i].questions, questions[t].id))),

                          // for (int k = 0; k < filteredUsers[i].questions.length; k++)
                          //   DataCell(Text(filteredUsers[i].questions[k].answer ?? "")),
                        ])
                ]),
          ))
        ]));
  }

  bool sort = true;
  int columnIndex = 0;
  onSortColumn(int columnIndex, bool ascending) {
    sort = !sort;
    if (this.columnIndex == columnIndex) {
    } else {
      this.columnIndex = columnIndex;
      sort = true;
    }
    this.columnIndex = columnIndex;
    if (columnIndex == 0) {
      if (ascending) {
        filteredUsers.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        filteredUsers.sort((a, b) => b.firstName.compareTo(a.firstName));
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        filteredUsers.sort((a, b) => a.lastName.compareTo(b.lastName));
      } else {
        filteredUsers.sort((a, b) => b.lastName.compareTo(a.lastName));
      }
    } else if (columnIndex == 2) {
      if (ascending) {
        filteredUsers.sort((a, b) => a.date.compareTo(b.date));
      } else {
        filteredUsers.sort((a, b) => b.date.compareTo(a.date));
      }
    }
    setState(() {});
  }

  String getAnswer(List<QuestionModel> list, String id) {
    try {
      QuestionModel question = list.firstWhere((question) => question.id == id);
      return question == null ? "" : question.answer;
    } catch (ex) {
      return "";
    }
  }
}
