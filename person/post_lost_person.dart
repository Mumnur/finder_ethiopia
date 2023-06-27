import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostLostPersonPage extends StatefulWidget {
  @override
  _PostLostPersonPageState createState() => _PostLostPersonPageState();
}

class _PostLostPersonPageState extends State<PostLostPersonPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _clothingDescriptionController =
      TextEditingController();
  TextEditingController _distinctiveMarkController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _regionController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _lostDateController = TextEditingController();
  File? _image;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _retrieveToken(); // Retrieve the access token when the page is initialized
  }

  Future<void> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken');
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Implement your form submission logic here
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String age = _ageController.text;
      String height = _heightController.text;
      String clothingDescription = _clothingDescriptionController.text;
      String distinctiveMark = _distinctiveMarkController.text;
      String detail = _detailController.text;
      String address = _addressController.text;
      String region = _regionController.text;
      String city = _cityController.text;
      String gender = _genderController.text;
      String lostDate = _lostDateController.text;

      // Prepare the form data
      var formData = {
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'height': height,
        'cloth': clothingDescription,
        'mark': distinctiveMark,
        'detail': detail,
        'address': address,
        'region': region,
        'city': city,
        'gender': gender,
        'lost_date': lostDate,
      };

      // Send the form data and image to the backend API
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://finderastu.pythonanywhere.com/thread/post-lost-person'),
        );

        // Add form data
        request.fields.addAll(formData);

        // Add access token to headers
        request.headers['Authorization'] = 'Bearer $_accessToken';

        // Add image file if available
        if (_image != null) {
          var file = await http.MultipartFile.fromPath(
            'image_url',
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
                content: Text('Lost Person report submitted successfully.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/homeaftersignin', (route) => false);
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
                content: Text('Failed to submit the Lost Person report.'),
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
        title: Text('Post Lost Person'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration:
                                InputDecoration(labelText: '  First Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration:
                                InputDecoration(labelText: '  Last Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a last name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _ageController,
                            decoration: InputDecoration(labelText: '  Age'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _genderController,
                            decoration: InputDecoration(labelText: '  Gender'),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _regionController,
                            decoration: InputDecoration(labelText: '  Region'),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(labelText: '  City'),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _lostDateController,
                            decoration:
                                InputDecoration(labelText: '  Lost Date'),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _heightController,
                            decoration: InputDecoration(labelText: '  Height'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a height';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _clothingDescriptionController,
                            decoration: InputDecoration(
                                labelText: '  Clothing Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a clothing description';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _distinctiveMarkController,
                            decoration: InputDecoration(
                                labelText: '  Distinctive Mark'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a distinctive mark';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _detailController,
                            decoration: InputDecoration(labelText: '  Detail'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a detail';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(labelText: '  Address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an address';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
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
            ),
          ),
        ],
      ),
    );
  }
}
