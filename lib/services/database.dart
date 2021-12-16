import 'package:absensi/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference absen =
      FirebaseFirestore.instance.collection('absensi');

  Future updateUserData(String user) async {
    return await absen.doc(uid).set({
      'firstupdte': Timestamp.fromDate(DateTime.now()),
      'user': user,
    });
  }

  Future<void> addData(String newTaskTime, String newTaskLocation,
      String newTaskCheck, String newPhotoURL) {
    return absen
        .doc(uid)
        .collection('check')
        .add({
          'lastupdate': Timestamp.fromDate(DateTime.now()),
          'usertime': newTaskTime,
          'userlocation': newTaskLocation,
          'usercheck': newTaskCheck,
          'userPhotoUrl': newPhotoURL,
        })
        .then((value) => Fluttertoast.showToast(msg: 'Data Berhasil Ditambah'))
        .catchError((e) => Fluttertoast.showToast(msg: 'Data Gagal Ditambah'));
  }

  List<Task> _userAbsenList(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      return Task(
        userTime: document['usertime'],
        userLocation: document['userlocation'],
        userCheck: document['usercheck'],
        userImage: document['userPhotoUrl'],
      );
    }).toList();
  }

  Stream<List<Task>> get absenUser {
    return absen
        .doc(uid)
        .collection('check')
        .orderBy('lastupdate', descending: true)
        .snapshots()
        .map(_userAbsenList);
  }
}
