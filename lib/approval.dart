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
  const ActivityApproval({super.key});

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

  Future<void> _actionOnActivity(context, id, appr, comm) async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = <String, String>{};
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
        final dynamic data = json.decode(response.body);
        if (data["result"] > 0) {
          _fetchActivities();
        } else {
          _showMessage(context, data["message"]);
        }
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {
      _showMessage(context, e.toString());
    }
  }

  _showMessage(context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  Future<void> _fetchActivities() async {
    String user = await LocalAppStorage().getUserName();
    String token = await LocalAppStorage().getToken();
    Map<String, String> requestHeaders = {'token': token, 'usertk': user};

    var map = <String, String>{};
    map['userid'] = user;
    map['ResultType'] = '1';
    map['StatusType'] = '1';
    List<ActivityItemDTO> l = [];
    try {
      final response = await http.post(
        Uri.parse('https://rohinicomplex.in/service/getActivityList.php'),
        headers: requestHeaders,
        body: map,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          l = data.map((json) => ActivityItemDTO.fromJson(json)).toList();
        } else {
          _showMessage(context, 'Enjoy! Nothing to take action');
        }
      } else {
        throw Exception('Failed to load charge items');
      }
    } catch (e) {
      _showMessage(context, e.toString());
    }
    setState(() {
      // Assigning dummy activities for demonstration
      _activities = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Approval'),
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "Looks like you're free to enjoy your coffee break - no approvals waiting to rain on your parade! ☕️"),
            ))
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                var item = _activities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activity #${item.activityId}'),
                        const SizedBox(height: 8.0),
                        Text('Create Date: ${item.createDate.toString()}'),
                        const SizedBox(height: 8.0),
                        Text('Subject: ${item.subject}'),
                        const SizedBox(height: 8.0),
                        Text('Type: ${item.type}'),
                        const SizedBox(height: 8.0),
                        Text('Description: ${item.description}'),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityDetails(item: item),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor),
                              child: const Text('Details'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _showApproveConfirmationDialog(item);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                _showRejectConfirmationDialog(item);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Reject'),
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
          title: const Text('Confirm Rejection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to reject this activity?'),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Comments'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Implement your reject logic here
                String comments = commentController.text;
                _actionOnActivity(context, item.activityId, 3, comments);

                // Refresh the list
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showApproveConfirmationDialog(ActivityItemDTO item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Approval'),
          content:
              const Text('Are you sure you want to approve this activity?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Implement your approve logic here

                _actionOnActivity(context, item.activityId, 3, 'Approved');
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

  const ActivityDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
