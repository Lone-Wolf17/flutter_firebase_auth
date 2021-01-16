import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final SmsAutoFill _autoFill = SmsAutoFill();

  String _verificationId;

  void verifyPhoneNumber() async {
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential phoneAuthCredential) async {
      await auth.signInWithCredential(phoneAuthCredential);
      showSnackBar(
          'Phone number automatically verified and user signed In: ${auth
              .currentUser}');
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed = (
        FirebaseAuthException authException) {
      showSnackBar('Phone number verification failed. Code: ${authException
          .code}. Message ${authException.message}');
    };

    //Callback for when the code is sent
    PhoneCodeSent codeSent = (String verificationId,
        [int forceResendingToken]) async {
      showSnackBar('Please check your phone for the verification code');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (
        String verificationId) {
      showSnackBar("Verification code: $verificationId");
      _verificationId = verificationId;
    };

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 15),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar('Failed to verify Phone Number: $e');
    }
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: _smsController.text);

      final User user = (await auth.signInWithCredential(credential)).user;
      
      showSnackBar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      showSnackBar('Failed to sign in: ${e.toString()}');
    }
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Phone Auth Demo'),
        actions: [
          buildSignOutActionButton()
        ],
      ),
      drawer: buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                  labelText: 'Phone Number +234 XX XXX XXXX'),
              keyboardType: TextInputType.phone,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text('Get current number'),
                onPressed: () async {
                  _phoneNumberController.text = await _autoFill.hint;
                },
                color: Colors.greenAccent[700],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                color: Colors.greenAccent[400],
                child: Text('Verify Number'),
                onPressed: () async {
                  verifyPhoneNumber();
                },
              ),
            ),
            TextFormField(
              controller: _smsController,
              decoration: const InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                color: Colors.greenAccent[200],
                child: Text('Sign In'),
                onPressed: () async {
                  signInWithPhoneNumber();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
