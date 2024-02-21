import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';

class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['VALUE'],
      name: json['LABEL'],
    );
  }
}

class ChargeScreen extends StatefulWidget {
  @override
  _ChargeScreenState createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  String _selectedUserId = '';
  List<User> _users = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  TextEditingController _searchController = TextEditingController();
  List<ChargeItem> _chargeItems = [];
  List<ChargeItem> _allChargeItems = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();

    _fetchChargeItems("0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Charges'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Refine',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Filter by Date'),
              onTap: () {
                _showDateFilter(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                      ),
                      onChanged: (text) {
                        setState(() {}); // Trigger rebuild on text change
                      },
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Add search logic here
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _showUserSelection(context);
              },
              child: Text(
                'Select User',
                style: TextStyle(fontSize: 18.0), // Increased font size
              ),
            ),
            SizedBox(height: 20.0),
            _selectedUserId.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _chargeItems.length,
                      itemBuilder: (context, index) {
                        return ChargeItemWidget(
                          chargeItem: _chargeItems[index],
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _showUserSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: _users.map((user) {
            return ListTile(
              title: Text(user.name),
              onTap: () {
                setState(() {
                  _selectedUserId = user.id;
                  _fetchChargeItems(user.id);
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showDateFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text('From Date:'),
                    SizedBox(width: 10),
                    _fromDate != null
                        ? TextButton.icon(
                            onPressed: () {
                              _pickFromDate(context);
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text(
                              '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}',
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () {
                              _pickFromDate(context);
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text('Select'),
                          ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text('To Date:'),
                    SizedBox(width: 10),
                    _toDate != null
                        ? TextButton.icon(
                            onPressed: () {
                              _pickToDate(context);
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text(
                              '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}',
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () {
                              _pickToDate(context);
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text('Select'),
                          ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _filterChargeItems();
                Navigator.of(context).pop();
              },
              child: Text('Filter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _pickToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _fetchUsers() async {
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

  void _fetchChargeItems(String selUser) async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['userName'] = user;

    if (selUser != "0") {
      // print("test");
      map['userID'] = selUser;
    } else {
      _selectedUserId = "0";
    }
    try {
      final response = await http.post(
        Uri.parse('https://rohinicomplex.in/service/getMAllCharges.php'),
        headers: requestHeaders,
        body: map,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allChargeItems =
              data.map((json) => ChargeItem.fromJson(json)).toList();
          _chargeItems = _allChargeItems;
          _searchController.text = "";
        });
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {}
  }

  void _filterChargeItems() {
    // Filter charge items based on selected dates and search text
    // Update _chargeItems accordingly
    List<ChargeItem> _filteredChargeItems = [];
    if (!_searchController.text.isEmpty) {
      for (var i = 0; i < _allChargeItems.length; i++) {
        if (_allChargeItems[i].chargeDetails.contains(_searchController.text)) {
          _filteredChargeItems.add(_allChargeItems[i]);
        }
      }
    }
    //if(_fromDate.)
    setState(() {
      _chargeItems = _filteredChargeItems;
    });
  }
}

class ChargeItem {
  final String invoiceDate;
  final String amountDue;
  final String chargeDetails;
  final String paymentStatus;
  final String dueDate;
  final String chargeId;
  final String amount;

  ChargeItem({
    required this.invoiceDate,
    required this.amountDue,
    required this.chargeDetails,
    required this.paymentStatus,
    required this.dueDate,
    required this.chargeId,
    required this.amount,
  });

  factory ChargeItem.fromJson(Map<String, dynamic> json) {
    return ChargeItem(
      invoiceDate: json['INVDATE'],
      amountDue: json['DUEAMOUNT'],
      chargeDetails: json['CHARGEDETAILS'],
      paymentStatus: json['PAYSTATUS'],
      dueDate: json['DUEDATE'],
      chargeId: json['SLNO'],
      amount: json['AMOUNT'],
    );
  }
}

class ChargeItemWidget extends StatelessWidget {
  final ChargeItem chargeItem;

  ChargeItemWidget({required this.chargeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Invoice Date: ${chargeItem.invoiceDate}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount Due: \u{20B9}${chargeItem.amountDue}'),
            Text('Charge Details: ${chargeItem.chargeDetails}'),
            Text('Payment Status: ${chargeItem.paymentStatus}'),
            Text('Due Date: ${chargeItem.dueDate}'),
            Text('Charge ID#: ${chargeItem.chargeId}'),
            Text('Amount: \u{20B9}${chargeItem.amount}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Logic to handle payment
            _handlePayment(context);
          },
          child: Text('Pay now'),
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    // Logic to handle payment
    // This function could navigate to a payment screen or perform some other action.
    print('Payment handled');
  }
}
