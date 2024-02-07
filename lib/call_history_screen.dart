import 'package:flutter/material.dart';
import 'call_history.dart';

class CallHistoryScreen extends StatelessWidget {
  final CallHistory callHistory;

  CallHistoryScreen({required this.callHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call History - ${callHistory.contact}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact: ${callHistory.contact}'),
            Text('Number: ${callHistory.number}'),
            Text('Time: ${formatDateTime(callHistory.time)}'),
            Text('Duration: ${callHistory.duration} seconds'),
          ],
        ),
      ),
    );
  }

  String formatDateTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}
