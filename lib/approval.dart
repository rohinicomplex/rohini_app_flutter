import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage.dart';

class ActivityItemDTO {
  final String activityId;
  final DateTime createDate;
  final String subject;
  final String type;
  final String description;

  ActivityItemDTO({
    required this.activityId,
    required this.createDate,
    required this.subject,
    required this.type,
    required this.description,
  });

  factory ActivityItemDTO.fromJson(Map<String, dynamic> json) {
    return ActivityItemDTO(
      activityId: json['ACTIVITYID'],
      createDate: DateTime.parse(json['CREATEDON']),
      subject: json['SUBJECT'],
      type: json['ACTIVITYTYPECODE'],
      description: json['DESCRIPTION'],
    );
  }
}

class ActivityApproval extends StatefulWidget {
  @override
  _ActivityApprovalState createState() => _ActivityApprovalState();
}

class _ActivityApprovalState extends State<ActivityApproval> {
  List<ActivityItemDTO> _activities = [];

  @override
  void initState() {
    super.initState();
    // Fetch activities from the server
    _fetchActivities();
  }

  Future<void> _actionOnActivity(id, appr, comm) async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['activityid'] = id;
    map['comments'] = comm;
    map['approvalid'] = appr;
    map['username'] = user;
    List<ActivityItemDTO> l = [];
    try {
      final response = await http.post(
        Uri.parse('https://rohinicomplex.in/service/approveActivity.php'),
        headers: requestHeaders,
        body: map,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        l = data.map((json) => ActivityItemDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {}
    setState(() {
      // Assigning dummy activities for demonstration
      _activities = l;
    });
  }

  Future<void> _fetchActivities() async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = new Map<String, String>();
    map['userid'] = user;
    map['ResultType'] = '2';
    map['StatusType'] = '2';
    List<ActivityItemDTO> l = [];
    try {
      final response = await http.post(
        Uri.parse('https://rohinicomplex.in/service/getActivityList.php'),
        headers: requestHeaders,
        body: map,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        l = data.map((json) => ActivityItemDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {}
    setState(() {
      // Assigning dummy activities for demonstration
      _activities = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Approval'),
      ),
      body: _activities.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                var item = _activities[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activity #${item.activityId}'),
                        SizedBox(height: 8.0),
                        Text('Create Date: ${item.createDate.toString()}'),
                        SizedBox(height: 8.0),
                        Text('Subject: ${item.subject}'),
                        SizedBox(height: 8.0),
                        Text('Type: ${item.type}'),
                        SizedBox(height: 8.0),
                        Text('Description: ${item.description}'),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityDetails(item: item),
                                  ),
                                );
                              },
                              child: Text('Details'),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _showApproveConfirmationDialog();
                              },
                              child: Text('Approve'),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                _showRejectConfirmationDialog(item);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              child: Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showRejectConfirmationDialog(ActivityItemDTO item) {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Rejection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to reject this activity?'),
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comments'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Implement your reject logic here
                String comments = commentController.text;
                print('Reject button pressed with comments: $comments');
                // Refresh the list
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showApproveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Approval'),
          content: Text('Are you sure you want to approve this activity?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Implement your approve logic here
                print('Approve button pressed');
                // Refresh the list
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ActivityDetails extends StatelessWidget {
  final ActivityItemDTO item;

  ActivityDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity ID: ${item.activityId}'),
            Text('Create Date: ${item.createDate.toString()}'),
            Text('Subject: ${item.subject}'),
            Text('Type: ${item.type}'),
            Text('Description: ${item.description}'),
          ],
        ),
      ),
    );
  }
}
