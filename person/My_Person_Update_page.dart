import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPersonUpdatePage extends StatefulWidget {
  final dynamic person;

  MyPersonUpdatePage({required this.person});

  @override
  _MyPersonUpdatePageState createState() => _MyPersonUpdatePageState();
}

class _MyPersonUpdatePageState extends State<MyPersonUpdatePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postTypeController = TextEditingController();
  TextEditingController _clothController = TextEditingController();
  TextEditingController _markController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    final person = widget.person;
    _firstNameController.text = person['first_name'] ?? '';
    _lastNameController.text = person['last_name'] ?? '';
    _ageController.text = person['age']?.toString() ?? '';
    _heightController.text = person['height']?.toString() ?? '';
    _cityController.text = person['city'] ?? '';
    _postTypeController.text = person['post_type'] ?? '';
    _clothController.text = person['cloth'] ?? '';
    _markController.text = person['mark'] ?? '';
    _detailController.text = person['detail'] ?? '';

    _retrieveToken(); // Retrieve the access token when the page is initialized
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
      print(_accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Person'),
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
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _ageController,
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _heightController,
                                decoration: InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _clothController,
                                decoration: InputDecoration(
                                  labelText: 'Cloth',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _markController,
                                decoration: InputDecoration(
                                  labelText: 'Mark',
                                  border: OutlineInputBorder(),
                                ),
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
                                controller: _postTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Post Type',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _updatePerson,
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

  Future<void> _updatePerson() async {
    final person = widget.person;
    final url =
        'https://finderastu.pythonanywhere.com/update-my-post/${person['id']}/';

    final updatedPerson = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'age': int.tryParse(_ageController.text),
      'height': double.tryParse(_heightController.text),
      'city': _cityController.text,
      'post_type': _postTypeController.text,
      'cloth': _clothController.text,
      'mark': _markController.text,
      'detail': _detailController.text,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $_accessToken', // Include the access token in the request headers
      },
      body: jsonEncode(updatedPerson),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      // Person updated successfully

      final updatedFirstName = updatedPerson['first_name']?.toString() ?? '';
      final updatedLastName = updatedPerson['last_name']?.toString() ?? '';
      final updatedAge = updatedPerson['age']?.toString() ?? '';
      final updatedHeight = updatedPerson['height']?.toString() ?? '';
      final updatedCity = updatedPerson['city']?.toString() ?? '';

      setState(() {
        // Update the text field values with the updated data
        _firstNameController.text = updatedFirstName;
        _lastNameController.text = updatedLastName;
        _ageController.text = updatedAge;
        _heightController.text = updatedHeight;
        _cityController.text = updatedCity;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Person updated successfully'),
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
            content: Text('Failed to update person.'),
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
