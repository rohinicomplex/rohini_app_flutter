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
  List<String> _bookedEvents = []; // Sample booked events

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
                return ListTile(
                  title: Text(_bookedEvents[index]),
                  // Add other event details if needed
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
        _bookedEvents.add(eventName);
        _eventNameController.clear();
        _selectedDates.clear(); // Clear selected dates after adding event
      });
    }
  }
}
