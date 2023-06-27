import 'package:flutter/material.dart';

class UserCommunicationPage extends StatelessWidget {
  final String user;
  final List<String> communication;

  UserCommunicationPage({required this.user, required this.communication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user),
      ),
      body: ListView.builder(
        itemCount: communication.length,
        itemBuilder: (context, index) {
          final message = communication[index];

          return Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.0),
            ),
          );
        },
      ),
    );
  }
}
