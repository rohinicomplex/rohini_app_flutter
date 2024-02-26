import 'package:flutter/material.dart';

class IntercomScreen extends StatefulWidget {
  @override
  _IntercomScreenState createState() => _IntercomScreenState();
}

class _IntercomScreenState extends State<IntercomScreen> {
  String selectedBlock = 'A';
  int selectedFloor = 1;
  int apartmentCount = 2;

  String phoneNumber = '';

  void addToPhoneNumber(String value) {
    setState(() {
      phoneNumber += value;
    });
  }

  void clearPhoneNumber() {
    setState(() {
      phoneNumber = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intercom Screen'),
      ),
      body: Column(
        children: [
          // Tabs
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(text: 'Dial Pad'),
                      Tab(text: 'Contacts'),
                      Tab(text: 'Apartment'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Dial Pad tab
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              phoneNumber,
                              style: TextStyle(fontSize: 24),
                            ),
                            // Dial Pad grid
                            GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children: List.generate(12, (index) {
                                // Numbers 1 to 9, 0, * and #
                                String label;
                                if (index == 9) {
                                  label = '*';
                                } else if (index == 10) {
                                  label = '0';
                                } else if (index == 11) {
                                  label = '#';
                                } else {
                                  label = (index + 1).toString();
                                }
                                return DialPadButton(
                                  label,
                                  addToPhoneNumber,
                                );
                              }),
                            ),
                            // Call and Clear Buttons
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Call the phone number
                                      print('Calling $phoneNumber');
                                    },
                                    child: Text('Call'),
                                  ),
                                  ElevatedButton(
                                    onPressed: clearPhoneNumber,
                                    child: Text('Clear'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Contacts tab
                        Center(
                          child: Text(
                            'Contacts',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        // Apartment tab
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Select Block text
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Select Block',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // Block selection
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  BlockButton('A', selectedBlock, () {
                                    setState(() {
                                      selectedBlock = 'A';
                                      apartmentCount = 2;
                                    });
                                  }),
                                  BlockButton('B', selectedBlock, () {
                                    setState(() {
                                      selectedBlock = 'B';
                                      apartmentCount = 4;
                                    });
                                  }),
                                  BlockButton('C', selectedBlock, () {
                                    setState(() {
                                      selectedBlock = 'C';
                                      apartmentCount = 2;
                                    });
                                  }),
                                ],
                              ),
                            ),
                            // Select Floor text
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Select Floor',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // Floor selection
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FloorButton(1, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 1;
                                    });
                                    
                                  }),
                                  FloorButton(2, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 2;
                                    });
                                  }),
                                  FloorButton(3, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 3;
                                    });
                                  }),
                                  FloorButton(4, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 4;
                                    });
                                  }),
                                  FloorButton(5, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 5;
                                    });
                                  }),
                                  FloorButton(6, selectedFloor, () {
                                    setState(() {
                                      selectedFloor = 6;
                                    });
                                  }),
                                ],
                              ),
                            ),
                            // Apartment list
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: List.generate(
                                  apartmentCount,
                                  (index) => ApartmentButton(
                                    '${selectedBlock}${selectedFloor}${(index + 1).toString().padLeft(2, '0')}',
                                    () {
                                      // Call the selected apartment
                                      print(
                                          '${selectedBlock}${selectedFloor}${(index + 1).toString().padLeft(2, '0')}');
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Call Gate Buttons
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Call the main gate
                                      print('Calling Main Gate');
                                    },
                                    child: Text('Main Gate'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Call the small gate
                                      print('Calling Small Gate');
                                    },
                                    child: Text('Small Gate'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialPadButton extends StatelessWidget {
  final String text;
  final Function(String) onPressed;

  DialPadButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ElevatedButton(
          onPressed: () => onPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class BlockButton extends StatelessWidget {
  final String text;
  final String selectedBlock;
  final VoidCallback onPressed;

  BlockButton(this.text, this.selectedBlock, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: selectedBlock == text
            ? Theme.of(context).primaryColor
            : Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class FloorButton extends StatelessWidget {
  final int floor;
  final int selectedFloor;
  final VoidCallback onPressed;

  FloorButton(this.floor, this.selectedFloor, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: selectedFloor == floor
            ? Theme.of(context).primaryColor
            : Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      child: Text(
        '$floor',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class ApartmentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ApartmentButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
