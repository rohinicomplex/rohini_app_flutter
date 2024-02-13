import 'package:flutter/material.dart';

class PayOnlineScreen extends StatefulWidget {
  @override
  _PayOnlineScreenState createState() => _PayOnlineScreenState();
}

class _PayOnlineScreenState extends State<PayOnlineScreen> {
  List<String> _userNames = ['User 1', 'User 2', 'User 3']; // Sample user names
  String _selectedUserName = 'User 1'; // Default selected user name
  List<PayItem> _payItems = [
    PayItem(
        id: '001',
        invoiceDate: '2024-02-12',
        chargeDetails: 'Electricity Bill',
        dueDate: '2024-02-28',
        amount: 100,
        paymentStatus: 'Pending'),
    PayItem(
        id: '002',
        invoiceDate: '2024-02-11',
        chargeDetails: 'Water Bill',
        dueDate: '2024-02-25',
        amount: 150,
        paymentStatus: 'Paid'),
    PayItem(
        id: '003',
        invoiceDate: '2024-02-10',
        chargeDetails: 'Maintenance Fee',
        dueDate: '2024-02-20',
        amount: 200,
        paymentStatus: 'Pending'),
    // Add more pay items here
  ];
  Set<PayItem> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Online'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              _selectUser(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected User: $_selectedUserName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _payItems.length,
              itemBuilder: (context, index) {
                final item = _payItems[index];
                final isSelected = _selectedItems.contains(item);
                return ListTile(
                  title: Text(item.chargeDetails),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${item.id}'),
                      Text('Invoice Date: ${item.invoiceDate}'),
                      Text('Due Date: ${item.dueDate}'),
                      Text('Amount: ${item.amount}'),
                      Text('Payment Status: ${item.paymentStatus}'),
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      _showDetailsDialog(context, item);
                    },
                    child: Text('Details'),
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedItems.remove(item);
                      } else {
                        _selectedItems.add(item);
                      }
                    });
                  },
                  selected: isSelected,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Amount: ${_calculateTotalAmount()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle payment button press
            },
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  String _calculateTotalAmount() {
    double totalAmount = 0;
    for (var item in _selectedItems) {
      totalAmount += item.amount;
    }
    return totalAmount.toStringAsFixed(2);
  }

  void _showDetailsDialog(BuildContext context, PayItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Charge Amount: ${item.amount}'),
              Text('Total Discount Applied: 0'), // Placeholder for now
              Text('Total Paid: 0'), // Placeholder for now
              Text(
                'Total Payable Amount: ${item.amount}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
  }

  void _selectUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0, // Adjust height as needed
          child: ListView.builder(
            itemCount: _userNames.length,
            itemBuilder: (context, index) {
              final userName = _userNames[index];
              return ListTile(
                title: Text(userName),
                onTap: () {
                  setState(() {
                    _selectedUserName = userName;
                  });
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                },
              );
            },
          ),
        );
      },
    );
  }
}

class PayItem {
  final String id;
  final String invoiceDate;
  final String chargeDetails;
  final String dueDate;
  final double amount;
  final String paymentStatus;

  PayItem(
      {required this.id,
      required this.invoiceDate,
      required this.chargeDetails,
      required this.dueDate,
      required this.amount,
      required this.paymentStatus});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
