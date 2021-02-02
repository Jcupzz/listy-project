import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthenticationServices/AuthenticationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("Listy"),),
      body: FlatButton(child:Text("SignOut"),onPressed: () async{
        dynamic isLoggedOut = await context.read<AuthenticationService>().signOut();
        if(isLoggedOut.toString()=="Signed out")
          {
            Navigator.pushReplacementNamed(context, "/Register");
          }
      },),
    );
  }
}
