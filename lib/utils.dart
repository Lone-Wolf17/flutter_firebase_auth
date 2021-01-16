import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/email_auth_screen.dart';
import 'package:flutter_firebase_auth/screens/phone_auth_screen.dart';


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
            leading: Icon(
                Icons.alternate_email_outlined),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => EmailAuthScreen()));
            },
          ),
        ),
        Divider(),
        Container(
          color: Colors.grey,
          child: ListTile(
            title: Text(
              "Phone Auth",
            ),
            leading: Icon(
                Icons.phone),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => PhoneAuthScreen()));
            },
          ),
        ),
      ],
    ),
  );
}

buildSignOutActionButton () {
  return Builder(
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
  );
}