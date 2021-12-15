import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool showSpinner = false;
  File _imageFile;
  final ImagePicker picker = ImagePicker();

  Future pickImage() async {
    final XFile pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String userPhotoUrl;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = (_imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uplouds/${fileName}');
    UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.then((res) =>
        res.ref.getDownloadURL().then((value) => userPhotoUrl = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploading Image to Firebase Storage",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile)
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              margin: const EdgeInsets.only(
                  top: 30, left: 20.0, right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [yellow, orange],
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    await uploadImageToFirebase(context);
                    if (userPhotoUrl != null) {
                      Navigator.pop(context, userPhotoUrl);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
