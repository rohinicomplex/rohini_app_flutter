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
        title: Text('Rohini Complex'),
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
          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(20.0),
            height: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Our App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Explore various features and functionalities.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  NavigationButton(
                    icon: Icons.receipt,
                    label: 'Invoice',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.money,
                    label: 'Charges',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChargeScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.payment,
                    label: 'Pay Online',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PayOnlineScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.notification_important,
                    label: 'Notice',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoticeScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupChatScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.event,
                    label: 'Book Event',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityHallBookingScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.book,
                    label: 'Ledger',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LedgerScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.contacts,
                    label: 'Contacts',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactsScreen(),
                        ),
                      );
                    },
                  ),
                  NavigationButton(
                    icon: Icons.account_balance,
                    label: 'Bank Info',
                    onTap: () {
                      // Navigate to Bank Info screen
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Bank Info',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildBankInfoRow('Account Name',
                                    'ROHINI COMPLEX FLAT OWNERS ASSOCIATION'),
                                _buildBankInfoRow(
                                    'Account Number', '00000035088967363'),
                                _buildBankInfoRow(
                                    'Bank Name', 'State Bank of India'),
                                _buildBankInfoRow('Account Type', 'Savings'),
                                _buildBankInfoRow('IFS Code', 'SBIN0012384'),
                                _buildBankInfoRow(
                                    'Branch', 'RAJARHAT TOWNSHIP'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
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
          SizedBox(height: 20.0),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomButton(
                  icon: Icons.phone,
                  label: 'Call',
                  onTap: () {
                    // Handle Call button tap
                  },
                ),
                BottomButton(
                  icon: Icons.person,
                  label: 'Me',
                  onTap: () {
                    // Handle Me button tap
                  },
                ),
                BottomButton(
                  icon: Icons.build,
                  label: 'Service',
                  onTap: () {
                    // Handle Service button tap
                  },
                ),
                BottomButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    // Handle Settings button tap
                  },
                ),
              ],
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
            color: Theme.of(context).primaryColor,
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          color: Theme.of(context).primaryColor,
          onPressed: onTap,
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      ],
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
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
  );
}
