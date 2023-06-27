import 'package:finder/screens/thread/items/lost_item_detail_page.dart';
import 'package:finder/screens/thread/person/person_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoundPostPage extends StatefulWidget {
  @override
  _FoundPostPageState createState() => _FoundPostPageState();
}

class _FoundPostPageState extends State<FoundPostPage> {
  List<dynamic> foundItems = [];
  List<dynamic> foundPersons = [];

  @override
  void initState() {
    super.initState();
    fetchFoundItems();
    fetchFoundPersons();
  }

  Future<void> fetchFoundItems() async {
    final response = await http.get(
        Uri.parse('http://finderastu.pythonanywhere.com/thread/found-item'));
    if (response.statusCode == 200) {
      final List<dynamic> items = jsonDecode(response.body);
      setState(() {
        foundItems = items;
        foundItems.sort((a, b) => b['post_date'].compareTo(a['post_date']));
      });
    } else {
      // Handle error
      print('Failed to fetch found items');
    }
  }

  Future<void> fetchFoundPersons() async {
    final response = await http.get(
        Uri.parse('http://finderastu.pythonanywhere.com/thread/found-person'));
    if (response.statusCode == 200) {
      final List<dynamic> persons = jsonDecode(response.body);
      setState(() {
        foundPersons = persons;
        foundPersons.sort((a, b) => b['post_date'].compareTo(a['post_date']));
      });
    } else {
      // Handle error
      print('Failed to fetch found persons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found Posts'),
      ),
      body: ListView.builder(
        itemCount: foundItems.length + foundPersons.length,
        itemBuilder: (context, index) {
          if (index < foundItems.length) {
            // Display found item
            final item = foundItems[index];
            return buildFoundItemTile(context, item);
          } else {
            // Display found person
            final person = foundPersons[index - foundItems.length];
            return buildFoundPersonTile(context, person);
          }
        },
      ),
    );
  }

  Widget buildFoundItemTile(BuildContext context, dynamic item) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseUrl =
        'http://finderastu.pythonanywhere.com/'; // Replace with your base URL
    final imagePath = item['image_path'];
    final imageUrl = imagePath != null ? baseUrl + imagePath : null;
    final fallbackImage = 'assets/welcome.jpg';

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth * 0.8;
        final double cardHeight = cardWidth * 1.5;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: colorScheme.surface,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: cardWidth * 0.8,
                            height: cardHeight * 0.5,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            fallbackImage,
                            width: cardWidth * 0.8,
                            height: cardHeight * 0.5,
                            fit: BoxFit.cover,
                          ),
                  ),
                  ListTile(
                    title: Text('Post Type: ${item['post_type']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Region: ${item['region'] ?? 'No region'}'),
                        SizedBox(height: 8),
                        Text(
                            'Serial Number: ${item['serial_n'] ?? 'No Serial Number'}'),
                        SizedBox(height: 8),
                        Text('City: ${item['city'] ?? 'No City'}'),
                        SizedBox(height: 8),
                        Text(
                            'Post Date: ${item['post_date'] ?? 'No Post Date'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LostItemDetailPage(item: item),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFoundPersonTile(BuildContext context, dynamic person) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseUrl =
        'http://finderastu.pythonanywhere.com/'; // Replace with your base URL
    final imagePath = person['image_path'];
    final imageUrl = imagePath != null ? baseUrl + imagePath : null;
    final fallbackImage = 'assets/home.jpg';

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth * 0.8;
        final double cardHeight = cardWidth * 1.5;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: colorScheme.surface,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 64),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: cardWidth * 0.8,
                            height: cardHeight * 0.5,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            fallbackImage,
                            width: cardWidth * 0.8,
                            height: cardHeight * 0.5,
                            fit: BoxFit.cover,
                          ),
                  ),
                  ListTile(
                    title: Text('Post Type: ${person['post_type']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                            'First name: ${person['first_name'] ?? 'No Name'}'),
                        SizedBox(height: 8),
                        Text('Age: ${person['age'] ?? 'No Age'}'),
                        SizedBox(height: 8),
                        Text('City: ${person['city'] ?? 'No City'}'),
                        SizedBox(height: 8),
                        Text(
                            'Post Date: ${person['post_date'] ?? 'No Post Date'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LostPersonDetailPage(person: person),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
