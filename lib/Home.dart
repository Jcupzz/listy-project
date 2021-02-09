import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listy/Database_Services.dart';
import 'package:provider/provider.dart';
import 'AuthenticationServices/AuthenticationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var toAdd;
  final texteditingcontroller = TextEditingController();
  Database_Services database_services = new Database_Services();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                dynamic isLoggedOut = await context.read<
                    AuthenticationService>().signOut();
                if (isLoggedOut.toString() == "Signed out") {
                  //Navigator.pushReplacementNamed(context, "/Register");
                }
              },
              icon: Icon(Icons.person_outline),
              label: Text("SignOut"))
        ],
        title: Text("Listy"),
        backgroundColor: Colors.purple[900],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: (){
          showDialogfunction(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.purple[900],
        ),
        backgroundColor: Colors.deepOrange[200],
      ),
      body: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection(firebaseUser.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text('Loading...');
                } else {
                  return ListView(
                    children: snapshot.data.docs
                        .map((DocumentSnapshot document) {
                      return Card(

                          color: Colors.purple[900],
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ListTile(
                            onLongPress: () {
                              showDeleteDialog(document);
                            },
                            title: Text(document['text']),
                          ));
                    }).toList(),
                  );
                }
              })),
      backgroundColor: Colors.purple[900],
    );
  }

  showDialogfunction(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Add to Listy'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Save to Listy",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  cursorColor: Colors.tealAccent,
                  controller: texteditingcontroller,
                  onChanged: (value) {
                    toAdd = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            texteditingcontroller.clear();
                          },
                          color: Colors.red,
                          child: Text("Cancel"),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            if (texteditingcontroller.text.isEmpty) {
                              Navigator.pop(context);
                            } else {
                              dynamic isUploaded = database_services
                                  .addTextToFb(toAdd, context);
                              if (isUploaded == "uploaded") {
                                BotToast.showText(text: "Listy added!");
                              }
                              else {
                                BotToast.showText(
                                    text: "Something's wrong,check internet connection!");
                              }
                              texteditingcontroller.clear();
                              Navigator.pop(context);
                              //setState(() {});
                            }
                          },
                          child: Text("Add"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showDeleteDialog(DocumentSnapshot doc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            backgroundColor: Colors.purple[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Delete"),
            content: Text("Do you want to delete this Listy?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () {
                  database_services.deleteTextFromFb(doc, context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });



  }

}
