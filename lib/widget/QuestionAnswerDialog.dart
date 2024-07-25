import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_covid/models/InserisciModel.dart';
import 'package:qr_covid/models/QuestionModel.dart';

import '../common.dart';

class QuestionAnswerDialog extends StatefulWidget {
  final InseriscriModel filteredUser;
  final List<QuestionModel> questions1;
  QuestionAnswerDialog({Key key, this.filteredUser, this.questions1})
      : super(key: key);

  @override
  _QuestionAnswerDialogState createState() {
    return _QuestionAnswerDialogState();
  }
}

class _QuestionAnswerDialogState extends State<QuestionAnswerDialog> {
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
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * .40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(children: [
              Text("Nome: ${widget.filteredUser.firstName}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Cognome: ${widget.filteredUser.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Telefono: ${widget.filteredUser.phone}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              //   if(widget.filteredUser.bodyTemp!=0)
              Text("Temperatura Corporea: ${widget.filteredUser.bodyTemp}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Image.memory(base64Decode(widget.filteredUser.signatureValue)),
              SizedBox(height: 4),
            ]),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Container(color: Colors.grey, height: 1),
            SizedBox(height: isMobile(context) ? 8 : 12),
            Expanded(
              child: ListView.separated(
                itemCount: widget.filteredUser.questions.length,
                padding: EdgeInsets.all(0),
                //     shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    SizedBox(height: isMobile(context) ? 8 : 12),
                itemBuilder: (context, index) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Q${index + 1}: ${widget.filteredUser.questions[index].questionText}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                            "Tipologia: ${widget.filteredUser.questions[index].type}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 4),
                        Text(
                            "Risposta: ${widget.filteredUser.questions[index].answer}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        ((widget.filteredUser.questions[index].answer == "Si" &&
                                    widget.filteredUser.questions[index]
                                        .isRisposta) ||
                                (widget.filteredUser.questions[index].answer ==
                                        "No" &&
                                    !widget.filteredUser.questions[index]
                                        .isRisposta))
                            ? Text("Stato: VERDE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12))
                            : Text("Stato: ROSSO",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12))
                      ]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
