import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../common.dart';
import 'dart:ui' as ui;

class SignaturePadDialog extends StatefulWidget {
  final Function(String) onSave;
  SignaturePadDialog({Key key, this.onSave}) : super(key: key);

  @override
  _SignaturePadDialogState createState() {
    return _SignaturePadDialogState();
  }
}

class _SignaturePadDialogState extends State<SignaturePadDialog> {
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Uint8List image = null;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: [
              Text("Firma Obbligatoria",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 4),
              Container(
                  width: 300,
                  height: 200,
                  child: SfSignaturePad(
                      key: signatureGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      minimumStrokeWidth: 1.0,
                      maximumStrokeWidth: 4.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey))),
              SizedBox(height: isMobile(context) ? 8 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 35,
                    child: FlatButton.icon(
                        icon: Icon(Icons.save),
                        color: Color(0xffff6b6b),
                        textColor: Colors.white,
                        onPressed: () async {
                          final canvas =
                              html.CanvasElement(width: 280, height: 190);
                          final context = canvas.context2D;

                          //Get the signature in the canvas context
                          signatureGlobalKey.currentState
                              .renderToContext2D(context);

                          //Get the image from the canvas context
                          final blob = await canvas.toBlob('image/jpeg', 1.0);
                          final completer = Completer<Uint8List>();
                          final reader = html.FileReader();
                          reader.readAsArrayBuffer(blob);
                          reader.onLoad
                              .listen((_) => completer.complete(reader.result));
                          Uint8List imageData = await completer.future;

                          String imgData = base64Encode(imageData);
                          widget.onSave(imgData);
                          //image = base64Decode(image1);

                          //   setState(() {});
                        },
                        label: Text("Save")),
                  ),
                  SizedBox(
                    height: 35,
                    child: FlatButton.icon(
                        icon: Icon(Icons.clear),
                        color: Colors.amber,
                        textColor: Colors.white,
                        onPressed: () {
                          signatureGlobalKey.currentState.clear();
                        },
                        label: Text("Clear")),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // static Future<Uri> uploadImageToFirebaseAndShareDownloadUrl(
  //     MediaInfo info, String attribute1) async {
  //   try {
  //     String mimeType = mime(path.basename(info.fileName));
  //     final extension = extensionFromMime(mimeType);
  //     var metadata = fb.UploadMetadata(
  //       contentType: mimeType,
  //     );
  //     fb.StorageReference ref = fb.storage().refFromURL('$appStorageLink').child(
  //         "files/images_${DateTime.now().millisecondsSinceEpoch}.${extension}");
  //     fb.UploadTask uploadTask = ref.put(info.data, metadata);
  //     fb.UploadTaskSnapshot taskSnapshot = await uploadTask.future;
  //     return taskSnapshot.ref.getDownloadURL();
  //   } catch (ex) {
  //     print("exe$ex");
  //     return null;
  //   }
  // }
}
