class StyleOptionModel {
  final String id;
  final String label;
  final String imagePath;

  const StyleOptionModel({
    required this.id,
    required this.label,
    required this.imagePath,
  });

  factory StyleOptionModel.fromJson(Map<String, dynamic> json) {
    return StyleOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      imagePath: json['imageUrl'] as String,
    );
  }
}
