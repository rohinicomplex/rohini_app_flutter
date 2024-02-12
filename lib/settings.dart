import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Share your experience with us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    _launchURL('https://tinyurl.com/rohiniapp');
                  },
                );
              }),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Require Touch ID'),
                Switch(
                  value: true, // Set the initial value as required
                  onChanged: (value) {
                    // Handle toggle changes
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _showContactInfo(context);
              },
              child: Text('Contact Us'),
            ),
            SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: () {
                // Un-register logic
              },
              child: Text('Un-register this app'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL('https://goo.gl/maps/93K7ciPPH5Sxtzus5');
                },
                child: Text(
                    'Navigate:  Sourav Ganugly Avenue, Bablatala, PO R-Gopalpur, Rajarhat , Kolkata, 700136'),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('tel:+91-33-2519-5172');
                },
                child: Text('Quick Contact +91-33-2519-5172'),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('mailto:contact@rohinicomplex.in');
                },
                child: Text('Message @ contact@rohinicomplex.in'),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('https://wa.me/+913325195172');
                },
                child: Text('Whatsapp @ 913325195172'),
              ),
            ],
          ),
          actions: [
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
  }
}
