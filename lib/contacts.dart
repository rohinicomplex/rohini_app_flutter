import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [
    Contact(
      name: 'John Doe',
      phoneNumbers: [
        PhoneNumber(number: '1234567890', type: PhoneType.mobile),
        PhoneNumber(number: '9876543210', type: PhoneType.work),
      ],
    ),
    Contact(
      name: 'Jane Smith',
      phoneNumbers: [
        PhoneNumber(number: '1112223333', type: PhoneType.mobile),
        PhoneNumber(
            number: '4445556666', type: PhoneType.custom, label: 'Home'),
      ],
    ),
  ];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  PhoneType _selectedPhoneType = PhoneType.mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_contacts[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _contacts[index]
                  .phoneNumbers
                  .map((phoneNumber) => GestureDetector(
                        onTap: () {
                          _launchURL(phoneNumber.number);
                        },
                        child: Text(phoneNumber.toString()),
                      ))
                  .toList(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    _launchURL('tel:${_contacts[index].mobileNumber}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    _launchURL('sms:${_contacts[index].mobileNumber}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editContact(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDeleteContact(context, index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addContact(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              DropdownButtonFormField(
                value: _selectedPhoneType,
                items: PhoneType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (type) {
                  setState(() {
                    _selectedPhoneType = type as PhoneType;
                  });
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
            ElevatedButton(
              onPressed: () {
                _saveContact();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveContact() {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      setState(() {
        _contacts.add(
          Contact(
            name: name,
            phoneNumbers: [
              PhoneNumber(number: phoneNumber, type: _selectedPhoneType),
            ],
          ),
        );
        _nameController.clear();
        _phoneNumberController.clear();
        _selectedPhoneType = PhoneType.mobile; // Reset selected phone type
      });
    }
  }

  void _editContact(BuildContext context, int index) {
    _nameController.text = _contacts[index].name;
    _phoneNumberController.text = _contacts[index].mobileNumber;
    _selectedPhoneType = _contacts[index].mobileNumberType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              DropdownButtonFormField(
                value: _selectedPhoneType,
                items: PhoneType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (type) {
                  setState(() {
                    _selectedPhoneType = type as PhoneType;
                  });
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
            ElevatedButton(
              onPressed: () {
                _updateContact(index);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateContact(int index) {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      setState(() {
        _contacts[index].name = name;
        _contacts[index].phoneNumbers = [
          PhoneNumber(number: phoneNumber, type: _selectedPhoneType),
        ];
        _nameController.clear();
        _phoneNumberController.clear();
        _selectedPhoneType = PhoneType.mobile; // Reset selected phone type
      });
    }
  }

  void _confirmDeleteContact(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteContact(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Contact {
  String name;
  List<PhoneNumber> phoneNumbers;

  Contact({required this.name, required this.phoneNumbers});

  String get mobileNumber {
    for (var phoneNumber in phoneNumbers) {
      if (phoneNumber.type == PhoneType.mobile) {
        return phoneNumber.number;
      }
    }
    return '';
  }

  PhoneType get mobileNumberType {
    for (var phoneNumber in phoneNumbers) {
      if (phoneNumber.type == PhoneType.mobile) {
        return phoneNumber.type;
      }
    }
    return PhoneType.mobile;
  }
}

class PhoneNumber {
  String number;
  PhoneType type;
  String? label;

  PhoneNumber({required this.number, required this.type, this.label});

  @override
  String toString() {
    return '${label ?? type.toString().split('.').last}: $number';
  }
}

enum PhoneType { mobile, work, custom }
