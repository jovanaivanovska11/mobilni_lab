import 'package:flutter/material.dart';
import 'location.dart';

class ListItem{
  final String id;
  final String course;
  final DateTime date;
  final Location location;

  ListItem ({
    required this.id,
    required this.course,
    required this.date,
    required this.location,
  });
}