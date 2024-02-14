import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> notifications = [
    "Notification 1",
    "Notification 2",
    "Notification 3",
    "Notification 4",
    "Notification 5",
    "Notification 6",
    "Notification 7",
    "Notification 8",
    "Notification 9",
    "Notification 10",
  ];

  void clearNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void clearAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(notifications[index]),
                  onTap: () {
                    // Handle notification tap
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Notification"),
                          content: Text(notifications[index]),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                clearNotification(index);
                                Navigator.of(context).pop();
                              },
                              child: Text("Clear"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: clearAllNotifications,
            child: Text("Clear All Notifications"),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
