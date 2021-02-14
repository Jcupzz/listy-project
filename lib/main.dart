import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AuthenticationServices/AuthenticationService.dart';
import 'Home.dart';
import 'Login.dart';
import 'Register.dart';
import 'SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DocumentSnapshot documentSnapshot;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<AuthenticationService>(create: (_)=>AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(create: (context)=>context.read<AuthenticationService>().authStateChanges,)
        ],
        child: MaterialApp(
          builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            home: AuthenticationWrapper(),
            routes: {
              '/SplashScreen': (context) => SplashScreen(),
              '/Login': (context) => Login(),
              '/Register': (context) => Register(),
              '/Home': (context) => Home(),
            }));
  }
}
//
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final firebaseUser = context.watch<User>();
    print(firebaseUser);
    if (firebaseUser == null) {
    return Register();

    }
    else{
      return Home();
    }

    

  }
}
