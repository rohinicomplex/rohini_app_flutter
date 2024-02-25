import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: ContactsScreen(),
  ));
}

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
            onTap: () {
              _navigateToContactDetail(context, _contacts[index]);
            },
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
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddContact(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _navigateToAddContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactScreen()),
    ).then((value) {
      if (value != null && value is Contact) {
        setState(() {
          _contacts.add(value);
        });
      }
    });
  }

  void _navigateToContactDetail(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactDetailScreen(contact)),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  PhoneType _selectedPhoneType = PhoneType.mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveContact(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      Navigator.pop(
        context,
        Contact(
          name: name,
          phoneNumbers: [
            PhoneNumber(number: phoneNumber, type: _selectedPhoneType),
          ],
        ),
      );
    }
  }
}

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailScreen(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${contact.name}'),
            SizedBox(height: 10),
            Text('Phone Numbers:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contact.phoneNumbers
                  .map(
                    (phoneNumber) => Text(phoneNumber.toString()),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editContact(context);
              },
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                _confirmDeleteContact(context);
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _editContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditContactScreen(contact)),
    );
  }

  void _confirmDeleteContact(BuildContext context) {
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
                _deleteContact(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(BuildContext context) {
    Navigator.of(context).pop(contact);
  }
}

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  EditContactScreen(this.contact);

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  PhoneType _selectedPhoneType = PhoneType.mobile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.name;
    _phoneNumberController.text = widget.contact.phoneNumbers[0].number;
    _selectedPhoneType = widget.contact.phoneNumbers[0].type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveContact(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      Contact updatedContact = Contact(
        name: name,
        phoneNumbers: [
          PhoneNumber(number: phoneNumber, type: _selectedPhoneType),
        ],
      );
      Navigator.pop(context, updatedContact);
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
