import 'package:flutter/material.dart';
import 'otp.dart';
import 'approval.dart';
import 'charge.dart';
import 'invoice.dart';
import 'event.dart';
import 'chat.dart';
import 'contacts.dart';
import 'ledger.dart';
import 'profile.dart';
import 'settings.dart';
import 'notice.dart';

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
      home: NoticeScreen(), //OTPScreen(),
    );
  }
}
