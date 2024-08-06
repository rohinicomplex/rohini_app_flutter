import 'package:flutter/material.dart';

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
              Navigator.pushNamed(context, '/settings');
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
                  'Welcome Mr. XYZ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Wao! You have no pending actions!',
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
                      Navigator.pushNamed(context, '/invoice');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.money,
                    label: 'Charges',
                    onTap: () {
                      Navigator.pushNamed(context, '/charges');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.payment,
                    label: 'Pay Online',
                    onTap: () {
                      Navigator.pushNamed(context, '/payonline');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.notification_important,
                    label: 'Notice',
                    onTap: () {
                      Navigator.pushNamed(context, '/notice');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onTap: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.event,
                    label: 'Book Event',
                    onTap: () {
                      Navigator.pushNamed(context, '/event');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.book,
                    label: 'Ledger',
                    onTap: () {
                      Navigator.pushNamed(context, '/ledger');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.contacts,
                    label: 'Contacts',
                    onTap: () {
                      Navigator.pushNamed(context, '/contacts');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.account_balance,
                    label: 'Bank Info',
                    onTap: () {
                      Navigator.pushNamed(context, '/bankinfo');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.money_off,
                    label: 'Add Expense',
                    onTap: () {
                      // Navigate to Add Expense screen
                      Navigator.pushNamed(context, '/expense');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.attach_money,
                    label: 'Add Income',
                    onTap: () {
                      // Navigate to Add Income screen
                      //
                      Navigator.pushNamed(context, '/customersel');
                    },
                  ),
                  NavigationButton(
                    icon: Icons.thumb_up,
                    label: 'Approvals',
                    onTap: () {
                      // Navigate to Approvals screen
                      Navigator.pushNamed(context, '/approvals');
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
                  label: 'Intercom',
                  onTap: () {
                    // Handle Call button tap
                    Navigator.pushNamed(context, '/intercom');
                  },
                ),
                BottomButton(
                  icon: Icons.person,
                  label: 'Me',
                  onTap: () {
                    // Handle Me button tap
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                BottomButton(
                  icon: Icons.build,
                  label: 'Service',
                  onTap: () {
                    // Handle Service button tap
                    Navigator.pushNamed(context, '/service');
                  },
                ),
                BottomButton(
                  icon: Icons.notifications_active,
                  label: 'Notification',
                  onTap: () {
                    Navigator.pushNamed(context, '/notification');
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
