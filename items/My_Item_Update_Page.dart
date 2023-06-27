import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemUpdatePage extends StatefulWidget {
  final dynamic item;

  MyItemUpdatePage({required this.item});

  @override
  _MyItemUpdatePageState createState() => _MyItemUpdatePageState();
}

class _MyItemUpdatePageState extends State<MyItemUpdatePage> {
  TextEditingController _cityController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postTypeController = TextEditingController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _cityController.text = item['city'] ?? '';
    _serialNumberController.text = item['serial_n']?.toString() ?? '';
    _detailController.text = item['detail'] ?? '';
    _addressController.text = item['address'] ?? '';
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
        title: Text('Edit Item'),
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
                              TextFormField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _serialNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Serial Number',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _detailController,
                                decoration: InputDecoration(
                                  labelText: 'Detail',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _postTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Post Type',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _updateItem,
                                child: Text('Update'),
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
        'https://finderastu.pythonanywhere.com/update-my-post/${item['id']}/';

    final updatedItem = {
      'city': _cityController.text,
      'serial_n': int.tryParse(_serialNumberController.text)?.toString(),
      'detail': _detailController.text,
      'adress': _addressController.text,
      'post_type': _postTypeController.text,
    };

    final response = await http.put(
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

      final updatedCity = updatedItem['city'] ?? '';
      final updatedSerialNumber = updatedItem['serial_n']?.toString() ?? '';
      final updatedDetail = updatedItem['detail'] ?? '';
      final updatedAddress = updatedItem['address'] ?? '';

      setState(() {
        // Update the text field values with the updated data
        _cityController.text = updatedCity;
        _serialNumberController.text = updatedSerialNumber;
        _detailController.text = updatedDetail;
        _addressController.text = updatedAddress;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Item updated successfully'),
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
            content: Text('Failed to update item.'),
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
