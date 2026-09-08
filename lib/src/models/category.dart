import 'package:equatable/equatable.dart';

class RecipeCategory extends Equatable {
  final String id;
  final String label;
  final String emoji;

  const RecipeCategory({
    required this.id,
    required this.label,
    required this.emoji,
  });

  factory RecipeCategory.fromJson(Map<String, dynamic> json) {
    return RecipeCategory(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      emoji: json['emoji'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'emoji': emoji,
    };
  }

  @override
  List<Object?> get props => [id, label, emoji];
}
