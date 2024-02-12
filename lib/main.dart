import 'package:flutter/material.dart';
import 'otp.dart';
import 'approval.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rohini Complex',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ApprovalScreen(),
    );
  }
}
