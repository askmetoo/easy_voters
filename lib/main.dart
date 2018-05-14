import 'package:flutter/material.dart';

import 'package:voters/routes/home_route.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomeRoute(),
    );
  }
}
