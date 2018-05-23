import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voters/routes/home_route.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(new App());

final ThemeData _evTheme = _buildEVTheme();

ThemeData _buildEVTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.purple[200],
    primaryColor: Colors.lightBlue[300],
    buttonColor: Colors.purple[200],
    textTheme: _buildEVTextTheme(base.textTheme),
    primaryTextTheme: _buildEVTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildEVTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildEVTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        displayColor: Colors.black,
        bodyColor: Colors.black,
      );
}

class App extends StatelessWidget {
  App() {
    _handleAnonymousSignIn();
  }

  void _handleAnonymousSignIn() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomeRoute(),
      theme: _evTheme,
    );
  }
}
