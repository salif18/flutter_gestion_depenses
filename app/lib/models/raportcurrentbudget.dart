// MODEL BUDGETS
class ModelRapportCurrentBudgets{
  final String? id;
  final String? budgetUserId;
  final int? budgetAmount;
  final DateTime? budgetDate;
  final int? budgetTotal;
  final int? epargnes;
  final String? percent;
  

  ModelRapportCurrentBudgets({
    required this.id,
    required this.budgetUserId,
    required this.budgetAmount,
    required this.budgetDate,
    required this.budgetTotal,
    required this.epargnes,
    required this.percent
  });

  factory ModelRapportCurrentBudgets.fromJson(Map<String,dynamic> json){
      return ModelRapportCurrentBudgets(
        id:json["id"] ?? "",
        budgetUserId: json["userId"] ?? "", 
        budgetAmount: json["budget_amount"] ?? "", 
        budgetDate: DateTime.parse(json["budget_date"]),
        budgetTotal: json["totalExpenses"] ?? "",
        epargnes: json["epargnes"] ?? "",
        percent:json["percent"]?.toString() ?? ""
      );
  }

  Map<String, dynamic>toJson(){
    return {
       "id":id,
       "budget_userId":budgetUserId,
       "budget_amount":budgetAmount,
       "buget_date":budgetDate?.toIso8601String(),
       "totalExpenses":budgetTotal,
       "epargnes":epargnes,
       "percent":percent?.toString()
    };
  }
}
