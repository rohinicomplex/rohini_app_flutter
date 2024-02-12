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
    PayItem(
        id: '004',
        invoiceDate: '2024-02-09',
        chargeDetails: 'Garbage Collection',
        dueDate: '2024-02-19',
        amount: 120,
        paymentStatus: 'Pending'),
    PayItem(
        id: '005',
        invoiceDate: '2024-02-08',
        chargeDetails: 'Security Service',
        dueDate: '2024-02-18',
        amount: 180,
        paymentStatus: 'Paid'),
    PayItem(
        id: '006',
        invoiceDate: '2024-02-07',
        chargeDetails: 'Gardening Service',
        dueDate: '2024-02-17',
        amount: 220,
        paymentStatus: 'Pending'),
    PayItem(
        id: '007',
        invoiceDate: '2024-02-06',
        chargeDetails: 'Parking Fee',
        dueDate: '2024-02-16',
        amount: 130,
        paymentStatus: 'Paid'),
    PayItem(
        id: '008',
        invoiceDate: '2024-02-05',
        chargeDetails: 'Common Area Cleaning',
        dueDate: '2024-02-15',
        amount: 170,
        paymentStatus: 'Pending'),
    PayItem(
        id: '009',
        invoiceDate: '2024-02-04',
        chargeDetails: 'Swimming Pool Maintenance',
        dueDate: '2024-02-14',
        amount: 250,
        paymentStatus: 'Pending'),
    PayItem(
        id: '010',
        invoiceDate: '2024-02-03',
        chargeDetails: 'Internet Bill',
        dueDate: '2024-02-13',
        amount: 110,
        paymentStatus: 'Paid'),
    PayItem(
        id: '011',
        invoiceDate: '2024-02-02',
        chargeDetails: 'Fitness Center Fee',
        dueDate: '2024-02-12',
        amount: 190,
        paymentStatus: 'Pending'),
    PayItem(
        id: '012',
        invoiceDate: '2024-02-01',
        chargeDetails: 'Gas Bill',
        dueDate: '2024-02-11',
        amount: 140,
        paymentStatus: 'Pending'),
    PayItem(
        id: '013',
        invoiceDate: '2024-01-31',
        chargeDetails: 'Property Tax',
        dueDate: '2024-02-10',
        amount: 160,
        paymentStatus: 'Paid'),
    PayItem(
        id: '014',
        invoiceDate: '2024-01-30',
        chargeDetails: 'Insurance Premium',
        dueDate: '2024-02-09',
        amount: 200,
        paymentStatus: 'Pending'),
    PayItem(
        id: '015',
        invoiceDate: '2024-01-29',
        chargeDetails: 'Society Event Fee',
        dueDate: '2024-02-08',
        amount: 230,
        paymentStatus: 'Pending'),
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
          DropdownButtonFormField<String>(
            value: _selectedUserName,
            items: _userNames.map((name) {
              return DropdownMenuItem(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedUserName = value!;
              });
            },
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
