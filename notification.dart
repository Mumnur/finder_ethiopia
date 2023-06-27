import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = [];
  String? _accessToken;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _retrieveToken().then((_accessToken) {
      setState(() {
        _accessToken = _accessToken;
      });
      _fetchNotifications();
    });

    // Initialize the notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
      print('Access Token: $_accessToken');
    });
  }

  // Modify the _fetchNotifications method
  void _fetchNotifications() {
    final response = http.get(
      Uri.parse('https://finderastu.pythonanywhere.com/getnotfication/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
    );

    response.then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<NotificationItem> notificationList = [];

        for (var item in jsonResponse) {
          if (item.containsKey('id') &&
              item.containsKey('content') &&
              item.containsKey('date')) {
            NotificationItem notification = NotificationItem(
              id: item['id'].toString(),
              content: item['content'],
              date: item['date'],
            );
            notificationList.add(notification);

            _showNotification(
              id: int.parse(item['id'].toString()),
              title: 'New Notification',
              content: item['content'],
            );
          }
        }

        setState(() {
          notifications = notificationList;
        });
      } else {
        print(
            'Failed to fetch notifications. Status code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    });
  }

  // Modify the _showNotification method
  void _showNotification({
    required int id,
    required String title,
    required String content,
  }) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'finder', // channel ID
      'from admin', // channel name
      // 'Channel Description', channel description
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      content,
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 32, left: 20, right: 20, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    notifications[index].content,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notifications[index].date,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String content;
  final String date;

  NotificationItem({
    required this.id,
    required this.content,
    required this.date,
  });
}
