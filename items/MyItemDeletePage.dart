import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemDeletePage extends StatefulWidget {
  final dynamic item;

  MyItemDeletePage({required this.item});

  @override
  _MyItemDeletePageState createState() => _MyItemDeletePageState();
}

class _MyItemDeletePageState extends State<MyItemDeletePage> {
  TextEditingController _postTypeController = TextEditingController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _postTypeController.text = item['post_type'] ?? '';

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
        title: Text('Delete Item'),
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
                                onPressed: _updateItem,
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

  Future<void> _updateItem() async {
    final item = widget.item;
    final url =
        'https://finderastu.pythonanywhere.com/delete-my-post/${item['id']}/';

    final updatedItem = {
      'post_type': _postTypeController.text,
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $_accessToken', // Include the access token in the request headers
      },
      body: jsonEncode(updatedItem),
    );

    if (response.statusCode == 200) {
      // Item updated successfully

      setState(() {
        // Update the text field values with the updated data
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Item Deleted successfully'),
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
      // Failed to update item
      // You can display an error message or handle the error as needed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to Delete item.'),
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
