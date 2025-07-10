import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for accessing clipboard functionality

class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({super.key});

  // Method to copy bank details to clipboard
  void _copyToClipboard(String data, BuildContext context) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bank details copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // Concatenate bank details
              String bankDetails =
                  '''Account Name: ROHINI COMPLEX FLAT OWNERS ASSOCIATION
Account Number: 00000035088967363
Bank Name: State Bank of India
Account Type: Savings
IFSC Code: SBIN0012384
Branch: RAJARHAT TOWNSHIP''';
              // Call method to copy to clipboard
              _copyToClipboard(bankDetails, context);
            },
          ),
        ],
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
            const SizedBox(height: 16.0),
            const Text(
              'Account Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('ROHINI COMPLEX FLAT OWNERS ASSOCIATION'),
            const SizedBox(height: 16.0),
            const Text(
              'Account Number:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('00000035088967363'),
            const SizedBox(height: 16.0),
            const Text(
              'Bank Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('State Bank of India'),
            const SizedBox(height: 16.0),
            const Text(
              'Account Type:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('Savings'),
            const SizedBox(height: 16.0),
            const Text(
              'IFS Code:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('SBIN0012384'),
            const SizedBox(height: 16.0),
            const Text(
              'Branch:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('RAJARHAT TOWNSHIP'),
          ],
        ),
      ),
    );
  }
}
