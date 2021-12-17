import 'package:absensi/components/constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool loading = false;
  File _imageFile;
  XFile pickedFile;
  int camera = 1;

  CameraController controller;
  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[camera], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  String userPhotoUrl;

  Future uploadImageToFirebase(BuildContext context) async {
    String filePath = _imageFile.path;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uplouds/${filePath}');
    UploadTask uploadTask = ref.putFile(_imageFile);
    await uploadTask.then((res) =>
        res.ref.getDownloadURL().then((value) => userPhotoUrl = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMain,
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height /
                            controller.value.aspectRatio,
                        child: CameraPreview(controller),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: kColorMain2,
                                  onPrimary: kColorMain),
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: 20,
                                color: kColorMain,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            margin:
                                EdgeInsets.only(top: 50, left: 20, right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 3)),
                                  primary: kColorMain2,
                                  onPrimary: kColorMain),
                              child: Icon(
                                Icons.camera,
                                size: 40,
                                color: kColorMain,
                              ),
                              onPressed: () async {
                                if (!controller.value.isTakingPicture) {
                                  final pickedFile =
                                      await controller.takePicture();
                                  if (pickedFile == null) {
                                    print('Data Null');
                                  } else {
                                    setState(() {
                                      _imageFile = File(pickedFile.path);
                                    });
                                    await uploadImageToFirebase(context);
                                    if (userPhotoUrl != null) {
                                      Navigator.pop(context, userPhotoUrl);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: kColorMain2,
                                  onPrimary: kColorMain),
                              child: Icon(
                                Icons.cameraswitch,
                                size: 20,
                                color: kColorMain,
                              ),
                              onPressed: () {
                                if (camera == 0) {
                                  camera++;
                                } else {
                                  camera--;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
