import 'package:app/storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController emailOrPhoneNumberController = TextEditingController();
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  int _resendTimeout = 30;
  bool _isResendDisabled = false;
  bool _showOTPField = false;
  bool _isVerified = false;

  Timer? _resendTimer;
  String _text = "";
  Color _col = Colors.green;
  String _usr = "";
  String _em = "";
  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  // Function to send OTP to the provided email or phone number
  void sendOTP() async {
    String emailOrPhoneNumber = emailOrPhoneNumberController.text;
    // Here you can implement the logic to send OTP to the provided email or phone number
    // For demo purposes, let's print the email or phone number
    try {
      var map = new Map<String, String>();
      map["email"] = emailOrPhoneNumber;
      final response = await http.post(
        Uri.parse("https://rohinicomplex.in/service/getOTP.php"),
        body: map,
      );
      if (response.statusCode == 200) {
        final obj = json.decode(response.body);

        if (obj["result"] > 0) {
// Start the resend timer
          startResendTimer();
          // Show OTP field
          setState(() {
            _em = emailOrPhoneNumber;
            _text = 'OTP sent to: $emailOrPhoneNumber';
            _col = Colors.green;
            _showOTPField = true;
            _usr = obj["users"][0]["USERNAME"];
          });
        }
      } else {
        throw Exception('Failed to generate OTP');
      }
    } catch (e) {
      setState(() {
        _text = 'Failed to generate OTP';
        _col = Colors.red;
      });
    }
  }

  // Function to start the resend timer
  void startResendTimer() {
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimeout == 0) {
        setState(() {
          _isResendDisabled = false;
          _resendTimeout = 30;
        });
        timer.cancel();
      } else {
        setState(() {
          _resendTimeout--;
        });
      }
    });
    setState(() {
      _isResendDisabled = true;
    });
  }

  // Function to handle resend button press
  void handleResendButtonPress() {
    startResendTimer(); // Reset the timer
    sendOTP();
  }

  // Function to verify OTP
  void verifyOTP() async {
    String enteredOTP =
        otpControllers.map((controller) => controller.text).join();
    // Here you can implement the logic to verify the OTP
    // For demo purposes, let's print the OTP
    print('Entered OTP: $enteredOTP');
    // You can add further logic here to validate the OTP
    // For now, let's simulate verification by printing the message

    // Here you can implement the logic to send OTP to the provided email or phone number
    // For demo purposes, let's print the email or phone number
    try {
      var map = new Map<String, String>();
      map["email"] = _em;
      map["otp"] = enteredOTP;
      map["uname"] = _usr;
      final response = await http.post(
        Uri.parse("https://rohinicomplex.in/service/registerapp.php"),
        body: map,
      );
      if (response.statusCode == 200) {
        final obj = json.decode(response.body);

        if (obj["result"] == "1") {
          LocalAppStorage().storeData(obj['token'], _usr);
          setState(() {
            _isVerified = true;
            _text = "OTP Validated";
            _col = Colors.green;
          });
          Navigator.pushReplacementNamed(context, '/landing');
        } else {
          throw Exception('Unable to validate OTP');
        }
      } else {
        throw Exception('System Error!');
      }
    } catch (e) {
      setState(() {
        _text = e.toString();
        _col = Colors.red;
      });
    }
  }

  // Function to reset the OTP entry and resend process
  void resetOTPEntry() {
    setState(() {
      _showOTPField = false;
      _resendTimeout = 30;
      _isResendDisabled = false;
      _isVerified = false;
      emailOrPhoneNumberController.clear();
      otpControllers.forEach((controller) => controller.clear());
      _text = "";
      _col = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (true) ...[
                Text(_text, style: TextStyle(color: _col)),
                SizedBox(height: 20.0),
              ],
              if (!_showOTPField) ...[
                TextField(
                  controller: emailOrPhoneNumberController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email or Phone Number',
                    hintText: 'Enter your email or phone number',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: sendOTP,
                  child: Text('Send OTP'),
                ),
              ],
              if (_showOTPField) ...[
                Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 50.0,
                      child: TextField(
                        controller: otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1, // Each box holds only one digit
                        onChanged: (value) {
                          // Move focus to the next box when a digit is entered
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: verifyOTP,
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  child: Text('Verify OTP'),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resend OTP in $_resendTimeout seconds',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 10.0),
                    TextButton(
                      onPressed:
                          _isResendDisabled ? null : handleResendButtonPress,
                      child: Text('Resend'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: resetOTPEntry,
                  child: Text('Change Email/Phone Number'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
