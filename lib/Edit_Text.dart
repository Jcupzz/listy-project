import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listy/Database_Services.dart';

class Edit_Text extends StatefulWidget {
  //String text;
  DocumentSnapshot documentSnapshot;
  // Edit_Text(String text){
  //   this.text = text;
  // }
  Edit_Text(DocumentSnapshot documentSnapshot){
    this.documentSnapshot = documentSnapshot;
  }
  @override
  _Edit_TextState createState() => _Edit_TextState();
}
class _Edit_TextState extends State<Edit_Text> {
  TextEditingController texteditingcontroller = TextEditingController();
  var toAdd;
  Database_Services database_services = new Database_Services();
  @override
  void initState(){
    if(widget.documentSnapshot == null)
      {
        print("null");
        texteditingcontroller = TextEditingController(text: "");
      }
    else{
      texteditingcontroller = TextEditingController(text:widget.documentSnapshot['text']);
      print("not null");
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // IconButton(
                //   padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                //     icon: Icon(
                //       Icons.cancel,
                //       color: Colors.red,
                //       size: 30,
                //     ),
                //     onPressed: () {
                //       //TODO: Add cancel
                //     }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: IconButton(
                    splashColor: Colors.greenAccent,
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () {
                        if (texteditingcontroller.text.isEmpty) {
                          Navigator.pop(context);
                        } else {
                           database_services.addTextToFb(toAdd, context,widget.documentSnapshot);
                          texteditingcontroller.clear();
                          Navigator.pop(context);
                          //setState(() {});
                        }
                      }),
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: texteditingcontroller,
                  onChanged: (value){
                    toAdd = value;
                  },
                  expands: true,
                  textAlign: TextAlign.start,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 3,color: Colors.deepPurple[200]
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          width: 2, color: Colors.deepPurpleAccent),
                    ),
                    labelText: "Add notes",
                    alignLabelWithHint: true,
                    hintText: "Add notes",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white,),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  cursorColor: Colors.deepOrange[200],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
