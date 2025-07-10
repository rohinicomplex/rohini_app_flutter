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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/otp': (context) => const OTPScreen(),
        '/expense': (context) => const ExpenseAddScreen(),
        '/landing': (context) => const LandingPage(),
        '/profile': (context) => const ProfilePage(),
        '/invoice': (context) => const InvoiceScreen(),
        '/charges': (context) => const ChargeScreen(),
        '/payonline': (context) => const PayOnlineScreen(),
        '/notice': (context) => const NoticeScreen(),
        '/chat': (context) => const GroupChatScreen(),
        '/event': (context) => const CommunityHallBookingScreen(),
        '/ledger': (context) => const LedgerScreen(),
        '/contacts': (context) => const ContactsScreen(),
        '/approvals': (context) => const ActivityApproval(),
        '/gatepass': (context) => const GatePassScreen(),
        '/settings': (context) => const SettingsPage(),
        '/customersel': (context) => const CustomerSelectionScreen(),
        '/chargesel': (context) => const ChargesSelectionScreen(),
        '/bankinfo': (context) => const BankInfoScreen(),
        '/payment_details': (context) => const PaymentDetailsScreen(
              selectedCharges: [],
            ),
        '/payment_distribution': (context) => const PaymentDistributionScreen(),
        '/summary': (context) => const SummaryScreen(),
        '/notification': (context) => const NotificationsPage(),
        '/service': (context) => const ServiceScreen(),
        '/intercom': (context) => const IntercomScreen(),
      },
    );
  }
}
