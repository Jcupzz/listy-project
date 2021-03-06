import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'static/Loading.dart';
import 'AuthenticationServices/AuthenticationService.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  dynamic isSuccess;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.purple[900],
            body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hi there",
                              style: TextStyle(
                                  color: Colors.deepOrange[200],
                                  fontSize: 74,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome back",
                              style: TextStyle(
                                  color: Colors.deepOrange[300],
                                  fontSize: 40,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),

                          //Email Field

                          TextFormField(
                            validator: (val) =>
                                val.isEmpty || !(val.contains('@'))
                                    ? 'Enter a valid email address'
                                    : null,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            style: TextStyle(color: Colors.purple[200]),
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.deepOrange[200],
                              ),
                              labelText: "Email",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.purple[200]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.deepOrange[200]),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 25,
                          ),

                          //Password Field

                          TextFormField(
                            validator: (val) => val.isEmpty || val.length < 6
                                ? 'Enter a password greater than 6 characters'
                                : null,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                            obscureText: true,
                            style: TextStyle(color: Colors.purple[200]),
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.deepOrange[200],
                              ),
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.purple[200]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.deepOrange[200]),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            child: PhysicalModel(
                              color: Colors.transparent,
                              shadowColor: Colors.deepPurple[900],
                              elevation: 10,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () async {
                                  print("Button presed");
                                  //
                                  if (_formkey.currentState.validate()) {
                                     setState(() {
                                       loading = true;
                                     });
                                    isSuccess = await context
                                        .read<AuthenticationService>()
                                        .signIn(email: email, password: password);
                                    print(isSuccess);
                                    if (isSuccess.toString() == "Signed in") {
                                      Navigator.pushReplacementNamed(
                                          context, '/Home');
                                      BotToast.showSimpleNotification(
                                        title:
                                        "Welcome back!",
                                        backgroundColor: Colors.orangeAccent,
                                      );
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, '/Register');
                                      BotToast.showSimpleNotification(
                                        title:
                                        "Failed to sign in. Please check internet connection and try again!",
                                        backgroundColor: Colors.red,

                                      );
                                    }
                                  }
                                  //}
                                  //   dynamic result =
                                  //   await _auth.loginWithEmailAndPassword(
                                  //       email, password);
                                  //   if (result == null) {
                                  //     setState(() {
                                  //       loading = false;
                                  //       error = 'Invalid Credentials';
                                  //       print(
                                  //           "Oops...!\nSign in failed!\nInvalid Credentials");
                                  //     });
                                  //   } else {
                                  //     print('User Signed In Successfully');
                                  //     Navigator.pushNamed(context, '/List_home');
                                  //   }
                                  // }
                                },
                                color: Colors.deepOrange[400],
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text("Sign in"),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange[200], fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
