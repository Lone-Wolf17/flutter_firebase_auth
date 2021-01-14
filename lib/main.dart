import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/register_email.dart';
import 'package:flutter_firebase_auth/utils.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo'),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return FlatButton(
                child: const Text('Sign out'),
                onPressed: () async {
                  final User user = auth.currentUser;
                  if (user == null) {
                    Scaffold.of(context).showSnackBar(
                        const SnackBar(content: Text('No One has signed in.')));
                    return;
                  }
                  await auth.signOut();
                  final String uid = user.uid;
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(uid + ' has successfully signed out.')));
                },
              );
            },
          )
        ],
      ),
      body:  ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        children: [
          RegisterEmailSection(),
          // EmailPasswordLoginForm(),
          // EmailLinkSignInSection(),
        ],
      ));
  }
}
