import 'package:flutter/material.dart';

class NoteClass {
  String title;
  String text;
  DateTime creationDate;
  Color color;
  Color textColor;

  NoteClass(this.title, this.text, this.creationDate, this.color, this.textColor);

  // Convert a NoteClass instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'creationDate': creationDate.toIso8601String(),
      'color': color.value,
      'textColor': textColor.value,
    };
  }

  // Create a NoteClass instance from a Map
  factory NoteClass.fromJson(Map<String, dynamic> json) {
    return NoteClass(
      json['title'],
      json['text'],
      DateTime.parse(json['creationDate']),
      Color(json['color']),
      Color(json['textColor']),
    );
  }
}
