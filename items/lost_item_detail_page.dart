import 'package:finder/screens/chat/report_page.dart';
import 'package:flutter/material.dart';
import 'package:finder/screens/chat/chat_page.dart.dart';

class LostItemDetailPage extends StatefulWidget {
  final dynamic item;

  LostItemDetailPage({required this.item});

  @override
  _LostItemDetailPageState createState() => _LostItemDetailPageState();
}

class _LostItemDetailPageState extends State<LostItemDetailPage> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final baseUrl =
        "http://finderastu.pythonanywhere.com/"; // Replace with your base URL

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              width: 250,
              height: 400,
              child: Image.network(
                baseUrl + (item['image_url'] ?? ''),
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
              'Post type: ${item['post_type'] ?? ''}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Region: ${item['region'] ?? ''}',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'City: ${item['city'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Serial Number: ${item['serial_n'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Detail: ${item['detail'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Post Date: ${item['post_date'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Address: ${item['address'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Lost Date: ${item['lost_date'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Update Date: ${item['update_date'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'User: ${item['user'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Type: ${item['i_type'] ?? ''}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontFamily: 'Times New Roman'),
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
                            user: item['user']?.toString() ?? '',
                            id: item['id']?.toString() ?? '',
                            post_type: item['post_type']?.toString() ?? '',
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
                              ChatPage(user: item['user']?.toString() ?? ''),
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
