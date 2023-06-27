import 'package:finder/screens/thread/person/MyPersonDeletePage.dart';
import 'package:finder/screens/thread/person/My_Person_Update_page.dart';
import 'package:flutter/material.dart';

class MyPersonDetailPage extends StatefulWidget {
  final dynamic person;

  MyPersonDetailPage({required this.person});

  @override
  _MyPersonDetailPageState createState() => _MyPersonDetailPageState();
}

class _MyPersonDetailPageState extends State<MyPersonDetailPage> {
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
                  return Image.asset('assets/home.jpg');
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Post Type: ${person['post_type']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Region: ${person['region'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
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
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyPersonUpdatePage(person: person),
                      ),
                    );

                    // Handle the update success here, if needed
                    if (result != null && result) {
                      // Item was successfully updated
                      // Refresh the detail page or show a success message
                    }
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                ),
                SizedBox(width: 25.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MypersonDeletePage(person: person),
                      ),
                    );

                    // Handle the update success here, if needed
                    if (result != null && result) {
                      // Item was successfully updated
                      // Refresh the detail page or show a success message
                    }
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
