import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_covid/firestore/FirebaseOperations.dart';
import 'package:qr_covid/firestore/FirestoreDB.dart';
import 'package:qr_covid/models/GlobalQuestionModel.dart';
import 'package:qr_covid/models/QuestionModel.dart';
import 'package:qr_covid/models/UserModel.dart';

import '../../common.dart';

class CustomQuestionView extends StatefulWidget {
  final UserModel user;
  CustomQuestionView({Key key, this.user}) : super(key: key);

  @override
  _CustomQuestionViewState createState() {
    return _CustomQuestionViewState();
  }
}

class _CustomQuestionViewState extends State<CustomQuestionView> {
  bool loading = false;
  List<QuestionModel> data = List();
  // List<QuestionModel> data = List();
  GlobalQuestionModel model = GlobalQuestionModel();

  @override
  void initState() {
    super.initState();
    // data.add(QuestionModel());
    //  getQuestions();
    loadQuestions();
  }

  loadQuestions() async {
    data = await FirebaseOperations.firebaseOperations
        .getQuestionByUser(widget.user.uid);

    model = await FirebaseOperations.firebaseOperations
        .getGlobalQuestion(widget.user.uid);

    model.uid = widget.user.uid;
    _selectedIndexString = widget.user.role;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _selectedIndexString = "";
  String _selectedButtonText = "";
  List<String> _options = [
    '  Form Semplice        ',
    '  Form Precompilato    ',
    '  Form Personalizzato  ',
    '  Form Completo        '
  ];
  List<String> _optionString = [
    'Utilizza questo formato se ritieni che hai necessità di raccogliere solo i seguenti dati obbligatori:',
    'utilizza questo formato se vuoi velocizzare la compilazione del form da parte dell’utente che entrerà nella struttura. Raccoglierai i seguenti dati obbligatori:',
    'utilizza questo formato se, invece di utilizzare le condizioni standard (Leggi le condizioni standard qui), vuoi fare delle domande personalizzate in base alle necessità della tua struttura. Attraverso le domande personalizzate puoi ottenere delle risposte “SI/NO” o a testo libero. Puoi anche valutare se, in base alla domanda fatta, una risposta“SI o NO” può vincolare l’accesso alla struttura o meno. Es “Sei stato a contatto con persone positive al COVID negli ultimi 14 giorni?” se l’utente risponde “SI” puoi negarne l’accesso. I dati raccolti obbligatori saranno i seguenti',
    'Utilizza questo formato se vuoi avere una raccolta dati completa di condizioni standard precompilate e domande personalizzate.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _options.length,
                        separatorBuilder: (context, index) {
                          return Container(
                              height: 4,
                              color: Colors.black87,
                              width: double.infinity);
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: SizedBox(
                                        height: 50,
                                        child: FlatButton(
                                            shape: StadiumBorder(),
                                            color: Colors.redAccent,
                                            textColor: Colors.black87,
                                            onPressed: () {
                                              setState(() {
                                                _selectedButtonText =
                                                    _options[index];
                                                _selectedIndexString =
                                                    _options[index]
                                                        .replaceAll(" ", "_")
                                                        .toLowerCase();
                                                makeConfig();
                                              });
                                            },
                                            child: Text(_options[index],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          index == 2
                                              ? RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                      text:
                                                          'utilizza questo formato se, invece di utilizzare le condizioni standard (Leggi le condizioni standard ',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: 'qui',
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("Condizioni Standard"),
                                                                            content:
                                                                                Text(alertText),
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
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                          text:
                                                              '), vuoi fare delle domande personalizzate in base alle necessità della tua struttura. Attraverso le domande personalizzate puoi ottenere delle risposte “SI/NO” o a testolibero. Puoi anche valutare se, in base alla domanda fatta, una risposta“SI o NO” può vincolare l’accesso alla struttura o meno. Es “Sei stato acontatto con persone positive al COVID negli ultimi 14 giorni?” se l’utenterisponde “SI” puoi negarne l’accesso. I dati raccolti obbligatori saranno iseguenti',
                                                        )
                                                      ]))
                                              : Text(
                                                  _optionString[index],
                                                  textAlign: TextAlign.center,
                                                ),
                                          SizedBox(height: 8),
                                          if (index == 0)
                                            Text(
                                              "Nome   Cognome   Numero  di  cellulare",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          if (index == 1 ||
                                              index == 2 ||
                                              index == 3)
                                            Text(
                                              "Nome   Cognome   Numero  di  cellulare   Firma",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          if (index == 2 || index == 3)
                                            Text(
                                              "Domanda 1    Domanda 2   ...   Domanda N",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          if (index == 1 || index == 3)
                                            Text(" "),
                                          if (index == 1 || index == 3)
                                            RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                    text:
                                                        'Accettazione di condizioni standard mediante segno di spunta. Leggi le condizioni standard ',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: ' qui',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueAccent,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        // title: Text("Alert Dialog"),
                                                                        content:
                                                                            Text(alertText),
                                                                        actions: [
                                                                          FlatButton(
                                                                            child:
                                                                                Text("Chiudi"),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                      )
                                                    ])),
                                        ])),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: isMobile(context) ? 8 : 12),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemCount: data.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      TextEditingController edT = TextEditingController();
                      edT.text = data[index].questionText;
                      return Container(
                          //  height: MediaQuery.of(context).size.height * .40,
                          width: MediaQuery.of(context).size.width * .30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text("Testo della domanda :",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .10,
                                  child: TextField(
                                    controller: edT,
                                    onChanged: (value) {
                                      data[index].questionText = value;
                                    },
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(16),
                                        hintText: "Domanda",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38))),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          items: <String>[
                                            'Tipo Risposta',
                                            'Si/No',
                                            'Risposta Aperta'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: Colors.black87)),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            data[index].type = value;
                                            setState(() {});
                                          },
                                          value: data[index].type,
                                          hint: Text("Tipo Risposta"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 32,
                                        child: FlatButton(
                                          shape: StadiumBorder(),
                                          child: Text("Cancella"),
                                          color: Colors.redAccent,
                                          onPressed: () async {
                                            if (data[index].id != null ||
                                                data[index].uid != "") {
                                              await FirebaseOperations
                                                  .firebaseOperations
                                                  .deleteQuestionByUser(
                                                      data[index].id);
                                            }
                                            data.removeAt(index);
                                            setState(() {});
                                          },
                                        ))
                                  ],
                                ),
                                SizedBox(height: 8),
                                if (data[index].type == "Si/No")
                                  Row(children: [
                                    Checkbox(
                                        value: data[index].isRedSemaphore,
                                        onChanged: (value) {
                                          setState(() {
                                            data[index].isRedSemaphore = value;
                                          });
                                        }),
                                    SizedBox(width: 4),
                                    Text(
                                        "Seleziona se la risposta può negare l'accesso alla struttura")
                                  ]),
                                SizedBox(height: 8),
                                if (data[index].isRedSemaphore)
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Indica quale risposta nega l'accesso"),
                                      SizedBox(width: 4),
                                      Row(children: [
                                        Checkbox(
                                            value: data[index].isRisposta,
                                            activeColor: Colors.green,
                                            //   activeColor: ,
                                            onChanged: (value) {
                                              setState(() {
                                                data[index].isRisposta = value;
                                              });
                                            }),
                                        SizedBox(width: 4),
                                        Text("SI."),
                                        SizedBox(width: 4),
                                        Checkbox(
                                            value: !data[index].isRisposta,
                                            activeColor: Colors.green,
                                            onChanged: (value) {
                                              setState(() {
                                                data[index].isRisposta = !value;
                                              });
                                            }),
                                        SizedBox(width: 4),
                                        Text("No.")
                                      ]),
                                    ],
                                  )),
                              ]));
                    }),
                // SizedBox(height: 8),
                // Container(
                //   //  height: MediaQuery.of(context).size.height * .40,
                //   width: MediaQuery.of(context).size.width * .30,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   padding: EdgeInsets.all(16.0), child: Column(children: []),
                // ),
                if (_selectedButtonText != "")
                  Text(
                    "Hai scelto di utilizzare il " + _selectedButtonText,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                Text(""),
                SizedBox(height: 8),
                if (_selectedIndexString ==
                        _options[2].replaceAll(" ", "_").toLowerCase() ||
                    _selectedIndexString ==
                        _options[3].replaceAll(" ", "_").toLowerCase())
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width *
                        (isMobile(context) ? .6 : .3),
                    child: FlatButton(
                        shape: StadiumBorder(),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          data.add(QuestionModel(order: data.length));
                          setState(() {});
                        },
                        child: Text("Aggiungi Domanda")),
                  ),
                SizedBox(height: 80),
              ],
            )),
        floatingActionButton: (_selectedIndexString ==
                    _options[2].replaceAll(" ", "_").toLowerCase() ||
                _selectedIndexString ==
                    _options[3].replaceAll(" ", "_").toLowerCase())
            ? FloatingActionButton.extended(
                onPressed: proceed,
                icon: Icon(Icons.save, color: Colors.white),
                backgroundColor: Colors.orange,
                label: Text('Salva'))
            : FloatingActionButton.extended(
                onPressed: proceed,
                icon: Icon(Icons.save, color: Colors.white),
                backgroundColor: Colors.orange,
                label: Text('Salva')));
  }

  void proceed() async {
    if (_selectedIndexString == "") {
      showToast(context, "Seleziona il tipo di Form desiderato");
      return;
    }
    widget.user.role = _selectedIndexString;

    await FirestoreDb.getInstace()
        .setDocument("global_questions", model, model.uid);
    await FirestoreDb.getInstace()
        .setDocument("users", widget.user, widget.user.uid);

    if (_selectedIndexString ==
        _options[0].replaceAll(" ", "_").toLowerCase()) {
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          if (data[i].id != null)
            await FirebaseOperations.firebaseOperations
                .deleteQuestionByUser(data[i].id);
        }
        data.clear();
        setState(() {});
      }
    } else if (_selectedIndexString ==
        _options[1].replaceAll(" ", "_").toLowerCase()) {
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          if (data[i].id != null)
            await FirebaseOperations.firebaseOperations
                .deleteQuestionByUser(data[i].id);
        }
        data.clear();
        setState(() {});
      }
    }
    for (int i = 0; i < data.length; i++) {
      data[i].uid = widget.user.uid;
      if (data[i].date == "") {
        data[i].date = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
      if (data[i].order == null) {
        data[i].order = i;
      }

      if (data[i].id == null) {
        await FirestoreDb.getInstace().setDocument("questions", data[i], null);
        data[i].id = "${DateTime.now().millisecondsSinceEpoch}";
      }
    }
    showToast(context, "Salvataggio Form avvenuto in maniera corretta");
  }

  void makeConfig() {
    print(_selectedIndexString);

    if (_selectedIndexString ==
        _options[0].replaceAll(" ", "_").toLowerCase()) {
      model.isPrecompilato = false;
      model.isTemperatureEnabled = false;
      model.isSignature = false;
      model.canAddCustomQuestions = false;
    } else if (_selectedIndexString ==
        _options[1].replaceAll(" ", "_").toLowerCase()) {
      model.isPrecompilato = true;
      model.isTemperatureEnabled = true;
      model.isSignature = true;
      model.canAddCustomQuestions = false;
    } else if (_selectedIndexString ==
        _options[2].replaceAll(" ", "_").toLowerCase()) {
      model.isPrecompilato = true;
      model.isTemperatureEnabled = false;
      model.isSignature = true;
      model.canAddCustomQuestions = true;
    } else if (_selectedIndexString ==
        _options[3].replaceAll(" ", "_").toLowerCase()) {
      model.isPrecompilato = true;
      model.isTemperatureEnabled = true;
      model.isSignature = true;
      model.canAddCustomQuestions = true;
    }
  }
}
