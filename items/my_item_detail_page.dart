import 'package:finder/screens/thread/items/MyItemDeletePage.dart';
import 'package:finder/screens/thread/items/My_Item_Update_Page.dart';
import 'package:flutter/material.dart';

class MyItemDetailPage extends StatefulWidget {
  final dynamic item;

  MyItemDetailPage({required this.item});

  @override
  _MyItemDetailPageState createState() => _MyItemDetailPageState();
}

class _MyItemDetailPageState extends State<MyItemDetailPage> {
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
              'Post Type: ${item['post_type']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Region: ${item['region']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'City: ${item['city']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Serial Number: ${item['serial_n']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Detail: ${item['detail']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Post Date: ${item['post_date']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Address: ${item['address']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Lost Date: ${item['lost_date']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'User: ${item['user']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'ID: ${item['id']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Text(
              'Type: ${item['i_type']}',
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
                        builder: (context) => MyItemUpdatePage(item: item),
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
                SizedBox(width: 12.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyItemDeletePage(item: item),
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
