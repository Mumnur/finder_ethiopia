import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MypersonDeletePage extends StatefulWidget {
  final dynamic person;

  MypersonDeletePage({required this.person});

  @override
  _MypersonDeletePageState createState() => _MypersonDeletePageState();
}

class _MypersonDeletePageState extends State<MypersonDeletePage> {
  TextEditingController _postTypeController = TextEditingController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    final person = widget.person;
    _postTypeController.text = person != null ? person['post_type'] ?? '' : '';

    _retrieveToken(); // Retrieve the access token when the page is initialized
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete person'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Wrap with SingleChildScrollView to make the content scrollable
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _postTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Post Type',
                                  border: OutlineInputBorder(),
                                ),
                                enabled:
                                    false, // Set enabled to false to make it uneditable
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _updateperson,
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateperson() async {
    final person = widget.person;
    if (person == null || person['id'] == null) {
      return; // Exit early if person or person['id'] is null
    }

    final url =
        'https://finderastu.pythonanywhere.com/delete-my-post/${person['id']}/';

    final updatedperson = {
      'post_type': _postTypeController.text,
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $_accessToken', // Include the access token in the request headers
      },
      body: jsonEncode(updatedperson),
    );

    if (response.statusCode == 200) {
      // person updated successfully

      setState(() {
        // Update the text field values with the updated data
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('person Deleted successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/homeaftersignin', (route) => false);
                },
              ),
            ],
          );
        },
      );
    } else {
      // Failed to update person
      // You can display an error message or handle the error as needed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to Delete person.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
