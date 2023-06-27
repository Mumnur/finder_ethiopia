import 'package:finder/screens/thread/items/lost_item_detail_page.dart';
import 'package:finder/screens/thread/person/person_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageBefore extends StatefulWidget {
  @override
  _HomePageBeforeState createState() => _HomePageBeforeState();
}

class _HomePageBeforeState extends State<HomePageBefore> {
  List<dynamic> threadItems = [];
  bool isNightMode = false;

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
    final baseUrl = 'http://finderastu.pythonanywhere.com/';
    final ColorScheme colorScheme = isNightMode
        ? ColorScheme.dark(
            primary: Color(0xFF0088CC),
            onPrimary: Colors.white,
            surface: Color(0xFF121212),
            onSurface: Colors.white,
          )
        : ColorScheme.light(
            primary: Color(0xFF0088CC),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          );

    final ThemeData themeData = ThemeData.from(colorScheme: colorScheme);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Finder'),
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
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                ),
                child: Image.asset(
                  'assets/finder-logo.png',
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
                title: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                  ),
                ),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.pushNamed(context, '/signin');
                },
              ),
              ListTile(
                title: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                  ),
                ),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.pushNamed(context, '/register');
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
                final imageUrl =
                    imagePath.isNotEmpty ? baseUrl + imagePath : '';

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                final imageUrl =
                    imagePath.isNotEmpty ? baseUrl + imagePath : '';

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      builder: (context) =>
                                          LostPersonDetailPage(
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
      ),
    );
  }
}
