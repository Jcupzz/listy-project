import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:listy/Error_Handling.dart';

class Database_Services {
  DateTime now = new DateTime.now();

  Error_Handling error_handling = new Error_Handling();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTextToFb(String text, BuildContext context,DocumentSnapshot documentSnapshot) async {
    final User firebaseUser = _auth.currentUser;
    if(text!=null) {
      if (!(documentSnapshot == null)) {
        await firestore.collection(firebaseUser.uid)
            .doc(documentSnapshot.id)
            .update({
          "time": now,
          "text": text,
        })
            .then((value) {
          error_handling.printSuccess("Listy updated!");
        });
      }
      else {
        await firestore.collection(firebaseUser.uid).add({
          "time": now,
          "text": text,
        }).then((value) {
          error_handling.printSuccess("Listy added!");
        });
      }
    }
  }

  Future<void> deleteTextFromFb(
      DocumentSnapshot documentSnapshot) async {
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
