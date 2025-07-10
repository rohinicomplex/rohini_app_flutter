import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';
import 'storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool touchIDEnabled = false; // Default value

  @override
  void initState() {
    super.initState();
    _fetchTouchIDEnabled();
  }

  Future<void> _fetchTouchIDEnabled() async {
    bool enabled = await LocalAppStorage().getTouchIDEnable();
    setState(() {
      touchIDEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Share your experience with us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () {
                    _launchURL('https://tinyurl.com/rohiniapp');
                  },
                );
              }),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Require Touch ID'),
                Switch(
                  value: touchIDEnabled, // Set the initial value as required
                  onChanged: (value) {
                    // Handle toggle changes
                    _setTouchID(context, value);
                  },
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _showContactInfo(context);
              },
              child: const Text('Contact Us'),
            ),
            const SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: () {
                // Un-register logic
                _showUnregisterConfirmation(context);
              },
              child: const Text('Un-register this app'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUnregisterConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Un-register this app?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to un-register this app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                LocalAppStorage().removeUser();

                Navigator.pushReplacementNamed(context, '/otp');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _setTouchID(BuildContext context, bool val) async {
    if (val == false) {
      await LocalAppStorage().setTouchIDEnable(false);
      setState(() {
        touchIDEnabled = false;
      });
      return;
    }

    final localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.face)) {
          bool authenticated = await localAuth.authenticate(
            localizedReason: 'Authenticate to enable Touch ID',
          );

          if (authenticated) {
            await LocalAppStorage().setTouchIDEnable(true);
            setState(() {
              touchIDEnabled = true;
            });
          }
        }
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Authentication failed. Please try again.'),
      ));
    }
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL('https://goo.gl/maps/93K7ciPPH5Sxtzus5');
                },
                child: const Text(
                    'Navigate:  Sourav Ganugly Avenue, Bablatala, PO R-Gopalpur, Rajarhat , Kolkata, 700136'),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('tel:+917003452046');
                },
                child: const Text('Quick Contact +91-7003452046'),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('mailto:contact@rohinicomplex.in');
                },
                child: const Text('Message @ contact@rohinicomplex.in'),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  _launchURL('https://wa.me/+917003452046');
                },
                child: const Text('Whatsapp @ 917003452046'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
