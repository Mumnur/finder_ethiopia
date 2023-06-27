import 'package:finder/screens/chat/messagec/message_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MessagePage extends StatefulWidget {
  final String receiver;

  MessagePage({required this.receiver});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _retrieveToken().then((_accessToken) {
      setState(() {
        _accessToken = _accessToken;
      });
      _fetchMessages();
    });
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
      print('Access Token: $_accessToken');
    });
  }

  Future<void> _fetchMessages() async {
    final response = await http.get(
      Uri.parse('https://finderastu.pythonanywhere.com/get-message/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Messages fetched successfully
      try {
        List<dynamic> messages = jsonDecode(response.body);
        List<String> fetchedMessages =
            messages.map((message) => message['content'].toString()).toList();
        setState(() {
          _messages = fetchedMessages.reversed.toList();
        });
      } catch (e) {
        // Error parsing the response body
        print('Error parsing response: $e');
      }
    } else {
      // Failed to fetch messages, handle the error
      print('Failed to fetch messages');
    }
  }

  Future<void> sendMessage(String content) async {
    String receiver = widget.receiver;

    if (receiver == _accessToken) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Cannot send a message to oneself.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://finderastu.pythonanywhere.com/send-message/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({
        'rec': receiver,
        'content': content,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Message sent successfully
      print('Message sent successfully');
      setState(() {
        _messages.insert(0, '$receiver: $content');
        _messageController.clear();
      });
    } else {
      // Failed to send message, handle the error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send message.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, // Display messages in reverse order
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isSent = message.startsWith(widget.receiver);
                  final alignment =
                      isSent ? Alignment.topRight : Alignment.topLeft;
                  final color = isSent ? Colors.blue : Colors.green;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessageDetailPage(rec: widget.receiver),
                        ),
                      );
                    },
                    child: Container(
                      alignment: alignment,
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
