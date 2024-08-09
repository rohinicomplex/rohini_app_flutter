import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<AContact> _contacts = [];
  List<AContact> _filteredContacts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _fetchContacts() async {
    String user = await LocalAppStorage().getUserName();
    final response = await http.post(
      Uri.parse('https://rohinicomplex.in/service/getAllContacts.php'),
      body: {'userName': user},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _contacts = data.map((contact) => AContact.fromJson(contact)).toList();
        _filteredContacts = _contacts;
      });
    } else {
      // Handle error
      print('Failed to load contacts');
    }
  }

  Future<void> _saveContactToServer(AContact contact) async {
    String user = await LocalAppStorage().getUserName();
    final response = await http.post(
      Uri.parse('https://rohinicomplex.in/service/saveContact.php'),
      body: {
        'id': contact.id ?? '',
        'fname': contact.name,
        'mobile': contact.phoneNumber,
        'userName': user,
        'lname': '',
        'work': '',
        'home': '',
        'email': '',
        'note': '',
        'category': 2,
      },
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact saved successfully')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save contact')),
      );
    }
  }

  Future<void> _deleteContactFromServer(String id) async {
    String user = await LocalAppStorage().getUserName();
    final response = await http.post(
      Uri.parse('https://rohinicomplex.in/service/deleteContact.php'),
      body: {'id': id, 'userName': user},
    );

    if (response.statusCode == 200) {
      // Handle success
      /*String s = json.decode(response.body);
      if(s["status"] == )*/
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact deleted successfully')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete contact')),
      );
    }
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
      if (value != null && value is AContact) {
        setState(() {
          _contacts.add(value);
          _filteredContacts = _contacts;
        });
        _saveContactToServer(value);
      }
    });
  }

  void _navigateToEditContact(
      BuildContext context, AContact contact, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditContactScreen(contact)),
    ).then((value) {
      if (value != null && value is AContact) {
        setState(() {
          _contacts[index] = value;
          _filteredContacts = _contacts;
        });
        _saveContactToServer(value);
      }
    });
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
                _deleteContactFromServer(_contacts[index].id!);
                setState(() {
                  _contacts.removeAt(index);
                  _filteredContacts = _contacts;
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveContactToPhone(AContact contact) async {
    if (await Permission.contacts.request().isGranted) {
      final newContact = Contact()
        ..name.first = contact.name.split(' ')[0]
        ..name.last =
            contact.name.split(' ').length > 1 ? contact.name.split(' ')[1] : ''
        ..phones = [Phone(contact.phoneNumber)];

      await FlutterContacts.insertContact(newContact);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact saved to phone')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts is denied')),
      );
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phoneNumber.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredContacts[index].name),
                  subtitle: GestureDetector(
                    onTap: () {
                      _launchURL('tel:${_filteredContacts[index].phoneNumber}');
                    },
                    child:
                        Text('Phone: ${_filteredContacts[index].phoneNumber}'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () {
                          _launchURL(
                              'tel:${_filteredContacts[index].phoneNumber}');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          _launchURL(
                              'sms:${_filteredContacts[index].phoneNumber}');
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _navigateToEditContact(
                                context, _filteredContacts[index], index);
                          } else if (value == 'delete') {
                            _confirmDeleteContact(context, index);
                          } else if (value == 'save_to_phone') {
                            _saveContactToPhone(_filteredContacts[index]);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Edit', 'Delete', 'Save to Phone'}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice.toLowerCase().replaceAll(' ', '_'),
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddContact(context);
        },
        child: Icon(Icons.add),
      ),
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
        AContact(name: name, phoneNumber: phoneNumber),
      );
    }
  }
}

class EditContactScreen extends StatefulWidget {
  final AContact contact;

  EditContactScreen(this.contact);

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.name;
    _phoneNumberController.text = widget.contact.phoneNumber;
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
        AContact(
          id: widget.contact.id,
          name: name,
          phoneNumber: phoneNumber,
        ),
      );
    }
  }
}

class AContact {
  String? id;
  String name;
  String phoneNumber;

  AContact({this.id, required this.name, required this.phoneNumber});

  factory AContact.fromJson(Map<String, dynamic> json) {
    return AContact(
      id: json['id'] as String?,
      name: json['fname'] as String,
      phoneNumber: json['mobile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
