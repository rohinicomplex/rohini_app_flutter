import 'package:flutter/material.dart';
//import 'package:flutter_html_view/flutter_html_view.dart';

class NoticeScreen extends StatelessWidget {
  @override
  final String htmlcontent = """
    <h1>Hello </h1>
    <h2 style='color:red'>World</h2>
    <p>This is sample paragraph</p>
    <p> H<sup>2</sup>O </p>
    <p> A<sub>2</sub> </p>
    <i>italic</i> <b>bold</b> <u>underline</u> <s>strike </s>
    <ul>
      <li>Item 1</li>
      <li>Item 2</li>
      <li>Item 3</li>
    </ul>
    <br><br>
    <img src="https://vrsofttech.com/flutter-tutorials/images/vr.png" width="100">
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
