import 'package:finder/screens/thread/items/my_item_detail_page.dart';
import 'package:finder/screens/thread/person/my_person_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  List<dynamic> posts = [];
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _retrieveToken().then((accessToken) {
      setState(() {
        _accessToken = accessToken;
      });
      fetchPosts();
    });
  }

  Future<String?> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> fetchPosts() async {
    if (_accessToken == null) {
      print('Access token not available');
      return;
    }

    final url = 'http://finderastu.pythonanywhere.com/my-post/';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = jsonDecode(response.body);
      setState(() {
        posts = fetchedPosts;
      });
    } else {
      // Handle error
      print('Failed to fetch posts');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finder'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          if (post.containsKey("serial_n")) {
            // Display found item
            return buildFoundItemTile(post);
          } else {
            // Display found person
            return buildFoundPersonTile(post);
          }
        },
      ),
    );
  }

  Widget buildFoundItemTile(dynamic item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2.0,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/jemal.jpg',
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Post Type: ${item['post_type']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Region: ${item['region'] ?? 'No Region'}'),
                Text(
                    'Serial Number: ${item['serial_n'] ?? 'No Serial Number'}'),
                Text('City: ${item['city'] ?? 'No City'}'),
                Text('Post Date: ${item['post_date'] ?? 'No Post Date'}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyItemDetailPage(item: item),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFoundPersonTile(dynamic person) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2.0,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/welcome.jpg',
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Post Type: ${person['post_type']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First name: ${person['first_name'] ?? 'No Name'}'),
                Text('Age: ${person['age'] ?? 'No Age'}'),
                Text('City: ${person['city'] ?? 'No City'}'),
                Text('Post Date: ${person['post_date'] ?? 'No Post Date'}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPersonDetailPage(person: person),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
