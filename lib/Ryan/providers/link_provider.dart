import 'package:flutter/material.dart';
import '../models/link_item.dart';

class LinkProvider with ChangeNotifier {
  final List<LinkItem> _links = [
    LinkItem(
      title: "Pelajari Kehidupan Bawah Laut",
      icon: Icons.explore,
      buttonText: "Pelajari Selengkapnya",
    ),
  ];

  List<LinkItem> get links => _links;
}
