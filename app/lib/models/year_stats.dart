class ModelYearStats {
  final String? year;
  final String? totalExpenses;

  ModelYearStats({required this.year, required this.totalExpenses});

  factory ModelYearStats.fromJson(Map<String, dynamic> json) {
    return ModelYearStats(
        year: json["year"]?.toString() ?? "",
        totalExpenses: json["totalExpenses"]?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"year": year, "totalExpenses": totalExpenses};
  }
}
