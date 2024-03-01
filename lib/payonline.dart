import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['VALUE'],
      name: json['LABEL'],
    );
  }
}

class PayItem {
  final String id;
  final String invoiceDate;
  final String chargeDetails;
  final String dueDate;
  final double amountDue;
  final double amount;
  final double paid;
  final double wf;
  final double wfAble;
  final double maxPayAmount;
  final String paymentStatus;
  final String wfReason;
  PayItem({
    required this.id,
    required this.invoiceDate,
    required this.chargeDetails,
    required this.dueDate,
    required this.amount,
    required this.amountDue,
    required this.paymentStatus,
    required this.wf,
    required this.wfAble,
    required this.maxPayAmount,
    required this.wfReason,
    required this.paid,
  });

  factory PayItem.fromJson(Map<String, dynamic> json) {
    return PayItem(
      id: json['SLNO'],
      invoiceDate: json['INVDATE'],
      dueDate: json['DUEDATE'],
      amountDue: double.parse(json['DUEAMOUNT']),
      amount: double.parse(json['AMOUNT']),
      chargeDetails: json['CHARGEDETAILS'],
      paymentStatus: json['PAYSTATUS'],
      wf: double.parse(json['WF']),
      wfAble: double.parse(json['WFABLE']),
      maxPayAmount: double.parse(json['MAXPAYAMOUNT']),
      wfReason: json['WFREASON'] == null ? '' : json['WFREASON'],
      paid: double.parse(json['PAID']),
    );
  }
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
    _fetchPayItems(null);
  }

  // Method to fetch users from REST service
  void _fetchUsers() async {
    // Simulating fetching users from REST service
    // Here, you would typically make an HTTP request to fetch users
    // and then update the _users list with the response data
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

//var map = new Map<String, String>();

    final response = await http.get(
        Uri.parse('https://rohinicomplex.in/service/allnames.php'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _users = data.map((json) => User.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Method to fetch pay items based on selected user from REST service
  void _fetchPayItems(User? selUser) async {
    // Simulating fetching pay items from REST service based on selected user
    // Here, you would typically make an HTTP request to fetch pay items
    // specific to the selected user and then update the _payItems list with the response data
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['userName'] = user;

    if (selUser != null) {
      // print("test");
      map['userID'] = selUser.id;
    }
    try {
      final response = await http.post(
        Uri.parse('https://rohinicomplex.in/service/getSelfPayCharges.php'),
        headers: requestHeaders,
        body: map,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _payItems = data.map((json) => PayItem.fromJson(json)).toList();
          print(_payItems.length);
        });
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {
      print(e);
    }
    /*setState(() {
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
    });*/
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
            child: Text(_selectedUser?.name ?? 'Select User',
                style: TextStyle(fontSize: 18.0)),
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
                      Text('Invoice Date: ${item.invoiceDate}'),
                      Text('Due Date:: ${item.dueDate}'),
                      Text('Status:: ${item.paymentStatus}'),
                      Text(
                        'Total Payable Amount : ${item.amountDue}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
              Text('Total Discount Applied:: ${item.wf}'),
              Text('Discount yet to apply:: ${item.wfAble}'),
              Text(
                  'Total Charge Amount after discount for ${item.wfReason}: ${item.maxPayAmount}'),
              Text('Total Paid : ${item.paid}'),
              Text(
                'Total Payable Amount : ${item.amountDue}',
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
        return ListView.builder(
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
                  _fetchPayItems(user); // Fetch pay items for the selected user
                });
                Navigator.pop(
                    context); // Close the bottom sheet after selection
              },
            );
          },
        );
      },
    );
  }
}
