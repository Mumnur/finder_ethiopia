import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/account/change_password.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> userProfile = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    String? accessToken = await _retrieveToken();
    print(accessToken);

    final response = await http.get(
      Uri.parse('http://finderastu.pythonanywhere.com/account/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userProfile = jsonDecode(response.body);
        isLoading = false;
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

  Widget buildFieldCard(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontFamily: 'Times New Roman',
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  value ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'change_password',
                  child: Text('Change Password'),
                ),
              ];
            },
          ),
        ],
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
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(48, 16, 48, 16),
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildFieldCard(
                                    'Username:', userProfile['username']),
                                buildFieldCard(
                                    'First Name:', userProfile['first_name']),
                                buildFieldCard(
                                    'Last Name:', userProfile['last_name']),
                                buildFieldCard(
                                    'Region:', userProfile['region']),
                                buildFieldCard('City:', userProfile['city']),
                                buildFieldCard('Email:', userProfile['email']),
                                SizedBox(height: 24.0), // Add spacing
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/updateaccount');
                                  },
                                  child: Text(
                                    'Update Account',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0), // Add spacing
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Account'),
                                        content: Text(
                                          'Are you sure you want to delete your account?',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Times New Roman',
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/deleteaccount');
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Times New Roman',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    primary: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
