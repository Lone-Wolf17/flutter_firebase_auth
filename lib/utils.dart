import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/email_auth_screen.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

FirebaseAuth get  auth => _auth;

buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Firebase Auth')),
        Container(
          color: Colors.grey,
          child: ListTile(
              title: Text(
                "Email Auth",
              ),
              trailing: Icon(
                Icons.alternate_email_outlined),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => EmailAuthScreen()));
            },
          ),
        ),
      ],
    ),
  );
}