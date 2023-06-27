import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportPages extends StatefulWidget {
  final String user;
  final String post_type;
  final String id;

  ReportPages({
    required this.user,
    required this.post_type,
    required this.id,
  });

  @override
  _ReportPagesState createState() => _ReportPagesState();
}

class _ReportPagesState extends State<ReportPages> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _contentController = TextEditingController();
  String? _accessToken;
  String? _selectedType;

  List<String> _reportTypes = [
    'spam',
    'nudity',
    'harassment',
    'other violations'
  ];

  @override
  void initState() {
    super.initState();
    _retrieveToken().then((_accessToken) {
      setState(() {
        _accessToken = _accessToken;
      });
    });
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
      print('Access Token: $_accessToken');
    });
  }

  Future<void> sendReport() async {
    String user = widget.user;
    String id = widget.id;
    String post_type = widget.post_type;

    final response = await http.post(
      Uri.parse('https://finderastu.pythonanywhere.com/report/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({
        'reported': user,
        'reported_item': id,
        'reported_item_type': post_type,
        'content': _contentController.text,
        'r-type': _selectedType,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Report sent successfully
      print('Report sent successfully');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Report submitted successfully.'),
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
      _contentController.clear();
      setState(() {
        _selectedType = null;
      });
    } else {
      // Failed to send report, handle the error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit the report.'),
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
      print('Failed to send report');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Report Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the report content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _reportTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Report Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    sendReport();
                  }
                },
                child: Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
