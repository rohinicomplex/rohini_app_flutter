import 'package:flutter/material.dart';

class BankInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/sbi.png', // Update with your image path
                width: 120,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Account Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('ROHINI COMPLEX FLAT OWNERS ASSOCIATION'),
            SizedBox(height: 16.0),
            Text(
              'Account Number:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('00000035088967363'),
            SizedBox(height: 16.0),
            Text(
              'Bank Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('State Bank of India'),
            SizedBox(height: 16.0),
            Text(
              'Account Type:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('Savings'),
            SizedBox(height: 16.0),
            Text(
              'IFS Code:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('SBIN0012384'),
            SizedBox(height: 16.0),
            Text(
              'Branch:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text('RAJARHAT TOWNSHIP'),
          ],
        ),
      ),
    );
  }
}
