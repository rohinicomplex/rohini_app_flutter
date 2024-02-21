import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage.dart';

class LedgerScreen extends StatefulWidget {
  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  _LedgerScreenState() {
    _getFYs();
  }
  String _selectedFinancialYear = '2023';
  String _selectedPeriod = 'YLY';

  List<DataRow> _incomeRows = [];

  List<DataRow> _expenseRows = [
    /*DataRow(cells: [
      DataCell(Text('Expense 1')),
      DataCell(Text('\$50')),
    ]),
    DataRow(cells: [
      DataCell(Text('Expense 2')),
      DataCell(Text('\$150')),
    ]),
    DataRow(cells: [
      DataCell(Text('Expense 3')),
      DataCell(Text('\$250')),
    ]),*/
  ];

  List<DataRow> _discountRows = [
    /*DataRow(cells: [
      DataCell(Text('Discount 1')),
      DataCell(Text('\$10')),
    ]),
    DataRow(cells: [
      DataCell(Text('Discount 2')),
      DataCell(Text('\$20')),
    ]),
    DataRow(cells: [
      DataCell(Text('Discount 3')),
      DataCell(Text('\$30')),
    ]), */
  ];

  List<String> fys = [];
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: _selectedFinancialYear,
                onChanged: (newValue) {
                  setState(() {
                    _selectedFinancialYear = newValue!;
                  });
                },
                items: fys
                    .map<DropdownMenuItem<String>>(
                      (year) => DropdownMenuItem<String>(
                        value: year.substring(0, 4),
                        child: Text(year),
                      ),
                    )
                    .toList(),
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                  });
                },
                items: ['YLY', 'HY', 'Q1', 'Q2', 'Q3', 'Q4']
                    .map<DropdownMenuItem<String>>(
                      (period) => DropdownMenuItem<String>(
                        value: period,
                        child: Text(period),
                      ),
                    )
                    .toList(),
              ),
              ElevatedButton(
                onPressed: _showLedger,
                child: Text('Show'),
              ),
            ],
          ),
          SizedBox(height: 20),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  tabs: [
                    Tab(text: 'Income'),
                    Tab(text: 'Expense'),
                    Tab(text: 'Discount'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: TabBarView(
                    children: [
                      _buildTable(_incomeRows),
                      _buildTable(_expenseRows),
                      _buildTable(_discountRows),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLedger() async {
    // Mock data for demonstration purposes

    // Implement logic to display ledger based on selected financial year and period
    String user;
    String token;

    user = await LocalAppStorage().getUserName();
    token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['FY'] = _selectedFinancialYear;
    map['REPORTFOR'] = _selectedPeriod;
    map['PendingTxn'] = 'false';
    map['userid'] = user;
    List<DataRow> disctableData = [];
    List<DataRow> incomeTableData = [];
    List<DataRow> expensetableData = [];
    var url = Uri.parse('https://rohinicomplex.in/service/getLedgerData.php');
    try {
      var response = await http.post(
        url,
        headers: requestHeaders,
        body: map,
      );
      if (response.statusCode == 200) {
        // Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
        var data = json.decode(response.body);
        List disc = data['discountDtl'];
        List income = data['incomecat'];
        List expense = data['expenses'];

        _discountRows.clear();

        for (var i = 0; i < disc.length; i++) {
          disctableData.add(DataRow(cells: [
            DataCell(Text(disc[i]['Reason'])),
            DataCell(Text('\u{20B9}' + disc[i]['Amount']))
          ]));
        }

        _incomeRows.clear();
        for (var i = 0; i < income.length; i++) {
          incomeTableData.add(DataRow(cells: [
            DataCell(Text(income[i]['DESCRIPTION'])),
            DataCell(Text('\u{20B9}' + income[i]['AMOUNT']))
          ]));
        }
        _expenseRows.clear();
        for (var i = 0; i < expense.length; i++) {
          expensetableData.add(DataRow(cells: [
            DataCell(Text(expense[i]['DESCRPTION'])),
            DataCell(Text('\u{20B9}' + expense[i]['AMOUNT']))
          ]));
        }
      }
    } catch (e) {
      // An error occurred during the request

      print("fail $e");
    }

    // Update the tables with the new data
    setState(() {
      // Assuming each table corresponds to a specific index in tableData
      // 0 -> Income, 1 -> Expense, 2 -> Discount
      // You can modify this logic based on your actual requirements
      _incomeRows = incomeTableData;
      _expenseRows = expensetableData;
      _discountRows = disctableData;
    });
  }

  Widget _buildTable(List<DataRow> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortColumnIndex: 0,
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
            label: Text('Description'),
            onSort: (columnIndex, ascending) {
              setState(() {
                _sortAscending = ascending;
                rows.sort((a, b) {
                  if (ascending) {
                    return a.cells[columnIndex].child!
                        .toString()
                        .compareTo(b.cells[columnIndex].child!.toString());
                  } else {
                    return b.cells[columnIndex].child!
                        .toString()
                        .compareTo(a.cells[columnIndex].child!.toString());
                  }
                });
              });
            },
          ),
          DataColumn(
            label: Text('Amount'),
            numeric: true,
            onSort: (columnIndex, ascending) {
              setState(() {
                _sortAscending = ascending;
                rows.sort((a, b) {
                  if (ascending) {
                    return _getAmount(a).compareTo(_getAmount(b));
                  } else {
                    return _getAmount(b).compareTo(_getAmount(a));
                  }
                });
              });
            },
          ),
        ],
        rows: rows,
      ),
    );
  }

  int _getAmount(DataRow row) {
    final amountText = row.cells[1].child!.toString();
    return int.parse(amountText.replaceAll(RegExp(r'\D'), ''));
  }

  void _getFYs() async {
    final now = DateTime.now();
    int y = now.year;
    fys.clear();
    if (now.month < 4) {
      y--;
    }
    _selectedFinancialYear = y.toString();
    //'' + y.toString() + '-' + (y + 1 - 2000).toString();
    while (y > 2018) {
      fys.add('' + y.toString() + '-' + (y + 1 - 2000).toString());
      y--;
    }
    //_selectedFinancialYear = '' + y.toString() + '-' + (y - 2000).toString();
  }
}
