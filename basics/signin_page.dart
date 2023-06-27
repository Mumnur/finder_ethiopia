import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _responseText = '';
  bool _showResponse = false;

  Future<void> signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://finderastu.pythonanywhere.com/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Sign-in successful, store the access token
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String accessToken = responseData['token']['access'];

      await _storeToken(accessToken);

      print('Sign-in successful');
      Navigator.pushNamed(context, '/homeaftersignin');
    } else {
      // Sign-in failed, handle the error
      print('Sign-in failed');

      // Display the backend error message
      var responseBody = json.decode(response.body);
      var errorMessage = responseBody['detail'];

      setState(() {
        _responseText = errorMessage;
        _showResponse = true;
      });
    }
  }

  Future<void> _storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<String?> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();
    _retrieveToken(); // Retrieve the token when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 400.0, // Adjust the width as needed
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
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          signInUser();
                                        }
                                      },
                                      child: Text('Sign In'),
                                    ),
                                    SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/register');
                                          },
                                          child: Text(
                                            'Create Account',
                                            style: TextStyle(
                                              fontFamily: 'Times New Roman',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/forgotpassword');
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontFamily: 'Times New Roman',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: _showResponse,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Response:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              _responseText,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showResponse = false;
                                                });
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      ),
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
          ),
        ),
      ),
    );
  }
}
