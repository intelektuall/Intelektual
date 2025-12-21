import 'package:flutter/material.dart';
import '../models/link_item.dart';
import '../models/link_text_key.dart';

class LinkProvider with ChangeNotifier {
  final List<LinkItem> _links = [
    LinkItem(
      title: LinkTextKey.learnOceanTitle,
      icon: Icons.explore,
      buttonText: LinkTextKey.learnMore,
    ),
  ];

  List<LinkItem> get links => _links;
}
