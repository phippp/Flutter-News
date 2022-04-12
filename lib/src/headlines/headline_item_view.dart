import 'package:flutter/material.dart';
import 'package:news_app/src/headlines/headline_item.dart';

/// Displays detailed information about a SampleItem.
class HeadlineItemView extends StatelessWidget {
  const HeadlineItemView({Key? key, required this.item}) : super(key: key);

  final HeadlineItem item;

  static const routeName = '/headline';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(     
        child : Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.9,
                child: Image.network(
                  item.image ?? "https://picsum.photos/seed/97198/1920/1080",
                  loadingBuilder: ((context, child, loadingProgress) {
                    if(loadingProgress == null){
                      return child;
                    }
                    return CircularProgressIndicator(
                      value : loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                    );
                  }),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item.description ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item.content,
                style: const TextStyle(
                  fontSize: 16.0
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12.0, 18.0, 12.0, 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.supervised_user_circle
                  ),
                  Text(
                    "Written by " + (item.author ?? "Unknown author")
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}
