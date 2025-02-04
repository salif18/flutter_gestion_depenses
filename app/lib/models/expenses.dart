import 'package:flutter/foundation.dart';

class ModelExpenses extends ChangeNotifier {
  final String? id;
  final String? userId;
  final String? categoryId;
  final int? amount;
  final String? description;
  final DateTime? expenseDate;
  final Map<String, dynamic>? category;

  ModelExpenses({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.expenseDate,
    required this.category,
  });

  factory ModelExpenses.fromJson(Map<String, dynamic> json) {
    return ModelExpenses(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      categoryId: json["categorie_id"] ?? "",
      amount: json["amount"],
      description: json["description"] ?? "",
      expenseDate: DateTime.parse(json["date_expenses"]),
      category: json["category"] ?? "",
      // user: json["user"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "categorie_id": categoryId,
      "amount": amount,
      "description": description,
      "date_expenses": expenseDate?.toIso8601String(),
      "category": category,
      // "user": user,
    };
  }
}
