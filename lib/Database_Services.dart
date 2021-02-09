import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:listy/Error_Handling.dart';

class Database_Services {
  DateTime now = new DateTime.now();
  Error_Handling error_handling = new Error_Handling();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTextToFb(String text, BuildContext context) async {
    DateTime date = new DateTime(now.year, now.month, now.day);
    final User firebaseUser = _auth.currentUser;

    await firestore.collection(firebaseUser.uid).add({
      "date": date,
      "time": now,
      "text": text,
    }).then((value) {
       error_handling.printSuccess("Listy added!");
    });
  }

  Future<void> deleteTextFromFb(
      DocumentSnapshot documentSnapshot, BuildContext context) async {
    final User firebaseUser = _auth.currentUser;

    await firestore
        .collection(firebaseUser.uid)
        .doc(documentSnapshot.id)
        .delete()
        .then((value) {
      error_handling.printSuccess("Listy deleted!");
    }).catchError((error) {
      error_handling.printError(
          "Something's wrong! check internet connection and try again!");
    });
  }
}
