class ModelAllYearStats{
  List<Stats>? stats;
  int? totalExpenses;

  ModelAllYearStats({
    required this.stats,
    required this.totalExpenses
  });

  factory ModelAllYearStats.fromJson(Map<String,dynamic> json){
       return ModelAllYearStats(
        stats: (json["stats"] as List).map((json) => Stats.fromJson(json)).toList(), 
        totalExpenses: json["totalExpenses"]
        );
  }

  Map<String,dynamic> toJson(){
    return{
      "stats":stats,
      "totalExpenses":totalExpenses
    } ;
  }
}

class Stats{
  String? month;
  int? total;

  Stats({
    required this.month,
    required this.total
  });

  factory Stats.fromJson(Map<String,dynamic> json){
    return Stats(
      month:json['month'] ?? 0,
      total: json["total"] ?? 0
      );
  }

  Map<String,dynamic> toJson(){
    return {
      "month":month ,
      "total":total
    };
  }
}