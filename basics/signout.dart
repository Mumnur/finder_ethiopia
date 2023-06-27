import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('accessToken'); // Remove the token from shared preferences
    Navigator.pushNamedAndRemoveUntil(
        context, '/signin', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to sign out?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
