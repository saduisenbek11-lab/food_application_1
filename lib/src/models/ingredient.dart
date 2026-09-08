import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final String amount;

  const Ingredient({
    required this.name,
    required this.amount,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [name, amount];
}
