import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/auth/secrets.dart';

import 'package:news_app/src/headlines/headline_item.dart';
import 'package:news_app/src/headlines/headline_item_view.dart';
import 'package:news_app/src/headlines/headline_list_view.dart';
import 'package:news_app/src/models/category.dart';

import '../settings/settings_view.dart';

class HeadlineState extends State<HeadlineListView> {

  final List<Category> categories = 
    ["technology", "sport", "business", "entertainment", "general", "health", "science"]
    .map((e) => Category(name: e)).toList();
  int cat = 0;
  bool showGlobal = true;

  late Future<List<HeadlineItem>> items;
  late Future<List<Placemark>> placemarks; 
  late String countryCode;

  @override
  void initState(){
    super.initState();
    items = fetchNews(categories[cat].name);
    placemarks = fetchCountry();
  }

  static String capitalise(String word){
    return word.substring(0, 1).toUpperCase() + word.substring(1);
  }

  String buildUri(String category){
    return 'https://newsapi.org/v2/top-headlines' 
      + (showGlobal ? "" : "?country=" + countryCode.toLowerCase())
      + (showGlobal ? "?" : "&") + "category=" + category
      + "&apiKey=" + apiKey;
  }

  Future<List<HeadlineItem>> fetchNews(String category) async {
    final response = await http.get(Uri.parse(buildUri(category)));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['articles'];
      return List<HeadlineItem>.from(json.map((x) => HeadlineItem.fromJson(x)));
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<Placemark>> fetchCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    return placemarkFromCoordinates(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body : Column(
        children: [
          FutureBuilder<List<Placemark>>(
            future: placemarks,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                Placemark place = snapshot.data!.firstWhere((element) => element.isoCountryCode != null);
                countryCode = place.isoCountryCode!;
                return Row(
                  children : [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 2.0, 1.0, 2.0),
                      child: const Text("Global News :"),
                    ),
                    Switch(
                      value: showGlobal,
                      onChanged: (bool c) {
                        setState(() {
                          showGlobal = c;
                          items = fetchNews(categories[cat].name);
                        });
                      },
                    )
                  ],
                );
              }
              return const SizedBox(height: 1);
            },
          ),
          Builder(
            builder : ((context) {
              List<Widget> rowItems = [];
              for(var i = 0; i < categories.length; i++){
                rowItems.add(
                  Container(
                    padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 3.0),
                    child : TextButton(
                      onPressed: () {
                        setState(() {
                          cat = i;
                          items = fetchNews(categories[i].name);
                        });
                      }, 
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                        ),
                        backgroundColor: i == cat ? Colors.blue : Colors.transparent,
                      ),
                      child: Text(
                        capitalise(categories[i].name),
                        style: TextStyle(
                          color: i == cat ? Colors.black : null,
                          fontWeight: i == cat ? FontWeight.bold : null,
                        ),
                      )
                    )
                  )
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: rowItems,
                )
              );
            })
          ),
          Expanded(
            child : FutureBuilder<List<HeadlineItem>>(
              future: items,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.description ?? ""),
                        onTap: () {
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (context) => HeadlineItemView(item : item),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          foregroundImage: NetworkImage(
                            item.image ?? "https://picsum.photos/seed/97198/1920/1080",
                            scale: 0.5
                          ),
                        )
                      );
                    },
                    separatorBuilder: (BuildContext ctx, int index) => const Divider(),
                  );
                } else if(snapshot.hasError){
                  return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              }
            )
          )
        ]
      )
    );
  }
}