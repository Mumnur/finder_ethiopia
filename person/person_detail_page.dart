import 'package:finder/screens/chat/chat_page.dart.dart';
import 'package:finder/screens/chat/report_page.dart';
import 'package:flutter/material.dart';

class LostPersonDetailPage extends StatefulWidget {
  final dynamic person;

  LostPersonDetailPage({required this.person});

  @override
  _LostPersonDetailPageState createState() => _LostPersonDetailPageState();
}

class _LostPersonDetailPageState extends State<LostPersonDetailPage> {
  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    final baseUrl = "http://finderastu.pythonanywhere.com/";

    return Scaffold(
      appBar: AppBar(
        title: Text('Person Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              width: 250,
              height: 400,
              child: Image.network(
                baseUrl + (person['image_url'] ?? ''),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                      'assets/home.jpg'); // Replace 'placeholder_image.png' with your actual asset image path
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Region: ${person['region'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Firstname: ${person['first_name'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Lastname: ${person['last_name'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Age: ${person['age'] != null ? person['age'].toString() : 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Height: ${person['height'] != null ? person['height'].toString() : 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Address: ${person['address'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Gender: ${person['gender'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'City: ${person['city'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Cloth: ${person['cloth'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Mark: ${person['mark'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Detail: ${person['detail'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Lost Date: ${person['lost_date'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Post Date: ${person['post_date'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Update Date: ${person['update_date'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'User: ${person['user'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Type: ${person['p_type'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 32.0, top: 30, bottom: 30),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportPages(
                            user: person['user'].toString(),
                            id: person['id'].toString(),
                            post_type: person['post_type'].toString(),
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.report, size: 32.0),
                    backgroundColor: Color.fromARGB(255, 247, 18, 18),
                    mini: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 32.0, top: 30, bottom: 30),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(user: person['user'].toString()),
                        ),
                      );
                    },
                    child: Icon(Icons.chat, size: 32.0),
                    backgroundColor: Colors.blue,
                    mini: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
