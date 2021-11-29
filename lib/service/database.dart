import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference habitCollection =
      FirebaseFirestore.instance.collection('habit');

  Future updateUserData(String name, String date) async {
    return await habitCollection.doc(uid).set({
      'name': name,
      'date': date,
    });
  }
}
