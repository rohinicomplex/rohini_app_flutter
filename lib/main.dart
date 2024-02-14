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
import 'expense.dart';
import 'income.dart';
import 'notification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //List<int> selectedCharges = [];
    return MaterialApp(
      title: 'Rohini Complex',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/notification',
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
      },
    );
  }
}
