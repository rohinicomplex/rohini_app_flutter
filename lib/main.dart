import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'expense.dart';
import 'income.dart';
import 'notification.dart';
import 'service.dart';
import 'intercom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _storeTempData();
    //List<int> selectedCharges = [];
    return MaterialApp(
      title: 'Rohini Complex',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/landing',
      routes: {
        '/otp': (context) => OTPScreen(),
        '/expense': (context) => ExpenseAddScreen(),
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
        '/settings': (context) => SettingsPage(),
        '/customersel': (context) => CustomerSelectionScreen(),
        '/chargesel': (context) => ChargesSelectionScreen(),
        '/payment_details': (context) => PaymentDetailsScreen(
              selectedCharges: [],
            ),
        '/payment_distribution': (context) => PaymentDistributionScreen(),
        '/summary': (context) => SummaryScreen(),
        '/notification': (context) => NotificationsPage(),
        '/service': (context) => ServiceScreen(),
        '/intercom': (context) => IntercomScreen(),
      },
    );
  }
}

void _storeTempData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token',
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJzdSIsIm5iZiI6MTcwNzk3Njg1MywiZXhwIjoxNzM5NTk5MjUzfQ.taTVOm6OX1DCHDbRy-Ic64oAz8t__rUmKUu9QjnuQkc');
  prefs.setString('username', 'su');
  prefs.setBool('storage', true);
}
