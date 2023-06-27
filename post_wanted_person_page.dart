import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PostWantedPersonPage extends StatefulWidget {
  @override
  _PostWantedPersonPageState createState() => _PostWantedPersonPageState();
}

class _PostWantedPersonPageState extends State<PostWantedPersonPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  File? _image;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Implement your form submission logic here
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String age = _ageController.text;
      String height = _heightController.text;
      String description = _descriptionController.text;
      String address = _addressController.text;
      String region = _regionController.text;
      String city = _cityController.text;
      String reason = _reasonController.text;
      String condition = _conditionController.text;

      // Prepare the form data
      var formData = {
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'height': height,
        'description': description,
        'address': address,
        'region': region,
        'city': city,
        'reason': reason,
        'condition': condition,
      };

      // Send the form data and image to the backend API
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://finderastu/thread/post-wanted-person/'),
        );

        // Add form data
        request.fields.addAll(formData);

        // Add image file if available
        if (_image != null) {
          var file = await http.MultipartFile.fromPath(
            'image',
            _image!.path,
          );
          request.files.add(file);
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          // Form submission successful
          // Display a confirmation message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Wanted Person report submitted successfully.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Clear the form fields and image
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _ageController.clear();
                      _heightController.clear();
                      _descriptionController.clear();
                      _addressController.clear();
                      _regionController.clear();
                      _cityController.clear();
                      _reasonController.clear();
                      _conditionController.clear();
                      _image = null;
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Form submission failed
          // Display an error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to submit the Wanted Person report.'),
                actions: <Widget>[
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
        }
      } catch (e) {
        // Handle any exceptions during the form submission
        print('Error: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred during form submission.'),
              actions: <Widget>[
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
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Wanted Person'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: 'Height'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a height';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _regionController,
                  decoration: InputDecoration(labelText: 'Region'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a region';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _conditionController,
                  decoration: InputDecoration(labelText: 'Condition'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a condition';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                ),
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 200,
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
