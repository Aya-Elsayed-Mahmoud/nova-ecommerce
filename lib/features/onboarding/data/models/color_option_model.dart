import 'package:flutter/material.dart';

class ColorOptionModel {
  final String id;
  final Color color;
  final String groupLabel;

  const ColorOptionModel({
    required this.id,
    required this.color,
    required this.groupLabel,
  });

  factory ColorOptionModel.fromJson(Map<String, dynamic> json) {
    return ColorOptionModel(
      id: json['id'] as String,
      color: Color(
        int.parse((json['hex'] as String).replaceFirst('#', '0xFF')),
      ),
      groupLabel: json['groupLabel'] as String,
    );
  }
}
