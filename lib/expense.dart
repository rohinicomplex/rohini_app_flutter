import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart'; // Import for formatting currency
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseAddScreen extends StatefulWidget {
  @override
  _ExpenseAddScreenState createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  String _selectedExpenseType = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedMode = '';
  String _payeeName = '';
  String _reference = '';
  String _details = '';
  String _receivedBy = '';
  String _selectedOption = '';
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  TextEditingController _amountController = TextEditingController();
  List<String> _expenseTypes = [];
  List<String> _payeeSuggestions = [];
  List<String> _receivedBySuggestions = [];

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    final expenseTypeResponse = await http
        .get(Uri.parse('https://rohinicomplex.in/service/getMExpenseType.php'));
    final payeeResponse = await http.get(
        Uri.parse('https://rohinicomplex.in/services/getPastPaytoExp.php'));
    final receivedByResponse = await http.get(
        Uri.parse('https://rohinicomplex.in/services/getPastReceivedBy.php'));

    if (expenseTypeResponse.statusCode == 200) {
      setState(() {
        _expenseTypes =
            List<String>.from(json.decode(expenseTypeResponse.body));
      });
    }

    if (payeeResponse.statusCode == 200) {
      setState(() {
        _payeeSuggestions = List<String>.from(json.decode(payeeResponse.body));
      });
    }

    if (receivedByResponse.statusCode == 200) {
      setState(() {
        _receivedBySuggestions =
            List<String>.from(json.decode(receivedByResponse.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: [
          IconButton(
            onPressed: _importBankTransactions,
            icon: Icon(Icons.import_export),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Expense Type', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            _buildAutocompleteField(
              label: 'Select Expense Type',
              suggestions: _expenseTypes,
              onChanged: (value) {
                setState(() {
                  _selectedExpenseType = value;
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
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            _buildAutocompleteField(
              label: 'Payment To',
              suggestions: _payeeSuggestions,
              onChanged: (value) {
                setState(() {
                  _payeeName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Reference'),
              onChanged: (value) {
                setState(() {
                  _reference = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Details'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                setState(() {
                  _details = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            _buildAutocompleteField(
              label: 'Received By',
              suggestions: _receivedBySuggestions,
              onChanged: (value) {
                setState(() {
                  _receivedBy = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Select Mode', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Cash'),
                    value: 'Cash',
                    groupValue: _selectedMode,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedMode = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Bank'),
                    value: 'Bank',
                    groupValue: _selectedMode,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedMode = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Select Option', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Voucher'),
                    value: 'Voucher',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Receipt'),
                    value: 'Receipt',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_selectedOption == 'Receipt') ...[
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _chooseFileFromSystem,
                    icon: Icon(Icons.attach_file),
                    label: Text('Select File'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Picture'),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16.0),
            if (_selectedOption == 'Voucher') ...[
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SfSignaturePad(
                  key: _signaturePadKey,
                  backgroundColor: Colors.white,
                  strokeColor: Colors.black,
                  minimumStrokeWidth: 2.0,
                  maximumStrokeWidth: 2.0,
                ),
              ),
              SizedBox(
                  height:
                      16.0), // Gap between the signature panel and the clear button
              ElevatedButton(
                onPressed: _clearSignature,
                child: Text('Clear Signature'),
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Widget _buildAutocompleteField({
    required String label,
    required List<String> suggestions,
    required Function(String) onChanged,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        onChanged(selection);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label),
          onChanged: (value) {
            onChanged(value);
          },
        );
      },
    );
  }

  void _chooseFileFromSystem() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        print('File picked: ${file.name}');
        // Handle file selection
      }
    } catch (e) {
      // Handle errors
    }
  }

  void _takePicture() async {
    // Implement taking picture functionality
  }

  void _importBankTransactions() async {
    // Implement import bank transactions functionality
  }

  void _clearSignature() {
    _signaturePadKey.currentState?.clear();
  }

  void _saveSignature() async {
    final ui.Image? image = await _signaturePadKey.currentState?.toImage();
    if (image != null) {
      /* final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List? uint8List = byteData?.buffer.asUint8List();
      if (uint8List != null) {
        // Save or upload the signature image
      }*/
    }
  }

  void _submitForm() {
    // Implement form submission functionality
  }
}
