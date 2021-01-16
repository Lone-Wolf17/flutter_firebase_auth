import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {

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
        drawer: buildDrawer(context),
        body:  ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          children: [
            _RegisterEmailSection(),
            _EmailPasswordLoginForm(),
            _EmailLinkSignInSection(),
          ],
        ));
  }
}


class _RegisterEmailSection extends StatefulWidget {
  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<_RegisterEmailSection>
    with EmailAuthMixin {

  void _register() async {
    final User user = (await auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEmailTextFormField(),
          buildPasswordTextFormField(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _register();
                }
              },
              child: const Text('Submit'),
            ),
          ),
          buildFeedbackWidget(
              successMsg: 'Successfully registered $_userEmail',
              failMsg: 'Registration failed')
        ],
      ),
      // ),
    );
  }
}


class _EmailPasswordLoginForm extends StatefulWidget {
  @override
  _EmailPasswordLoginFormState createState() => _EmailPasswordLoginFormState();
}

class _EmailPasswordLoginFormState extends State<_EmailPasswordLoginForm>
    with EmailAuthMixin {
  void _signInWithEmailAndPassword() async {
    final user = (await auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text('Test sign in with email and password'),
            ),
            buildEmailTextFormField(),
            buildPasswordTextFormField(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            buildFeedbackWidget(
                successMsg: 'Sign In Successful', failMsg: 'Sign In Failed'),
          ],
        ));
  }
}

class _EmailLinkSignInSection extends StatefulWidget {
  @override
  _EmailLinkSignInSectionState createState() => _EmailLinkSignInSectionState();
}

class _EmailLinkSignInSectionState extends State<_EmailLinkSignInSection>
    with EmailAuthMixin, WidgetsBindingObserver {
  String _userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    print('App Lifecycle state changed Called');

    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();

      // if (data?.link != null) {
      //   handleLink(data?.link);
      // }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            print('point success');
            final Uri deepLink = dynamicLink?.link;
            handleLink(deepLink);
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
    }
  }

  void handleLink(Uri link) async {

    print('within handleLink');
    if (link != null) {
      print('Link is not null');
      print('UserEmail = $_userEmail');
      final User user = (await auth.signInWithEmailLink(
        email: _userEmail,
        emailLink: link.toString(),
      )).user;

      if (user != null) {
        setState(() {
          _userID = user.uid;
          _success = true;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } else {
      setState(() {
        _success = false;
      });
    }
    setState(() {});
  }

  _signInWithEmailAndLink() async {
    _userEmail = _emailController.text;

    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://korex006.page.link/H3Ed',
        handleCodeInApp: true,
        androidPackageName: 'com.gmail.korex006.flutter_firebase_auth',
        androidInstallApp: true,
        androidMinimumVersion: '1');

    return await auth.sendSignInLinkToEmail(
        email: _userEmail, actionCodeSettings: actionCodeSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: const Text('Test sign in with email and link'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          buildEmailTextFormField(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _signInWithEmailAndLink();
                }
              },
              child: const Text('Submit'),
            ),
          ),
          buildFeedbackWidget(
              successMsg: 'Successfully signed in, uid: $_userID',
              failMsg: 'Sign in failed')
        ],
      ),
    );
  }
}

mixin EmailAuthMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget buildFeedbackWidget(
      {@required String successMsg, @required String failMsg}) {
    return Container(
      alignment: Alignment.center,
      child: Text(_success == null ? '' : (_success ? successMsg : failMsg)),
    );
  }

  Widget buildPasswordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget buildEmailTextFormField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        } else if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
