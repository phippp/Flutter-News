import 'package:flutter/material.dart';

import 'headline_state.dart';

/// Displays a list of SampleItems.
class HeadlineListView extends StatefulWidget {
  const HeadlineListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => HeadlineState();
}
