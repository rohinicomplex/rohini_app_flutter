import 'package:flutter/material.dart';
import 'dart:async';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController emailOrPhoneNumberController = TextEditingController();
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  int _resendTimeout = 30;
  bool _isResendDisabled = false;
  bool _showOTPField = false;
  bool _isVerified = false;

  Timer? _resendTimer;

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  // Function to send OTP to the provided email or phone number
  void sendOTP() {
    String emailOrPhoneNumber = emailOrPhoneNumberController.text;
    // Here you can implement the logic to send OTP to the provided email or phone number
    // For demo purposes, let's print the email or phone number
    print('OTP sent to: $emailOrPhoneNumber');
    // Start the resend timer
    startResendTimer();
    // Show OTP field
    setState(() {
      _showOTPField = true;
    });
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
  void verifyOTP() {
    String enteredOTP =
        otpControllers.map((controller) => controller.text).join();
    // Here you can implement the logic to verify the OTP
    // For demo purposes, let's print the OTP
    print('Entered OTP: $enteredOTP');
    // You can add further logic here to validate the OTP
    // For now, let's simulate verification by printing the message
    setState(() {
      _isVerified = true;
    });
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
              if (_isVerified) ...[
                Text('Verified successfully',
                    style: TextStyle(color: Colors.green)),
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
                    6,
                    (index) => SizedBox(
                      width: 50.0,
                      child: TextField(
                        controller: otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1, // Each box holds only one digit
                        onChanged: (value) {
                          // Move focus to the next box when a digit is entered
                          if (value.isNotEmpty && index < 5) {
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
                  child: Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 18.0), // Increase the font size
                  ),
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
                    ElevatedButton(
                      onPressed:
                          _isResendDisabled ? null : handleResendButtonPress,
                      child: Text('Resend'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
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
