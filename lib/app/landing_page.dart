import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/services/auth.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;
  LandingPage({Key key, @required this.auth}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    widget.auth.onAuthStateChanged.listen((user) {
      print('user: ${user?.uid}');
    });
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: widget.auth,
                onSignIn: _updateUser,
              );
            }
            return HomePage(
              auth: widget.auth,
              onSignOut: () => _updateUser(null),
            );
          } else {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
