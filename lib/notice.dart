import 'dart:convert';
import 'storage.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  String _htmlContent = '<html><body><h1>Loading...</h1></body></html>';

  @override
  void initState() {
    super.initState();
    _fetchNotice();
  }

  Future<void> _fetchNotice() async {
    setState(() {
      _htmlContent = '<html><body><h1>Fetch called...</h1></body></html>';
    });
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['userName'] = user;
    final response = await http.post(
      Uri.parse('https://rohinicomplex.in/service/getNotice.php'),
      headers: requestHeaders,
      body: map,
    );
    setState(() {
      _htmlContent = '<html><body><h1>Parsed...</h1></body></html>';
    });
    if (response.statusCode == 200) {
      setState(() {
        _htmlContent = '<html><body><h1>status 200...</h1></body></html>';
      });
      final List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty && jsonResponse[0]['content'] != null) {
        final String base64Content = jsonResponse[0]['content'];
        setState(() {
          _htmlContent =
              '<html><body><h1>' + base64Content + '</h1></body></html>';
        });
        final String decodedContent = utf8.decode(base64Decode(base64Content));
        setState(() {
          _htmlContent = decodedContent;
        });
      } else {
        setState(() {
          _htmlContent =
              '<html><body><h1>No content available</h1></body></html>';
        });
      }
    } else {
      setState(() {
        _htmlContent =
            '<html><body><h1>Error loading notice</h1></body></html>';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice Board'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
          _htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
