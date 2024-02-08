import 'package:flutter/material.dart';
import 'contact.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailsScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details - ${contact.name}'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${contact.name}'),
            Text('Info: ${contact.info}'),
          ],
        ),
      ),
    );
  }
}
