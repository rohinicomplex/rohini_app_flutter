import 'dart:convert';

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
    final response = await http.post(
      Uri.parse('https://rohinicomplex.in/service/getNotice.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({}), // Add any necessary parameters here
    );

    if (response.statusCode == 200) {
      setState(() {
        // Decode the base64 encoded response body
        _htmlContent = utf8.decode(base64Decode(response.body));
      });
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
