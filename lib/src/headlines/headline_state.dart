import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:news_app/src/headlines/headline_item.dart';
import 'package:news_app/src/headlines/headline_list_view.dart';

import '../settings/settings_view.dart';

class HeadlineState extends State<HeadlineListView> {
  late Future<List<HeadlineItem>> items;

  @override
  void initState(){
    super.initState();
    items = fetchNews();
  }

  Future<List<HeadlineItem>> fetchNews() async {
    final response = await http.get(Uri.parse('https://mockend.com/phippp/Flutter-News/News'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<HeadlineItem>.from(json.map((x) => HeadlineItem.fromJson(x)));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: FutureBuilder<List<HeadlineItem>>(
        future: items,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext ctx, int index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item.title)
                );
              },
            );
          } else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }


  
}