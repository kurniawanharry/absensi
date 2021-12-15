import 'package:absensi/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          'userPhotoUrl': newPhotoURL ??
              'https://images7.alphacoders.com/719/thumb-1920-719179.png',
        })
        .then((value) => print('Data Ditambah'))
        .catchError((e) => print('Gagal'));
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
        .orderBy('lastupdate', descending: false)
        .snapshots()
        .map(_userAbsenList);
  }
}
