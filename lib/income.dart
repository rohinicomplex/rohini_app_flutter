import 'package:flutter/material.dart';

class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});
}

class CustomerSelectionScreen extends StatefulWidget {
  @override
  _CustomerSelectionScreenState createState() =>
      _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  final List<Customer> customers = [
    Customer(id: 1, name: 'Customer 1'),
    Customer(id: 2, name: 'Customer 2'),
    Customer(id: 3, name: 'Customer 3'),
  ];

  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    filteredCustomers = customers;
  }

  void filterCustomers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredCustomers = customers
            .where((customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredCustomers = customers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Selection'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterCustomers(value),
              decoration: InputDecoration(
                labelText: 'Search Customer',
                hintText: 'Enter customer name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return ListTile(
                  title: Text(customer.name),
                  onTap: () {
                    Navigator.pushNamed(context, '/chargesel',
                        arguments: customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//charge

class Charge {
  final int id;
  final String chargeDetails;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final double amount;
  final double amountDue;

  Charge({
    required this.id,
    required this.chargeDetails,
    required this.invoiceDate,
    required this.dueDate,
    required this.amount,
    required this.amountDue,
  });
}

class ChargesSelectionScreen extends StatefulWidget {
  @override
  _ChargesSelectionScreenState createState() => _ChargesSelectionScreenState();
}

class _ChargesSelectionScreenState extends State<ChargesSelectionScreen> {
  final List<Charge> charges = [
    Charge(
      id: 1,
      chargeDetails: 'Charge 1',
      invoiceDate: DateTime(2022, 12, 10),
      dueDate: DateTime(2022, 12, 20),
      amount: 100.0,
      amountDue: 50.0,
    ),
    Charge(
      id: 2,
      chargeDetails: 'Charge 2',
      invoiceDate: DateTime(2022, 12, 15),
      dueDate: DateTime(2022, 12, 25),
      amount: 150.0,
      amountDue: 75.0,
    ),
    Charge(
      id: 3,
      chargeDetails: 'Charge 3',
      invoiceDate: DateTime(2022, 12, 20),
      dueDate: DateTime(2022, 12, 30),
      amount: 200.0,
      amountDue: 100.0,
    ),
  ];

  List<int> selectedCharges = [];

  void _showChargeDetails(Charge charge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Charge Details',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${charge.id}'),
              Text('Charge Details: ${charge.chargeDetails}'),
              Text('Invoice Date: ${charge.invoiceDate.toString()}'),
              Text('Due Date: ${charge.dueDate.toString()}'),
              Text('Amount: \$${charge.amount.toStringAsFixed(2)}'),
              Text('Amount Due: \$${charge.amountDue.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charges Selection'),
      ),
      body: ListView.builder(
        itemCount: charges.length,
        itemBuilder: (context, index) {
          final charge = charges[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.info, color: Theme.of(context).primaryColor),
              onPressed: () {
                _showChargeDetails(charge);
              },
            ),
            title: Text(charge.chargeDetails),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice Date: ${charge.invoiceDate.toString()}'),
                Text('Amount Due: \$${charge.amountDue.toStringAsFixed(2)}'),
              ],
            ),
            trailing: Checkbox(
              value: selectedCharges.contains(charge.id),
              onChanged: (checked) {
                setState(() {
                  if (checked!) {
                    selectedCharges.add(charge.id);
                  } else {
                    selectedCharges.remove(charge.id);
                  }
                });
              },
            ),
            onTap: () {
              setState(() {
                if (selectedCharges.contains(charge.id)) {
                  selectedCharges.remove(charge.id);
                } else {
                  selectedCharges.add(charge.id);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/payment_details',
              arguments: selectedCharges);
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class PaymentDetailsScreen extends StatefulWidget {
  final List<int> selectedCharges;

  PaymentDetailsScreen({required this.selectedCharges});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String billNumber = '';
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String paymentMode = 'Cash';
  String reference = '';
  bool applyDiscount = false;
  String discountReason = '';
  String distributionMethod = '';

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _applyDiscount(bool value) {
    setState(() {
      applyDiscount = value;
    });
  }

  void _distributePayment(String method) {
    setState(() {
      distributionMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Bill Number'),
              onChanged: (value) {
                setState(() {
                  billNumber = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: paymentMode,
              onChanged: (value) {
                setState(() {
                  paymentMode = value!;
                });
              },
              items: ['Cash', 'Bank']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Payment Mode'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Reference'),
              onChanged: (value) {
                setState(() {
                  reference = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Apply Discount'),
                Switch(
                  value: applyDiscount,
                  onChanged: _applyDiscount,
                ),
              ],
            ),
            if (applyDiscount) ...[
              TextFormField(
                decoration: InputDecoration(labelText: 'Discount Reason'),
                onChanged: (value) {
                  setState(() {
                    discountReason = value;
                  });
                },
              ),
            ],
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _distributePayment('Distribute top to down');
                  },
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Distribute Top to Down'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _distributePayment('Distribute evenly');
                  },
                  icon: Icon(Icons.compare_arrows),
                  label: Text('Distribute Evenly'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _distributePayment('Distribute proportionately');
                  },
                  icon: Icon(Icons.format_align_center),
                  label: Text('Distribute Proportionately'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _distributePayment('Discount remaining Amount');
                  },
                  icon: Icon(Icons.money_off),
                  label: Text('Discount Remaining Amount'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement payment submission
                Navigator.pushNamed(context, '/summary');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentDistributionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Distribution'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/summary');
          },
          child: Text('Distribute Payment'),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Summary'),
      ),
      body: Center(
        child: Text('Summary Screen'),
      ),
    );
  }
}
