import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

class PayItem {
  final String id;
  final String invoiceDate;
  final String chargeDetails;
  final String dueDate;
  final double amount;
  final String paymentStatus;

  PayItem({
    required this.id,
    required this.invoiceDate,
    required this.chargeDetails,
    required this.dueDate,
    required this.amount,
    required this.paymentStatus,
  });
}

class PayOnlineScreen extends StatefulWidget {
  @override
  _PayOnlineScreenState createState() => _PayOnlineScreenState();
}

class _PayOnlineScreenState extends State<PayOnlineScreen> {
  List<User> _users = []; // Initially empty user list
  User? _selectedUser;
  List<PayItem> _payItems = []; // Initially empty pay items list
  List<PayItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Fetch users from REST service
    _fetchUsers();
  }

  // Method to fetch users from REST service
  void _fetchUsers() {
    // Simulating fetching users from REST service
    // Here, you would typically make an HTTP request to fetch users
    // and then update the _users list with the response data
    setState(() {
      _users = [
        User(id: '1', name: 'User 1'),
        User(id: '2', name: 'User 2'),
        User(id: '3', name: 'User 3'),
      ];
    });
  }

  // Method to fetch pay items based on selected user from REST service
  void _fetchPayItems(User user) {
    // Simulating fetching pay items from REST service based on selected user
    // Here, you would typically make an HTTP request to fetch pay items
    // specific to the selected user and then update the _payItems list with the response data
    setState(() {
      _payItems = [
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
    });
  }

  // Method to call REST service for payment
  void _makePayment() {
    // Show payment gateway selection dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Gateway'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Text('Please select a payment gateway:'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 2.0,
                          color: Theme.of(context)
                              .primaryColor), // Adjust border width and color as needed
                    ),
                    onPressed: () {
                      _processPayment('Paytm');
                    },
                    child: Image.asset(
                      'assets/Paytm_logo.png',
                      width: 50.0, // Adjust image width as needed
                      height: 24.0,
                    ),
                    //Text('PayTM'),
                  ),
                  /*ElevatedButton(
                    onPressed: () {
                      _processPayment('BillDesk');
                    },
                    child: Text('BillDesk'),
                  ),*/
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the payment selection dialog
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to process payment based on selected gateway
  void _processPayment(String gateway) {
    // Simulate calling REST service for payment
    // Here, you would typically make an HTTP request to your payment gateway API
    // and process the payment based on the selected gateway
    // For demonstration purposes, simply show a success message
    Navigator.of(context).pop(); // Close the payment selection dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payment has been successfully processed via $gateway.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the payment status dialog
                  // Show success message with download button for invoice
                  _showSuccessPopup();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show success popup with download button for invoice
  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payment has been successfully processed.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Download invoice logic
                  // This is a placeholder, you would implement the logic to download the invoice file
                },
                child: Text('Download Invoice'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Online'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _selectUser(context);
            },
            child: Text(_selectedUser?.name ?? 'Select User'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _payItems.length,
              itemBuilder: (context, index) {
                final item = _payItems[index];
                final isSelected = _selectedItems.contains(item);
                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedItems.add(item);
                        } else {
                          _selectedItems.remove(item);
                        }
                      });
                    },
                  ),
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
              _makePayment();
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
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                title: Text(user.name),
                onTap: () {
                  setState(() {
                    _selectedUser = user;
                    _selectedItems
                        .clear(); // Clear selected items when user changes
                    _fetchPayItems(
                        user); // Fetch pay items for the selected user
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
