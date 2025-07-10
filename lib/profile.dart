import 'package:flutter/material.dart';
import 'storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _profileImageUrl = 'assets/default_profile_image.jpg';
  List<dynamic> testdata = [];
  String roleNames = '';
  _ProfilePageState() {
    _getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                        padding: const EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
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
            const SizedBox(height: 20.0),
            // Other profile fields
            _buildField('User ID', testdata[0]['USERNAME']),
            const SizedBox(height: 20.0),
            _buildField('First Name', testdata[0]['FNAME']),
            const SizedBox(height: 20.0),
            _buildField('Middle Name', testdata[0]['MNAME']),

            const SizedBox(height: 20.0),
            _buildField('Last Name', testdata[0]['LNAME']),
            // Add more fields as needed
            const SizedBox(height: 20.0),
            _buildField('Sex', testdata[0]['sex']),
            const SizedBox(height: 20.0),
            _buildField('Date of Birth', testdata[0]['DOB']),
            const SizedBox(height: 20.0),
            _buildField('Address', testdata[0]['ADDRESS']),
            const SizedBox(height: 20.0),
            _buildField('PIN', testdata[0]['PIN']),
            const SizedBox(height: 20.0),
            _buildField('Email', testdata[0]['EMAIL']),
            const SizedBox(height: 20.0),
            _buildField('Phone', testdata[0]['PHONE']),
            const SizedBox(height: 20.0),
            _buildField('Mobile', testdata[0]['MOBILENUMBER']),
            const SizedBox(height: 20.0),
            _buildField('Whatsapp', testdata[0]['WANUMBER']),
            const SizedBox(height: 20.0),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          value,
          style: const TextStyle(
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
    var returnMap = <String, String>{};
    var map = <String, String>{};
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
            roleString = "${roleString + e["ROLENAME"]},";
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
