class ModelTheMostExpense {
  final String? categorieId;
  final String? totalAmount;
  final Map<String,dynamic>? category;

  ModelTheMostExpense({
    required this.categorieId,
    required this.totalAmount,
    required this.category,
  });

  factory ModelTheMostExpense.fromJson(Map<String, dynamic> json) {
    return ModelTheMostExpense(
      categorieId: json['categorie_id'] ?? "",
      totalAmount: json['total_amount']?.toString() ?? "",
      category: json["category"] ?? "",
    );
  }
}

class Category {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name_categories'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
