import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String _selectedUserId = '';
  List<User> _users = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  String _searchText = '';
  String _buttonTxt = 'Select User';

  TextEditingController _searchController = TextEditingController();
  List<InvoiceItem> _invoiceItems = [];
  List<InvoiceItem> _allInvoiceItems = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();

    _fetchInvoiceItems("0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Filter',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
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
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add filter logic here
                    _filterInvoiceItems();
                    Navigator.of(context).pop();
                  },
                  child: Text('Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fromDate = null;
                      _toDate = null;
                      _searchText = '';
                      _searchController.text = '';
                      _filterInvoiceItems();
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
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
                _buttonTxt,
                style: TextStyle(fontSize: 18.0), // Increased font size
              ),
            ),
            SizedBox(height: 20.0),
            _selectedUserId.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _invoiceItems.length,
                      itemBuilder: (context, index) {
                        return InvoiceItemWidget(
                          chargeItem: _invoiceItems[index],
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
                  _buttonTxt = user.name;
                  _fetchInvoiceItems(user.id);
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          }).toList(),
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

  void _fetchInvoiceItems(String selUser) async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['userName'] = user;

    var _url = 'https://rohinicomplex.in/service/getBillByUserName.php';
    if (selUser != "0") {
      // print("test");
      map['userID'] = selUser;
      _url = 'https://rohinicomplex.in/service/getBillByUserID.php';
    } else {
      _selectedUserId = "0";
    }
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: requestHeaders,
        body: map,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allInvoiceItems =
              data.map((json) => InvoiceItem.fromJson(json)).toList();
          _invoiceItems = _allInvoiceItems;

          _fromDate = null;
          _toDate = null;
          _searchText = '';
          _searchController.text = '';
        });
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {}
  }

  void _filterInvoiceItems() {
    // Filter charge items based on selected dates and search text
    // Update _chargeItems accordingly
    List<InvoiceItem> _filteredChargeItems = [];

    if (!_searchText.isEmpty) {
      for (var i = 0; i < _allInvoiceItems.length; i++) {
        if (_allInvoiceItems[i].refNo.contains(_searchController.text)) {
          _filteredChargeItems.add(_allInvoiceItems[i]);
        }
      }
    } else {
      _filteredChargeItems.addAll(_allInvoiceItems);
    }
    var dateFormat = DateFormat('yyyy-MM-dd');
    if (_fromDate != null) {
      var k = DateUtils.dateOnly(_fromDate as DateTime);

      for (var i = _filteredChargeItems.length - 1; i >= 0; i--) {
        if (dateFormat.parse(_filteredChargeItems[i].paymentDate).isBefore(k)) {
          _filteredChargeItems.remove(_filteredChargeItems[i]);
        }
      }
    }

    if (_toDate != null) {
      var k = DateUtils.dateOnly(_toDate as DateTime);

      for (var i = _filteredChargeItems.length - 1; i >= 0; i--) {
        if (dateFormat.parse(_filteredChargeItems[i].paymentDate).isAfter(k)) {
          _filteredChargeItems.remove(_filteredChargeItems[i]);
        }
      }
    }
    setState(() {
      _invoiceItems = _filteredChargeItems;
    });
  }
}

class InvoiceItem {
  final String paymentDate;
  final String ebillNo;
  final String refNo;
  final String paymentStatus;
  final String vide;
  final String billDate;
  final String amount;

  InvoiceItem({
    required this.paymentDate,
    required this.ebillNo,
    required this.refNo,
    required this.paymentStatus,
    required this.vide,
    required this.billDate,
    required this.amount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      paymentDate: json['PAYMENTDATE'],
      ebillNo: json['EBILLNO'],
      refNo: json['REFNO'],
      paymentStatus: json['STATUS'],
      vide: json['VIDE'],
      billDate: json['BILLDATE'],
      amount: json['AMOUNT'],
    );
  }
}

class InvoiceItemWidget extends StatelessWidget {
  final InvoiceItem chargeItem;

  InvoiceItemWidget({required this.chargeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Payment Date: ${chargeItem.paymentDate}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \u{20B9}${chargeItem.amount}'),
                Text('E Bill No: ${chargeItem.ebillNo}'),
                Text('Bill Date: ${chargeItem.billDate}'),
                Text('Vide: ${chargeItem.vide}'),
                Text('Ref. No: ${chargeItem.refNo}'),
                Text('Status: ${chargeItem.paymentStatus}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0), // Adjust the padding as needed
            child: ElevatedButton(
              onPressed: () {
                // Logic to download receipt
                _downloadReceipt(context);
              },
              child: Text('Download Receipt'),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReceipt(BuildContext context) {
    // Logic to download receipt
    // This function could navigate to a page to download the receipt or perform other actions.
    print('Receipt downloaded');
  }
}
