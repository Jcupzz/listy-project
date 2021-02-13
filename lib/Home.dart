import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listy/Database_Services.dart';
import 'package:listy/Edit_Text.dart';
import 'package:provider/provider.dart';
import 'AuthenticationServices/AuthenticationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedValue;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot documentSnapshot;
  final texteditingcontroller = TextEditingController();
  Database_Services database_services = new Database_Services();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.purple[900],
      //   actions: <Widget>[
      //     FlatButton.icon(
      //         onPressed: () async {
      //           dynamic isLoggedOut = await context.read<
      //               AuthenticationService>().signOut();
      //           if (isLoggedOut.toString() == "Signed out") {
      //             Navigator.pushReplacementNamed(context, "/Register");
      //           }
      //         },
      //         icon: Icon(Icons.person_outline),
      //         label: Text("SignOut"))
      //   ],
      //   title: Text("Listy."),
      //   centerTitle: true,
      // ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Edit_Text(documentSnapshot)));
          // showDialogfunction(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.purple[900],
        ),
        backgroundColor: Colors.deepOrange[200],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                      child: Text(
                        "Listy.",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.deepOrange[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.deepPurple[400],
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    icon: Icon(
                      Icons.settings,
                      color: Colors.deepOrange[200],
                      size: 35,
                    ),
                    onSelected: (result) async {
                      switch (result) {
                        case 0:
                        showSignOutConfirmation();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                            value: 0,
                            child: Text(
                              "SignOut",
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            )),
                      ];
                    },
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection(firebaseUser.uid).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    } else {
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Card(
                                  color: Colors.deepPurple[600],
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  child: ListTile(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Edit_Text(document)));
                                    },
                                    onLongPress: () {
                                      showDeleteDialog(document);
                                    },
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                      child: Text(
                                        document['text'],
                                        maxLines: 5,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.purple[900],
    );
  }

  // showDialogfunction(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20.0)),
  //           title: Text('Add to Listy'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               TextField(
  //                 maxLines: null,
  //                 decoration: InputDecoration(
  //                   labelText: "Save to Listy",
  //                   fillColor: Colors.white,
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                     borderSide: BorderSide(color: Colors.red),
  //                   ),
  //                 ),
  //                 style: TextStyle(fontSize: 18, color: Colors.black),
  //                 cursorColor: Colors.deepOrange[200],
  //                 controller: texteditingcontroller,
  //                 onChanged: (value) {
  //                   toAdd = value;
  //                 },
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
  //                 child: Container(
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: <Widget>[
  //                       RaisedButton(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0),
  //                         ),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                           texteditingcontroller.clear();
  //                         },
  //                         color: Colors.red,
  //                         child: Text("Cancel"),
  //                       ),
  //                       RaisedButton(
  //                         splashColor: Colors.greenAccent,
  //                         color: Colors.green,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0),
  //                         ),
  //                         onPressed: () {
  //                           if (texteditingcontroller.text.isEmpty) {
  //                             Navigator.pop(context);
  //                           } else {
  //                             dynamic isUploaded =
  //                                 database_services.addTextToFb(toAdd, context);
  //                             if (isUploaded == "uploaded") {
  //                               BotToast.showText(text: "Listy added!");
  //                             } else {
  //                               BotToast.showText(
  //                                   text:
  //                                       "Something's wrong,check internet connection!");
  //                             }
  //                             texteditingcontroller.clear();
  //                             Navigator.pop(context);
  //                             //setState(() {});
  //                           }
  //                         },
  //                         child: Text("Add"),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  void showDeleteDialog(DocumentSnapshot doc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            backgroundColor: Colors.deepPurple[600],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Delete",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            content: Text("Do you want to delete this Listy?",style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.greenAccent,fontSize: 18),
                ),
              ),
              FlatButton(
                onPressed: () {
                  database_services.deleteTextFromFb(doc);
                  Navigator.pop(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18 ,color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }
  void showSignOutConfirmation(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            backgroundColor: Colors.deepPurple[600],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("SignOut",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            content: Text("Are you sure?",style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.greenAccent,fontSize: 18),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  dynamic isLoggedOut = await context
                      .read<AuthenticationService>()
                      .signOut();
                  if (isLoggedOut.toString() == "Signed out") {
                    Navigator.pushReplacementNamed(
                        context, "/Register");
                  }
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18 ,color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }
}
