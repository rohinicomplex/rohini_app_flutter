import 'package:flutter/material.dart';

class CommunityHallBookingScreen extends StatefulWidget {
  @override
  _CommunityHallBookingScreenState createState() =>
      _CommunityHallBookingScreenState();
}

class _CommunityHallBookingScreenState
    extends State<CommunityHallBookingScreen> {
  List<DateTime> _selectedDates = [];
  TextEditingController _eventNameController = TextEditingController();
  List<Map<String, dynamic>> _bookedEvents = [
    {'date': DateTime.now(), 'eventName': 'Event 1'},
    {'date': DateTime.now().add(Duration(days: 1)), 'eventName': 'Event 2'},
    {'date': DateTime.now().add(Duration(days: 2)), 'eventName': 'Event 3'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Hall Booking'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 1),
              onDateChanged: (date) {
                setState(() {
                  _toggleDateSelection(date);
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _selectedDates.isEmpty
                ? null
                : () {
                    _showAddEventPopup(context);
                  },
            child: Text('Add Event'),
          ),
          SizedBox(height: 20.0),
          Text(
            'Selected Dates:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${_selectedDates[index].day}/${_selectedDates[index].month}/${_selectedDates[index].year}'),
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Upcoming Bookings:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _bookedEvents.length,
              itemBuilder: (context, index) {
                final event = _bookedEvents[index];
                return ListTile(
                  title: Text(
                    '${event['date'].day}/${event['date'].month}/${event['date'].year} - ${event['eventName']}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _confirmDeleteEvent(context, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDateSelection(DateTime date) {
    if (_selectedDates.contains(date)) {
      setState(() {
        _selectedDates.remove(date);
      });
    } else {
      setState(() {
        _selectedDates.add(date);
      });
    }
  }

  void _showAddEventPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selected Dates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedDates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${_selectedDates[index].day}/${_selectedDates[index].month}/${_selectedDates[index].year}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  hintText: 'Enter event name',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEvent();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addEvent() {
    String eventName = _eventNameController.text.trim();
    if (eventName.isNotEmpty) {
      setState(() {
        _bookedEvents.add({
          'date': _selectedDates[0], // Assume only one date is selected
          'eventName': eventName,
        });
        _eventNameController.clear();
        _selectedDates.clear();
      });
    }
  }

  void _confirmDeleteEvent(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteEvent(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      _bookedEvents.removeAt(index);
    });
  }
}
