import 'package:flutter/material.dart';

class LedgerScreen extends StatefulWidget {
  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  String _selectedFinancialYear = '2023-24';
  String _selectedPeriod = 'YLY';

  List<DataRow> _incomeRows = [
    DataRow(cells: [
      DataCell(Text('Item 1')),
      DataCell(Text('\$100')),
    ]),
    DataRow(cells: [
      DataCell(Text('Item 2')),
      DataCell(Text('\$200')),
    ]),
    DataRow(cells: [
      DataCell(Text('Item 3')),
      DataCell(Text('\$300')),
    ]),
  ];

  List<DataRow> _expenseRows = [
    DataRow(cells: [
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
    ]),
  ];

  List<DataRow> _discountRows = [
    DataRow(cells: [
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
    ]),
  ];

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
                items: ['2023-24', '2022-23', '2021-22']
                    .map<DropdownMenuItem<String>>(
                      (year) => DropdownMenuItem<String>(
                        value: year,
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
                  height: 400,
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

  void _showLedger() {
    // Implement logic to display ledger based on selected financial year and period
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
}
