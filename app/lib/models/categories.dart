
class ModelCategories {
  final String? id;
  final String? userId;
  final String? categoryName;

  ModelCategories({
    required this.id,
    required this.userId,
    required this.categoryName,
  });

  factory ModelCategories.fromJson(Map<String, dynamic> json) {
    return ModelCategories(
      id: json["id"] ?? "",
      userId:json["usrId"] ?? "",
      categoryName: json["name_categories"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId":userId,
      "name_categories": categoryName,
    };
  }
}
