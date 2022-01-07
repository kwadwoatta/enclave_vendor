import 'package:flutter/material.dart';

import './body.dart';
// import './top_bar.dart';

class MySpaces extends StatefulWidget {
  @override
  _MySpacesState createState() => _MySpacesState();
}

class _MySpacesState extends State<MySpaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
