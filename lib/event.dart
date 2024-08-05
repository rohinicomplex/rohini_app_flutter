import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Hall Booking'),
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
            child: const Text('Add Event'),
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Selected Dates:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDates[index])),
                );
              },
            ),
          ),
          const SizedBox(height: 20.0),
          const Text(
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
                    '${DateFormat('dd/MM/yyyy').format(event['date'])} - ${event['eventName']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
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
      // Date is already selected, so deselect it
      setState(() {
        _selectedDates.remove(date);
      });
    } else {
      if (_selectedDates.isEmpty) {
        // Start a new selection
        setState(() {
          _selectedDates.add(date);
        });
      } else {
        DateTime lastSelectedDate = _selectedDates.last;
        if (date.difference(lastSelectedDate).inDays == 1) {
          // Add consecutive date
          setState(() {
            _selectedDates.add(date);
          });
        } else if (date.difference(lastSelectedDate).inDays < 0) {
          // Reset selection if a previous date is selected
          setState(() {
            _selectedDates = [date];
          });
        } else {
          // Prevent non-consecutive date selection
          _showErrorDialog('Please select consecutive dates.');
        }
      }
    }
  }

  void _showAddEventPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selected Dates:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedDates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(DateFormat('dd/MM/yyyy')
                            .format(_selectedDates[index])),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _eventNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter event name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEvent();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addEvent() {
    String eventName = _eventNameController.text.trim();
    if (eventName.isNotEmpty && _selectedDates.isNotEmpty) {
      DateTime eventDate = _selectedDates.first;
      bool isDuplicate = _bookedEvents.any(
        (event) =>
            event['date'] == eventDate && event['eventName'] == eventName,
      );
      if (!isDuplicate) {
        setState(() {
          _bookedEvents.add({
            'date': eventDate,
            'eventName': eventName,
          });
          _eventNameController.clear();
          _selectedDates.clear();
        });
      } else {
        _showErrorDialog(
            'An event with the same name already exists on this date.');
      }
    } else {
      _showErrorDialog(
          'Please select at least one date and enter an event name.');
    }
  }

  void _confirmDeleteEvent(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteEvent(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
