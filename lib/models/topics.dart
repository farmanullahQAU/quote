import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Category {
  final String name;
  final List<SubTopic> subTopics;

  Category({required this.name, required this.subTopics});
}

class SubTopic {
  final String title;
  final IconData icon;
  final bool isLocked;
  RxBool isSelected; // Use RxBool for reactivity

  SubTopic({
    required this.title,
    required this.icon,
    this.isLocked = false,
    bool? isSelected,
  }) : isSelected = (isSelected ?? false).obs; // Initialize as RxBool
}
