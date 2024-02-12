import 'package:flutter/material.dart';
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

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rohini Complex'), // Updated appbar title
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: 20.0), // Add space between big box and navigation buttons
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(20.0),
            height: 200.0, // Increased height of the box
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).primaryColor, // Use primary color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Our App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0, // Reduce font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Explore various features and functionalities.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0, // Reduce font size
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 20.0), // Add space between big box and navigation buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0, // Add horizontal spacing between items
                mainAxisSpacing: 10.0, // Add vertical spacing between items
                children: [
                  NavigationButton(
                    icon: Icons.receipt,
                    label: 'Invoice',
                    onTap: () {
                      // Navigate to Invoice screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvoiceScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.money,
                    label: 'Charges',
                    onTap: () {
                      // Navigate to Charges screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChargeScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.payment,
                    label: 'Pay Online',
                    onTap: () {
                      // Navigate to Pay Online screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayOnlineScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.notification_important,
                    label: 'Notice',
                    onTap: () {
                      // Navigate to Notice screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoticeScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onTap: () {
                      // Navigate to Chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupChatScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.event,
                    label: 'Book Event',
                    onTap: () {
                      // Navigate to Book Event screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityHallBookingScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.book,
                    label: 'Ledger',
                    onTap: () {
                      // Navigate to Ledger screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LedgerScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.contacts,
                    label: 'Contacts',
                    onTap: () {
                      // Navigate to Contacts screen

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactsScreen()),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.account_balance,
                    label: 'Bank Info',
                    onTap: () {
                      // Navigate to Bank Info screen
                    },
                  ),
                  NavigationButton(
                    icon: Icons.money_off,
                    label: 'Add Expense',
                    onTap: () {
                      // Navigate to Add Expense screen
                    },
                  ),
                  NavigationButton(
                    icon: Icons.attach_money,
                    label: 'Add Income',
                    onTap: () {
                      // Navigate to Add Income screen
                    },
                  ),
                  NavigationButton(
                    icon: Icons.thumb_up,
                    label: 'Approvals',
                    onTap: () {
                      // Navigate to Approvals screen

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NavigationButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
              color: Theme.of(context)
                  .primaryColor), // Use primary color for border
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.0), // Add padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 36.0,
                color: Theme.of(context)
                    .primaryColor), // Reduce icon size and use primary color
            SizedBox(height: 4.0), // Add space between icon and label
            Text(
              label,
              style: TextStyle(fontSize: 12.0), // Reduce font size
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBankInfoRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.0),
    child: RichText(
      text: TextSpan(
        text: '$title: ',
        style: TextStyle(fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: value),
        ],
      ),
    ),
  );
}
