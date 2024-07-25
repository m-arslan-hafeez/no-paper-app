import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:qr_covid/models/GlobalQuestionModel.dart';
import 'package:qr_covid/models/InserisciModel.dart';
import 'package:qr_covid/widget/QuestionAnswerDialog.dart';
import 'dart:ui' as ui;
import '../common.dart';
import 'package:pdf/pdf.dart';

class ResultView extends StatefulWidget {
  static String routeName = "/result";
  List<InseriscriModel> data;
  GlobalQuestionModel model;

  ResultView({Key key, this.data, this.model}) : super(key: key);

  @override
  _ResultViewState createState() {
    return _ResultViewState();
  }
}

class _ResultViewState extends State<ResultView> {
  List<Result> resultList = List();
  @override
  void initState() {
    super.initState();
//    resultList.add(Result("Siaknder", true));
//    resultList.add(Result("Siaknder asf", false));

    calculateResults();
  }

  calculateResults() {
    for (int i = 0; i < widget.data.length; i++) {
      bool tag = false;
      for (int t = 0; t < widget.data[i].questions.length; t++) {
        if (widget.data[i].questions[t].type == "Si/No") {
          if (widget.data[i].questions[t].answer == "Yes" &&
              widget.data[i].questions[t].isRisposta) {
            tag = true;
          } else if (widget.data[i].questions[t].answer == "No" &&
              !widget.data[i].questions[t].isRisposta) {
            tag = true;
          } else {
            tag = false;
          }
        }
      }
      resultList
          .add(Result(widget.data[i].firstName + widget.data[i].lastName, tag));
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  static GlobalKey screen = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: RepaintBoundary(
          key: screen,
          child: Container(
              width: MediaQuery.of(context).size.width *
                  (isMobile(context)
                      ? isTablet(context)
                          ? 0.6
                          : .80
                      : .30),
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
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
              alignment: Alignment.center,
              child: ListView(
                //cross: MainAxisAlignment.center,
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
                  Image.asset(
                    "assets/images/semaforo.jpg",
                    width: 300,
                    //  height: 200,
                  ),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemCount: resultList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return QuestionAnswerDialog(
                                      filteredUser: widget.data[index]);
                                });
                          },
                          child: Container(
                            //   width: 300,
                            alignment: Alignment.center,
                            child: Container(
                              width: 250,
                              child: Column(
                                children: [
                                  Row(
                                      //  mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: resultList[index].result
                                                  ? Colors.green
                                                  : Colors.redAccent),
                                        ),
                                        SizedBox(width: 8),
                                        Text(resultList[index].name,
                                            style: TextStyle(fontSize: 16.0))
                                      ]),
                                  SizedBox(width: 8),
                                  if (!resultList[index].result)
                                    Text(
                                        "In base alle risposte date non puoi accedere alla struttura. Rivolgiti ad un operatore per chiarimenti.",
                                        style: TextStyle(fontSize: 16.0))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: isMobile(context) ? 8 : 12),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width *
                        (isMobile(context) ? .6 : .3),
                    child: FlatButton(
                        shape: StadiumBorder(),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: ScreenShot,
                        child: Text("Take Screenshot")),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  ScreenShot() async {
    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();

    print(image);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List audioUint8List = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

    final pdf = pw.Document();
    final image12 = PdfImage.file(pdf.document, bytes: audioUint8List);
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: pw.Text('Portable Document Format',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.Center(
                child: pw.Paragraph(
                    text: "ScreenShot", style: pw.TextStyle(fontSize: 18)),
              ),
              pw.Center(child: pw.Image(image12)),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ]));

    await Printing.sharePdf(bytes: pdf.save(), filename: 'my-screenshot.pdf');
  }
}

class Result {
  String name;
  bool result;
  Result(this.name, this.result);
}
