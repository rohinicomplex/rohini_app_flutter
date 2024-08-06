import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';

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
  String _selectedOption = '';
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  List<Offset> _points = <Offset>[];

  final List<String> _expenseTypes = [
    'Expense Type 1',
    'Expense Type 2',
    'Expense Type 3',
  ];

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
            InkWell(
              onTap: () {
                _showExpenseTypeDialog(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Expense Type',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedExpenseType.isEmpty
                        ? 'Select Expense Type'
                        : _selectedExpenseType),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Payment To'),
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
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: SfSignaturePad(
                  key: _signaturePadKey,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _clearSignature,
                    child: Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: _saveSignature,
                    child: Text('Save'),
                  ),
                ],
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

  void _chooseFileFromSystem() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        print('File picked: ${file.name}');
        // Handle the picked file here
      } else {
        print('User canceled file picking');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void _takePicture() async {
    /* try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      final CameraController cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      await cameraController.initialize();
      final XFile imageFile = await cameraController.takePicture();
      print('Picture taken: ${imageFile.path}');
      // Handle the taken picture here
    } catch (e) {
      print('Error taking picture: $e');
    }*/
  }

  Future<void> _showExpenseTypeDialog(BuildContext context) async {
    final String? selectedType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Expense Type'),
          content: SingleChildScrollView(
            child: Column(
              children: _expenseTypes
                  .map((type) => ListTile(
                        title: Text(type),
                        onTap: () {
                          Navigator.of(context).pop(type);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedType != null) {
      setState(() {
        _selectedExpenseType = selectedType;
      });
    }
  }

  void _importBankTransactions() async {
    final selectedTransaction = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Bank Transaction'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Transaction 1'),
                  onTap: () {
                    Navigator.of(context).pop('Transaction 1');
                  },
                ),
                ListTile(
                  title: Text('Transaction 2'),
                  onTap: () {
                    Navigator.of(context).pop('Transaction 2');
                  },
                ),
                ListTile(
                  title: Text('Transaction 3'),
                  onTap: () {
                    Navigator.of(context).pop('Transaction 3');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedTransaction != null) {
      setState(() {
        // Handle selected transaction
      });
    }
  }

  void _clearSignature() {
    _signaturePadKey.currentState!.clear();
  }

  void _saveSignature() async {
    /* final ui.Image image = await _signaturePadKey.currentState!.toImage();
    final ByteData? bytes =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = bytes!.buffer.asUint8List();
    // Handle the saved signature image here, e.g., upload it to a server or save it locally
    print('Signature saved: ${pngBytes.lengthInBytes} bytes');*/
  }

  void _submitForm() {
    // Add logic to handle form submission, including validation
    print('Form submitted');
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
