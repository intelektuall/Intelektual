import 'package:flutter/material.dart';
import 'link_text_key.dart';

class LinkItem {
  final LinkTextKey title;
  final IconData icon;
  final LinkTextKey buttonText;

  LinkItem({required this.title, required this.icon, required this.buttonText});
}
