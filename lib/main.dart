import 'package:flutter/material.dart';
import 'otp.dart';
import 'landing.dart';
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
import 'payonline.dart';

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
      initialRoute: '/landing',
      routes: {
        '/otp': (context) => OTPScreen(),
        '/landing': (context) => LandingPage(),
        '/profile': (context) => ProfilePage(),
        '/invoice': (context) => InvoiceScreen(),
        '/charges': (context) => ChargeScreen(),
        '/payonline': (context) => PayOnlineScreen(),
        '/notice': (context) => NoticeScreen(),
        '/chat': (context) => GroupChatScreen(),
        '/event': (context) => CommunityHallBookingScreen(),
        '/ledger': (context) => LedgerScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/approvals': (context) => ApprovalScreen(),
      },
    );
  }
}
