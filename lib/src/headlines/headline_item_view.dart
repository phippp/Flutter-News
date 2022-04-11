import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class HeadlineItemView extends StatelessWidget {
  const HeadlineItemView({Key? key}) : super(key: key);

  static const routeName = '/headline';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headline Here'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
