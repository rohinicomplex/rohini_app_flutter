import 'package:flutter/material.dart';
import 'storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileImageUrl = 'assets/default_profile_image.jpg';
  List<dynamic> testdata = [];
  String roleNames = '';
  _ProfilePageState() {
    _getUserData();
  }
  @override
  Widget build(BuildContext context) {
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
            _buildField('User ID', testdata[0]['USERNAME']),
            SizedBox(height: 20.0),
            _buildField('First Name', testdata[0]['FNAME']),
            SizedBox(height: 20.0),
            _buildField('Middle Name', testdata[0]['MNAME']),

            SizedBox(height: 20.0),
            _buildField('Last Name', testdata[0]['LNAME']),
            // Add more fields as needed
            SizedBox(height: 20.0),
            _buildField('Sex', testdata[0]['sex']),
            SizedBox(height: 20.0),
            _buildField('Date of Birth', testdata[0]['DOB']),
            SizedBox(height: 20.0),
            _buildField('Address', testdata[0]['ADDRESS']),
            SizedBox(height: 20.0),
            _buildField('PIN', testdata[0]['PIN']),
            SizedBox(height: 20.0),
            _buildField('Email', testdata[0]['EMAIL']),
            SizedBox(height: 20.0),
            _buildField('Phone', testdata[0]['PHONE']),
            SizedBox(height: 20.0),
            _buildField('Mobile', testdata[0]['MOBILENUMBER']),
            SizedBox(height: 20.0),
            _buildField('Whatsapp', testdata[0]['WANUMBER']),
            SizedBox(height: 20.0),
            _buildField('Role', roleNames),
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

  Future<Map<String, String>> _getUserData() async {
    String user;
    String token;

    user = await LocalAppStorage().getUserName();
    token = await LocalAppStorage().getToken();
    var returnMap = new Map<String, String>();
    var map = new Map<String, String>();
    map['userName'] = user;

    Map<String, String> requestHeaders = {'token': token, 'usertk': user};
    var url = Uri.parse('https://rohinicomplex.in/service/getOwnProfile.php');
    try {
      var response = await http.post(
        url,
        headers: requestHeaders,
        body: map,
      );
      if (response.statusCode == 200) {
        // Request successful, parse the response data
        print("success");
        setState(() {
          var data = json.decode(response.body);
          testdata = data["profileData"];
          var roles = data['roles'];
          var roleString = '';
          for (var e in roles) {
            roleString = roleString + e["ROLENAME"] + ",";
          }
          roleNames = roleString;
        });

        //print(response.body);
      } else {
        // Request failed with a non-200 status code
        print("success2");
      }
    } catch (e) {
      // An error occurred during the request

      print("fail");
    }
    return returnMap;
  }
}
