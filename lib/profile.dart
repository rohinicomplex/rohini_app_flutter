import 'dart:html';

import 'package:flutter/material.dart';
import 'storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileImageUrl = 'assets/default_profile_image.jpg';
  String user = '';
  String token = '';
  @override
  Widget build(BuildContext context) {
    LocalAppStorage().getUserName(user);
    LocalAppStorage().getToken(token);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(_profileImageUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfileImage,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Other profile fields
            _buildField('User ID', '12345'),
            SizedBox(height: 20.0),
            _buildField('First Name', 'John'),
            SizedBox(height: 20.0),
            _buildField('Last Name', 'Doe'),
            // Add more fields as needed
            SizedBox(height: 20.0),
            _buildField('Sex', 'Male'),
            SizedBox(height: 20.0),
            _buildField('Date of Birth', '01-01-1990'),
            SizedBox(height: 20.0),
            _buildField('Address', '123 Main St, City, Country'),
            SizedBox(height: 20.0),
            _buildField('PIN', '123456'),
            SizedBox(height: 20.0),
            _buildField('Email', 'john.doe@example.com'),
            SizedBox(height: 20.0),
            _buildField('Phone', '+1234567890'),
            SizedBox(height: 20.0),
            _buildField('Mobile', '+9876543210'),
            SizedBox(height: 20.0),
            _buildField('Whatsapp', '+9876543210'),
            SizedBox(height: 20.0),
            _buildField('Role', 'User'),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  void _changeProfileImage() async {
    // Implement logic to select an image from the gallery
    // Example:
    // final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    // setState(() {
    //   _profileImageUrl = pickedImage.path;
    // });
  }
}
