import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String _selectedUser = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  List<String> _userNames = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson'
  ]; // Sample user names

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
              title: Text('Sort'),
              onTap: () {
                _showSortOptions(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                      ),
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
            _selectedUser.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: 5, // Number of invoices
                      itemBuilder: (context, index) {
                        return InvoiceItem();
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
          children: _userNames.map((user) {
            return ListTile(
              title: Text(user),
              onTap: () {
                setState(() {
                  _selectedUser = user;
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
                // Add filter by date logic here
                Navigator.of(context).pop();
              },
              child: Text('Filter'),
            ),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text('Ascending'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_upward),
                  ],
                ),
                onTap: () {
                  // Add ascending sort logic here
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Text('Descending'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_downward),
                  ],
                ),
                onTap: () {
                  // Add descending sort logic here
                  Navigator.of(context).pop();
                },
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
}

class InvoiceItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Payment Date: ${DateTime.now().toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \$100.00'),
                Text('E Bill No: 123456'),
                Text('Bill Date: ${DateTime.now().toString()}'),
                Text('Vide: Sample'),
                Text('Ref. No: ABC123'),
                Text('Status: Pending'),
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
