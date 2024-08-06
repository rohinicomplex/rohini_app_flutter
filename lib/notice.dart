import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTML Viewer'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
          """
            <!DOCTYPE html>
            <html>
            <head>
              <title>Test HTML</title>
            </head>
            <body>
              <h1>Hello, World!</h1>
              <p>This is a paragraph in HTML.</p>
            </body>
            </html>
          """,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
