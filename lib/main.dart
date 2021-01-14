import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        child: FutureBuilder(
          // Initialize FlutterFire:
            future: _initialization,
            builder: (context, snapshot) {

              // Check for errors
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text('Something went wrong'),
                  ),
                );
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Text('Successful!!!!'),
                );
              }
              print (snapshot.connectionState);
              // Otherwise, show something whilst waiting for initialization to complete
              return Center(child: CircularProgressIndicator());

            }
        ),
      ),
    );
  }
}
