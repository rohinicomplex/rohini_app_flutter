//import 'dart:html';

import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice Board'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}
