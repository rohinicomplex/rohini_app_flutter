import 'package:flutter/material.dart';

// Model class to represent the data received from the REST service
class InvoiceItemDTO {
  final String activityId;
  final DateTime createDate;
  final String subject;
  final String type;

  InvoiceItemDTO({
    required this.activityId,
    required this.createDate,
    required this.subject,
    required this.type,
  });
}

// Sample function to fetch data from REST service
Future<List<InvoiceItemDTO>> fetchInvoiceItems() async {
  // Here you would make your HTTP request to fetch the data
  // For now, I'll just return a sample list of InvoiceItemDTO objects
  return List.generate(
    10,
    (index) => InvoiceItemDTO(
      activityId: 'Activity #$index',
      createDate: DateTime.now(),
      subject: 'Sample Subject',
      type: 'Sample Type',
    ),
  );
}

class ApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InvoiceItemDTO>>(
      future: fetchInvoiceItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<InvoiceItemDTO>? invoiceItems = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Activity Approval'),
            ),
            body: ListView.builder(
              itemCount: invoiceItems!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ActivityDetailsScreen(invoiceItems[index]),
                      ),
                    );
                  },
                  child: ActivityItem(
                    invoiceItem: invoiceItems[index],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class ActivityItem extends StatelessWidget {
  final InvoiceItemDTO invoiceItem;

  ActivityItem({required this.invoiceItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity #${invoiceItem.activityId}'),
            SizedBox(height: 8.0),
            Text('Create Date: ${invoiceItem.createDate.toString()}'),
            SizedBox(height: 8.0),
            Text('Subject: ${invoiceItem.subject}'),
            SizedBox(height: 8.0),
            Text('Type: ${invoiceItem.type}'),
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
                              builder: (context) =>
                                  ActivityDetailsScreen(invoiceItem)),
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
}

class ActivityDetailsScreen extends StatelessWidget {
  final InvoiceItemDTO invoiceItem;

  ActivityDetailsScreen(this.invoiceItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity ID: ${invoiceItem.activityId}'),
            SizedBox(height: 8.0),
            Text('Create Date: ${invoiceItem.createDate.toString()}'),
            SizedBox(height: 8.0),
            Text('Subject: ${invoiceItem.subject}'),
            SizedBox(height: 8.0),
            Text('Type: ${invoiceItem.type}'),
          ],
        ),
      ),
    );
  }
}
