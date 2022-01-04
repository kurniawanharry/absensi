import 'package:absensi/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  final String docId;
  DatabaseService({this.uid, this.docId});

  final CollectionReference absen =
      FirebaseFirestore.instance.collection('absensi');

  Future updateUserData(String user) async {
    return await absen.doc(uid).set({
      'firstupdte': Timestamp.fromDate(DateTime.now()),
      'user': user,
    });
  }

  Future addData(String newTaskTime, String newTaskLocation,
      String newTaskCheck, String newPhotoURL) async {
    return await absen
        .doc(uid)
        .collection('check')
        .doc(docId)
        .set({
          'lastupdate': Timestamp.fromDate(DateTime.now()),
          'usertime': newTaskTime,
          'userlocation': newTaskLocation,
          'usercheck': newTaskCheck,
          'userPhotoUrl': newPhotoURL,
          'lastupdateOut': '',
          'usertimeOut': '',
          'userlocationOut': '',
          'usercheckOut': '',
          'userPhotoUrlOut': '',
          'documnet id': docId
        })
        .then((value) => Fluttertoast.showToast(msg: 'Data Berhasil Ditambah'))
        .catchError((e) => Fluttertoast.showToast(msg: 'Data Gagal Ditambah'));
  }

  Future<void> updateData(String newTaskTime, String newTaskLocation,
      String newTaskCheck, String newPhotoURL) async {
    return await absen
        .doc(uid)
        .collection('check')
        .doc(docId)
        .update({
          'lastupdateOut': Timestamp.fromDate(DateTime.now()),
          'usertimeOut': newTaskTime,
          'userlocationOut': newTaskLocation,
          'usercheckOut': newTaskCheck,
          'userPhotoUrlOut': newPhotoURL,
        })
        .then((value) => Fluttertoast.showToast(msg: 'Data Berhasil Ditambah'))
        .catchError((e) => Fluttertoast.showToast(msg: 'Data Gagal Ditambah'));
  }

  List<Task> _userAbsenList(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      return Task(
          userTime: document['usertime'],
          userLocation: DateFormat('dd MMMM yyyy')
              .format(document['lastupdate'].toDate()),
          userCheck: document['usercheck'],
          //userImage: document['userPhotoUrl'],
          userTimeOut: document['usertimeOut'],
          userLocationOut: document['userlocationOut'],
          userCheckOut: document['usercheckOut']);
    }).toList();
  }

  Stream<List<Task>> get absenUser {
    return absen
        .doc(uid)
        .collection('check')
        .orderBy('lastupdate', descending: false)
        .snapshots()
        .map(_userAbsenList);
  }
}
