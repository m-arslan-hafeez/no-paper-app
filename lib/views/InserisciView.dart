import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_covid/firestore/FirebaseOperations.dart';
import 'package:qr_covid/firestore/FirestoreDB.dart';
import 'package:qr_covid/models/GlobalQuestionModel.dart';
import 'package:qr_covid/models/InserisciModel.dart';
import 'package:qr_covid/models/QuestionModel.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:qr_covid/views/result_view.dart';
import 'package:qr_covid/widget/SignaturePadDialog.dart';

import '../common.dart';

class Inserisciview extends StatefulWidget {
  static String routeName = "/inserisci";
  UserModel user;
  Inserisciview({Key key, this.user}) : super(key: key);

  @override
  _InserisciviewState createState() {
    return _InserisciviewState();
  }
}

class _InserisciviewState extends State<Inserisciview> {
  int listSize = 1;
  bool loading = false;
  List<InseriscriModel> data = List();
  List<QuestionModel> questions = List();
  GlobalQuestionModel model = GlobalQuestionModel();
  @override
  void initState() {
    super.initState();

    loadQuestions();
  }

  loadQuestions() async {
    questions = await FirebaseOperations.firebaseOperations
        .getQuestionByUser(widget.user.uid);
    data.add(InseriscriModel(questions: questions));

    model = await FirebaseOperations.firebaseOperations
        .getGlobalQuestion(widget.user.uid);
    setState(() {});
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
            child: ListView(
              children: [
                if (model.isPrecompilato)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Text(alertText),
                  ),
                SizedBox(height: 8),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                          //  height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.width * .30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: isMobile(context) ? 8 : 12),
                                Text("Persona ${index + 1}",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: isMobile(context) ? 16 : 24,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: isMobile(context) ? 8 : 12),
                                SizedBox(
                                  //  height: 50,
                                  child: TextField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      data[index].firstName = value;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(16),
                                        hintText: "Nome",
                                        errorText:
                                            data[index].firstName.length < 1
                                                ? 'Il campo Nome è vuoto.'
                                                : null,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38))),
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  // height: 50,
                                  child: TextField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      data[index].lastName = value;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(16),
                                        hintText: "Cognome",
                                        errorText:
                                            data[index].lastName.length < 1
                                                ? 'Il campo Cognome è vuoto.'
                                                : null,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38))),
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  // height: 50,
                                  child: TextField(
                                    inputFormatters: [
                                      new WhitelistingTextInputFormatter(
                                          RegExp("[0-9]"))
                                    ],
                                    onChanged: (value) {
                                      data[index].phone = value;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(16),
                                        hintText: "Telefono",
                                        errorText: data[index].phone.length < 1
                                            ? 'IIl campo Telefono è vuoto.'
                                            : null,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38))),
                                  ),
                                ),
                                // SizedBox(height: 8),
                                // SizedBox(
                                //   height: 50,
                                //   child: TextField(
                                //     onChanged: (value) {
                                //       data[index].email = value;
                                //     },
                                //     maxLines: 1,
                                //     decoration: InputDecoration(
                                //         contentPadding: EdgeInsets.all(16),
                                //         hintText: "Email",
                                //         border: OutlineInputBorder(
                                //             borderSide: BorderSide(
                                //                 color: Colors.black38))),
                                //   ),
                                // ),
                                SizedBox(height: 8),
                                if (model.isTemperatureEnabled)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Temperatura Corporea",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: isMobile(context)
                                                    ? 14
                                                    : 16)),
                                        SizedBox(height: 4),

                                        Row(
                                          children: [
                                            Checkbox(
                                              value: data[index].bodyTemp != 0,
                                              onChanged: (value) {
                                                if (data[index].bodyTemp == 0) {
                                                  data[index].bodyTemp = 1;
                                                } else {
                                                  data[index].bodyTemp = 0;
                                                }
                                                setState(() {});
                                              },
                                            ),
                                            Text(
                                                "Dichiaro di avere una temperatura corporea inferiore a 37.5 °C")
                                          ],
                                        ),

                                        //
                                        // Row(
                                        //   children: [
                                        //     Text("34",
                                        //         style: TextStyle(
                                        //             color: Colors.black87)),
                                        //     Expanded(
                                        //       child: Slider(
                                        //         max: 40,
                                        //         min: 35,
                                        //         divisions: 45 - 34,
                                        //         label:
                                        //             '${data[index].bodyTemp.toStringAsFixed(1)}',
                                        //         value: data[index].bodyTemp == 0
                                        //             ? 35
                                        //             : data[index].bodyTemp,
                                        //         onChanged: (val) {
                                        //           if (data[index].bodyTemp ==
                                        //               val) {
                                        //             return;
                                        //           }
                                        //           data[index].bodyTemp = val;
                                        //           setState(() {});
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Text("45",
                                        //         style: TextStyle(
                                        //             color: Colors.black87)),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),

                                SizedBox(height: 8),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(0),
                                  itemCount: data[index].questions.length,
                                  itemBuilder: (context, ind) {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data[index]
                                              .questions[ind]
                                              .questionText),
                                          SizedBox(height: 4),
                                          if (data[index].questions[ind].type ==
                                              "Si/No")
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Radio(
                                                  value: "Yes",
                                                  groupValue: data[index]
                                                      .questions[ind]
                                                      .answer,
                                                  onChanged: (value) {
                                                    data[index]
                                                        .questions[ind]
                                                        .answer = value;
                                                    setState(() {});
                                                  },
                                                ),
                                                Text(
                                                  'SI',
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                                Radio(
                                                  value: "No",
                                                  groupValue: data[index]
                                                      .questions[ind]
                                                      .answer,
                                                  onChanged: (value) {
                                                    data[index]
                                                        .questions[ind]
                                                        .answer = value;
                                                    setState(() {});
                                                  },
                                                ),
                                                Text(
                                                  'No',
                                                  style: new TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          if (data[index].questions[ind].type ==
                                              "Risposta Aperta")
                                            SizedBox(
                                              // height: 40,
                                              child: TextField(
                                                onChanged: (value) {
                                                  data[index]
                                                      .questions[ind]
                                                      .answer = value;
                                                },
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(16),
                                                    hintText: "Risposta",
                                                    errorText: data[index]
                                                                .questions[ind]
                                                                .answer
                                                                .length <
                                                            1
                                                        ? 'Rispondere a tutte le domande prima di Inserire i dati'
                                                        : null,
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black38))),
                                              ),
                                            ),
                                        ]);
                                  },
                                ),
                                SizedBox(height: 8),

                                if (model.isSignature)
                                  SizedBox(
                                    height: 35,
                                    child: FlatButton(
                                        //  icon: Icon(Icons.lock),
                                        color: Color(0xffff6b6b),
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SignaturePadDialog(
                                                  onSave: (imgData) {
                                                    data[index].signatureValue =
                                                        imgData;
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              });
                                        },
                                        child: Text("Firma Obbligatoria")),
                                  ),

                                // SizedBox(
                                //   height: 50,
                                //   child: TextField(
                                //     onChanged: (value) {
                                //       data[index].signatureValue = value;
                                //     },
                                //     maxLines: 1,
                                //     decoration: InputDecoration(
                                //         contentPadding: EdgeInsets.all(16),
                                //         hintText: "Firma Obbligatoria",
                                //         border: OutlineInputBorder(
                                //             borderSide: BorderSide(
                                //                 color: Colors.black38))),
                                //   ),
                                // ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: data[index].isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          data[index].isCheck = value;
                                        });
                                      },
                                    ),
                                    Text(
                                        '''Dichiaro sotto la mia responsabilità 
                                            che tutti i dati inseriti 
                                            corrispondono a verità''')
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      height: 32,
                                      child: FlatButton(
                                        shape: StadiumBorder(),
                                        child: Text("Cancella"),
                                        color: Colors.redAccent,
                                        onPressed: () async {
                                          data.removeAt(index);
                                          setState(() {});
                                        },
                                      )),
                                )

                                // SizedBox(height: 8),
                                // Text(
                                //     "Form correttamente compilato. Mostrare questa schermata all’entrata.Nel caso in cui l ingresso non sia immediato si consiglia di effettuare uno screenshoot"),
                                // SizedBox(height: 8),
                                // Text(
                                //     "Form correttamente compilato. Chiedi informazioni all’entrata.Nel caso in cui l’ingresso non sia immediato si consiglia di effettuare uno screenshoot")
                                //
                              ]));
                    }),
                SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width *
                      (isMobile(context) ? .6 : .3),
                  child: FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: proceed,
                      child: Text(" Inserisci i dati")),
                ),
                SizedBox(height: 8),
                SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Privacy/Cookies Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blueAccent,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          // title: Text("Alert Dialog"),
                                          content: Text(privacyText),
                                          actions: [
                                            FlatButton(
                                              child: Text("Chiudi"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                            )),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blueAccent,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ))
                      ],
                    )),
                SizedBox(height: 64),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              listSize = listSize + 1;
              data.add(InseriscriModel(questions: questions));
              setState(() {});
            },
            icon: Icon(Icons.add, color: Colors.black87),
            backgroundColor: Colors.orange,
            label: Text('Aggiungi Persona')));
  }

  void proceed() async {
    if (data.length == 0) {
      showToast(context, "Please add some form.");
      return;
    }

    setState(() {});

    bool tag = false;
    for (int i = 0; i < data.length; i++) {
      if (data[i].firstName.length == 0) {
        // showToast(context, "Il campo Nome è vuoto.");
        tag = true;
        break;
      } else if (data[i].lastName.length == 0) {
        //showToast(context, "Il campo Cognome è vuoto.");
        tag = true;
        break;
      } else if (data[i].phone.length == 0) {
        //  showToast(context, "Il campo Telefono è vuoto.");
        tag = true;
        break;
        // } else if (data[i].email.length == 0) {
        //   showToast(context, "Il campo Email è vuoto.");
        //   tag = true;
        //   break;
        // } else if (!isEmail(data[i].email)) {
        //   showToast(context, "Il campo Email non è valido.");
        //   tag = true;
        //   break;
      } else if (model.isTemperatureEnabled && data[i].bodyTemp == 0.0) {
        showToast(context, "Il campo Temperatura Corporea è vuoto");
        tag = true;
        break;
      } else if (model.isSignature && data[i].signatureValue.length == 0) {
        showToast(context, "Il campo Firma è vuoto");
        tag = true;
        break;
      }

      for (int t = 0; t < data[i].questions.length; t++) {
        if ((data[i].questions[t].type == "Si/No" ||
                data[i].questions[t].type == "Risposta Aperta") &&
            data[i].questions[t].answer.length == 0) {
          // showToast(context,
          //     "Rispondere a tutte le domande prima di Inserire i dati");
          tag = true;
          break;
        }
      }
    }
    if (tag) {
      return;
    }
    bool isOk = false;
    for (int i = 0; i < data.length; i++) {
      if (!data[i].isCheck) {
        isOk = true;
        break;
      }
    }

    if (isOk) {
      showToast(context,
          "Non puoi inserire di dati se non hai accettato tutte le condizioni.");
      return;
    }

    for (int i = 0; i < data.length; i++) {
      data[i].uid = widget.user.id;
      data[i].date = DateFormat('dd/MM/yyyy').format(DateTime.now());

      // if (data[i].isCheck) {
      await FirestoreDb.getInstace()
          .setDocument("question_users", data[i], null);
      //}
    }
    showToast(context, "Data Saved.");

    Map<String, Object> mapData = {"model": model, "data": data};

    Navigator.pushReplacementNamed(context, ResultView.routeName,
        arguments: mapData);
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
