import 'package:flutter/material.dart';

class Status {
  final String id;
  final String author;
  final String text;
  final String description;
  final String emailName;
  String imageUrl;

  Status({
    @required this.id,
    @required this.author,
    @required this.text,
    @required this.description,
    @required this.emailName,
    @required this.imageUrl,
  });
}
