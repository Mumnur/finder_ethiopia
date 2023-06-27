import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Page'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: AssetImage('assets/register.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(seconds: 1),
                      builder: (context, double opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: child,
                        );
                      },
                      child: Text(
                        'Welcome! What do you want to post?',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButtonRow(
                            context,
                            [
                              _buildReportButton(
                                text: 'Submit Lost Item',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/reportlostitem');
                                },
                                color: Colors.red,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          _buildButtonRow(
                            context,
                            [
                              _buildReportButton(
                                text: 'Submit Found Item',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/reportfounditem');
                                },
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          _buildButtonRow(
                            context,
                            [
                              _buildReportButton(
                                text: 'Submit Lost Person',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/postlostperson');
                                },
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          _buildButtonRow(
                            context,
                            [
                              _buildReportButton(
                                text: 'Submit Found Person',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/postfoundperson');
                                },
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildButtonRow(BuildContext context, List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  Widget _buildReportButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        textStyle: TextStyle(fontSize: 18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: color,
        onPrimary: Colors.white,
      ),
      child: Text(text),
    );
  }
}
