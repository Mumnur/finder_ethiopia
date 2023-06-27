import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAccountPage extends StatefulWidget {
  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    String? accessToken = await _retrieveToken();

    final response = await http.get(
      Uri.parse('http://finderastu.pythonanywhere.com/account/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> userProfile = jsonDecode(response.body);

      setState(() {
        usernameController.text = userProfile['username'];
        firstNameController.text = userProfile['first_name'];
        lastNameController.text = userProfile['last_name'];
        regionController.text = userProfile['region'];
        cityController.text = userProfile['city'];
        emailController.text = userProfile['email'];
      });
    } else {
      // Handle the error case
      print('Failed to fetch user profile: ${response.statusCode}');
    }
  }

  Future<String?> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> updateAccount() async {
    setState(() {
      isLoading = true;
    });

    String? accessToken = await _retrieveToken();

    final response = await http.put(
      Uri.parse('http://finderastu.pythonanywhere.com/update-account'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': usernameController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'region': regionController.text,
        'city': cityController.text,
        'email': emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Successful'),
          content: Text('Your account information has been updated.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the AccountPage
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Handle the error case
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Failed'),
          content: Text('Failed to update your account. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildFieldCard('Username', usernameController),
                    buildFieldCard('First Name', firstNameController),
                    buildFieldCard('Last Name', lastNameController),
                    buildFieldCard('Region', regionController),
                    buildFieldCard('City', cityController),
                    buildFieldCard('Email', emailController),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : updateAccount,
                      child: Text('Update Account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFieldCard(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  fontFamily: 'Times New Roman',
                ),
              ),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter $label',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
