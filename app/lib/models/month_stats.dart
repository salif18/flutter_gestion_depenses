
//classe pour les donnees du tableau stats
class ModelMonthStats {
  final String? month;
  final int? total;

  ModelMonthStats({
    required this.month,
    required this.total,
  });

  factory ModelMonthStats.fromJson(Map<String, dynamic> json) {
    return ModelMonthStats(
      month: json['month'] ?? "",
      total: json['total'] ?? "",
    );
  }
   Map<String,dynamic> toJson(){
  return {
     "month":month,
     "total":total
  };
}
}