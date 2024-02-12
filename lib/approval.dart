import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Approval'),
      ),
      body: ListView.builder(
        itemCount: 10, // Number of activity items
        itemBuilder: (context, index) {
          return ActivityItem();
        },
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity #${DateTime.now().millisecondsSinceEpoch}'),
            SizedBox(height: 8.0),
            Text('Create Date: ${DateTime.now().toString()}'),
            SizedBox(height: 8.0),
            Text('Subject: Sample Subject'),
            SizedBox(height: 8.0),
            Text('Type: Sample Type'),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivityDetailsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text('Details'),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Show reject popup
                    _showRejectPopup(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Reject'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Logic to handle approve action
                    _refreshList(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showRejectPopup(BuildContext context) {
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reject Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Comments'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Logic to handle rejection with comments
              _refreshList(context);
            },
            child: Text('Ok'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _refreshList(BuildContext context) {
  // Logic to refresh the list
  Navigator.pop(context); // Close the dialog
}

class ActivityDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Details Screen Placeholder'),
      ),
    );
  }
}
