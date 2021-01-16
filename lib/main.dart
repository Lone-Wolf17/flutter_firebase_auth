import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/email_auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return FutureBuilder(
            // Initialize FlutterFire:
              future: _initialization,
              builder: (context, snapshot) {

                // Check for errors
                if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text('Something went wrong'),
                  );
                }

                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  // Navigator.of(context)
                  //     .pushReplacement(MaterialPageRoute(builder: (_) => EmailAuthScreen()));
                  return EmailAuthScreen();
                }

                // Otherwise, show something whilst waiting for initialization to complete
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );


                return EmailAuthScreen();
              }
          );
        },
      ),
    );
  }
}
