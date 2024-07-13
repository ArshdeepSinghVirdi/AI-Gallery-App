import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

import 'LensView.dart';

class ViewerPage extends StatefulWidget {
  Medium medium;
  ViewerPage(this.medium);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  GlobalKey<SignatureState> sState = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImageFile();
  }

  File? imageFile;
  img.Image? originalImage;
  loadImageFile() async {
    imageFile = await this.widget.medium.getFile();

    final bytes = imageFile!.readAsBytesSync();
    originalImage = img.decodeImage(bytes!);
    setState(() {
      imageFile;
    });
  }

  img.Image? croppedImage;
  Offset topLeft = Offset.zero;
  Offset rightBottom = Offset.zero;

  Offset topLeft0 = Offset.zero;
  Offset rightBottom0 = Offset.zero;
  cropImage() {
    // final bytes = imageFile!.readAsBytesSync();
    // img.Image? cImage = img.decodeImage(bytes!);

    var points = sState.currentState!.points;
    final size = sState.currentContext!.size;
    final scaleX = originalImage!.width / size!.width;
    final scaleY = originalImage!.height / size.height;
    points = points.map((e) {
      if (e != null) {
        return Offset(e.dx * scaleX, e.dy * scaleY);
      }
    }).toList();

    if (points != null) {
      topLeft = points[0]!;
      rightBottom = points[0]!;

      for (var i = 0; i < points.length; i++) {
        if (points[i] != null) {
          Offset point = points[i]!;
          if (point.dx < topLeft.dx) {
            topLeft = Offset(point.dx, topLeft.dy);
          }

          if (point.dy < topLeft.dy) {
            topLeft = Offset(topLeft.dx, point.dy);
          }

          if (point.dx > rightBottom.dx) {
            rightBottom = Offset(point.dx, rightBottom.dy);
          }

          if (point.dy > rightBottom.dy) {
            rightBottom = Offset(rightBottom.dx, point.dy);
          }
        }
      }

      topLeft0 = Offset(topLeft.dx / scaleX, topLeft.dy / scaleY);
      rightBottom0 = Offset(rightBottom.dx / scaleX, rightBottom.dy / scaleY);

      croppedImage = img.copyCrop(originalImage!,
          x: topLeft.dx.toInt(),
          y: topLeft.dy.toInt(),
          width: (rightBottom.dx - topLeft.dx).toInt(),
          height: (rightBottom.dy - topLeft.dy).toInt());

      sState = GlobalKey();
      points.clear();

      setState(() {
        croppedImage;
      });
      uploadCroppedImage();
    }
  }

  uploadCroppedImage() async {
    final bytes = img.encodePng(croppedImage!);
    final tempDire = await Directory.systemTemp.createTemp();
    final tempFile = await File(tempDire.path + "temp.png").writeAsBytes(bytes);

    final apiKey = "a020990f28d8b2fe3d78053e3830f404";
    final url =
        Uri.parse("https://api.imgbb.com/1/upload?expiration=100&key=$apiKey");
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath("image", tempFile.path));

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseString);
    final imageUrl = jsonResponse['data']['display_url'];
    print(imageUrl);

    final searchUrl = 'https://lens.google.com/uploadbyurl?url=$imageUrl';
    print(searchUrl);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LensView(searchUrl);
    }));
  }

  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.medium.filename.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: Uint8List.fromList(img
                        .encodePng(originalImage!)), // <-- Uint8List of image
                  ),
                ),
              ).then((value) async {
                if (value != null) {
                  setState(() {
                    originalImage = img.decodeImage(value);
                  });
                  final result = await ImageGallerySaver.saveImage(value);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (isEnabled) {
                  isEnabled = false;
                } else {
                  isEnabled = true;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(isEnabled
                  ? Icons.remove_red_eye_sharp
                  : Icons.remove_red_eye_outlined),
            ),
          )
        ],
      ),
      body: InkWell(
        onLongPress: () {
          setState(() {
            if (isEnabled) {
              isEnabled = false;
            } else {
              isEnabled = true;
            }
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 100,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child:
                  // croppedImage != null
                  //     ? Image.memory(Uint8List.fromList(img.encodePng(croppedImage!)))
                  //     :
                  Stack(
                children: [
                  // originalImage != null
                  //     ? Image.memory(
                  //         Uint8List.fromList(
                  //             img.encodePng(originalImage!)),
                  //         fit: BoxFit.fill,
                  //         width: MediaQuery.of(context).size.width,
                  //         height: MediaQuery.of(context).size.width,
                  //       )
                  //     :
                  imageFile != null
                      ? Image.file(
                          imageFile!!,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                        )
                      : Container(),
                  (isEnabled && croppedImage != null)
                      ? Positioned(
                          left: topLeft0.dx,
                          top: topLeft0.dy,
                          width: (rightBottom0.dx - topLeft0.dx),
                          height: (rightBottom0.dy - topLeft0.dy),
                          child: Image.asset(
                            "images/frame.png",
                            fit: BoxFit.fill,
                          ).animate().scale().tint(color: Colors.red.shade400))
                      : Container()
                ],
              ),
            ),
            isEnabled
                ? Positioned(
                    left: 0,
                    top: 100,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Listener(
                      child: Container(
                        child: Signature(
                          key: sState,
                          color: Colors.white,
                        ),
                        color: Colors.transparent,
                      ),
                      onPointerDown: (v) {
                        print("down");
                      },
                      onPointerUp: (v) {
                        print("up");
                        cropImage();
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
