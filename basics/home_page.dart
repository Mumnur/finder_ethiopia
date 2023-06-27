import 'package:finder/screens/thread/items/lost_item_detail_page.dart';
import 'package:finder/screens/thread/person/person_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> threadItems = [];

  @override
  void initState() {
    super.initState();
    fetchThread();
  }

  Future<void> fetchThread() async {
    final response = await http
        .get(Uri.parse('http://finderastu.pythonanywhere.com/thread/'));
    if (response.statusCode == 200) {
      setState(() {
        threadItems = json.decode(response.body) as List<dynamic>;
      });
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseUrl = 'http://finderastu.pythonanywhere.com/';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finder',
          style: TextStyle(
            fontFamily: 'Times New Roman',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final searchText = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  String searchQuery = '';

                  return AlertDialog(
                    title: Text('Search'),
                    content: TextField(
                      onChanged: (value) {
                        searchQuery = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop('');
                        },
                      ),
                      TextButton(
                        child: Text('Search'),
                        onPressed: () {
                          Navigator.of(context).pop(searchQuery);
                        },
                      ),
                    ],
                  );
                },
              );

              if (searchText != null && searchText.isNotEmpty) {
                final searchUrl = Uri.parse(
                    'http://finderastu.pythonanywhere.com/search-all?q=$searchText');

                final response = await http.get(searchUrl);
                if (response.statusCode == 200) {
                  setState(() {
                    threadItems = json.decode(response.body) as List<dynamic>;
                  });
                } else {
                  // Handle error response
                  print('Error: ${response.statusCode}');
                }
              } else {
                // If search is cleared, fetch the initial thread items again
                await fetchThread();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(''),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/jemal.jpg',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/finder-logo.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text(
                'Lost Posts',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/lostpostpage');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text(
                'Found Posts',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/foundpostpage');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(
                'My Posts',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/mypost');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(
                'Add Post',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/report');
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(
                'Messages',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/messages');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/accountpage');
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text(
                'Notification',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(
                'Policies',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/privacypolicy');
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Exit',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                ),
              ),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pushNamed(context, '/signout');
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: colorScheme.surface,
        child: ListView.builder(
          itemCount: threadItems.length,
          itemBuilder: (context, index) {
            final threadItem = threadItems[index];
            if (threadItem.containsKey("serial_n")) {
              final imagePath = threadItem['image_url'] ?? '';
              final imageUrl = imagePath.isNotEmpty ? baseUrl + imagePath : '';

              // Fetch image from assets if imageUrl is empty
              final imageWidget = imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
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
                        return Text('Failed to load image');
                      },
                    )
                  : Image.asset('assets/home.jpg');

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
                            Container(
                              width: cardWidth,
                              height: cardHeight * 0.5,
                              child: imageWidget,
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              title: Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'Post type: ${threadItem['post_type']}',
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      'Serial Number: ${threadItem["serial_n"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Region: ${threadItem["region"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'City: ${threadItem["city"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LostItemDetailPage(
                                      item: threadItem,
                                    ),
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
            } else if (threadItem.containsKey("first_name")) {
              final imagePath = threadItem['image_url'] ?? '';
              final imageUrl = imagePath.isNotEmpty ? baseUrl + imagePath : '';

              // Fetch image from network URL or fallback to asset image
              final imageWidget = imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
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
                        return Text(
                            'Failed to load image'); // Replace 'placeholder_image.png' with your actual asset image path
                      },
                    )
                  : Image.asset(
                      'assets/welcome.jpg'); // Replace 'placeholder_image.png' with your actual asset image path

              return LayoutBuilder(
                builder: (context, constraints) {
                  final double cardWidth = constraints.maxWidth * 0.4;
                  final double cardHeight = cardWidth * 3;

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
                              padding: EdgeInsets.all(16),
                              child: imageWidget,
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              title: Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'Post type: ${threadItem['post_type']}',
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      'First Name: ${threadItem["first_name"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Last Name: ${threadItem["last_name"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Age: ${threadItem["age"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Height: ${threadItem["height"]}',
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LostPersonDetailPage(
                                      person: threadItem,
                                    ),
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

            return Container();
          },
        ),
      ),
    );
  }
}
