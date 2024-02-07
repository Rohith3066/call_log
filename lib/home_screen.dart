import 'package:flutter/material.dart';
import 'contact.dart';
import 'call_history.dart';
import 'contact_details_screen.dart';
import 'call_history_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> allContacts = [
    Contact(name: 'John Doe', info: '123-456-7890', callHistory: []),
    Contact(name: 'Jane Smith', info: '987-654-3210', callHistory: []),
    Contact(name: 'Bob Johnson', info: '567-890-1234', callHistory: []),
    Contact(name: 'Alice Williams', info: '456-789-0123', callHistory: []),
    Contact(name: 'Charlie Brown', info: '789-012-3456', callHistory: []),
  ];

  List<Contact> favoriteContacts = [
    Contact(name: 'John Doe', info: '123-456-7890', callHistory: []),
    Contact(name: 'Alice Williams', info: '456-789-0123', callHistory: []),
    Contact(name: 'Shyam Vinay', info: '111-222-3333', callHistory: []),
  ];

  List<CallHistory> recentCalls = [
    CallHistory(
      contact: 'Jane Smith',
      number: '987-654-3210',
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      duration: 35,
    ),
    CallHistory(
      contact: 'Alice Williams',
      number: '456-789-0123',
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      duration: 55,
    ),
  ];

  List<Contact> displayedContacts = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    requestPermission();
    displayedContacts = favoriteContacts;
  }

  Future<void> requestPermission() async {
    if (await Permission.phone.request().isGranted) {
      // Permission granted, proceed with the app
    } else {
      // Permission not granted, show a dialog or handle accordingly
      // For simplicity, you can just print a message
      print('Phone call permission not granted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 97, 173, 235),
        title: Text('call_log'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterContacts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: currentIndex == 1
                ? buildCallHistoryList(recentCalls)
                : buildContactList(displayedContacts),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(Icons.star),
          ),
          BottomNavigationBarItem(
            label: 'Call History',
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: 'Contacts',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            switch (index) {
              case 0:
                displayedContacts = favoriteContacts;
                break;
              case 1:
                displayedContacts = recentCalls.map((call) {
                  return Contact(
                    name: call.contact,
                    info: call.number,
                    callHistory: [call],
                  );
                }).toList();
                break;
              case 2:
                displayedContacts = allContacts;
                break;
            }
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter Phone Number'),
                content: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle the phone number input
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.dialpad),
      ),
    );
  }

  Widget buildContactList(List<Contact> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(contacts[index].name),
          subtitle: Text(contacts[index].info),
          trailing: IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              addCallHistory(contacts[index].name, contacts[index].info);
              print('Calling ${contacts[index].name}');
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailsScreen(
                  contact: contacts[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCallHistoryList(List<CallHistory> calls) {
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(calls[index].contact),
          subtitle: Text(
              'Time: ${formatDateTime(calls[index].time)}, Duration: ${calls[index].duration} seconds'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CallHistoryScreen(callHistory: calls[index]),
              ),
            );
          },
        );
      },
    );
  }

  void filterContacts(String query) {
    List<Contact> filteredContacts = displayedContacts
        .where((contact) =>
            contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      displayedContacts = filteredContacts;
    });
  }

  void addCallHistory(String contactName, String contactInfo) {
    CallHistory history = CallHistory(
      contact: contactName,
      number: contactInfo,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      duration: 30,
    );

    setState(() {
      recentCalls.insert(0, history);
    });
  }

  String formatDateTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}
