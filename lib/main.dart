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
import 'gatepass.dart';
import 'payonline.dart';
import 'expense.dart';
import 'income.dart';
import 'notification.dart';
import 'service.dart';
import 'intercom.dart';
import 'storage.dart';
import 'bankinfo.dart';
//import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalAppStorage().storeTempData();
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
        '/approvals': (context) => ActivityApproval(),
        '/gatepass': (context) => GatePassScreen(),
        '/settings': (context) => SettingsPage(),
        '/customersel': (context) => CustomerSelectionScreen(),
        '/chargesel': (context) => ChargesSelectionScreen(),
        '/bankinfo': (context) => BankInfoScreen(),
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
