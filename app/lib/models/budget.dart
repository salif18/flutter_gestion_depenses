class ModelBudgets {
  String? id;
  String? userId;
  int? budgetAmount;
  String? budgetDate;
  List<ExpensesOfBudget?> depense;

  ModelBudgets(
    {
      required this.id,
      required this.userId,
      required this.budgetAmount,
      required this.budgetDate,
      required this.depense
    });

  factory ModelBudgets.fromJson(Map<String, dynamic> json) {
    return ModelBudgets(
        id: json["id"],
        userId: json["userId"],
        budgetAmount: json["budget_amount"],
        budgetDate: json["budget_date"],
        depense: (json["depense"] as List)
            .map((json) => ExpensesOfBudget.fromJson(json))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "budget_amount": budgetAmount,
      "budget_date": budgetDate,
      "expenses": depense
    };
  }
}

class ExpensesOfBudget {
  String? id;
  String? userId;
  String? categorieId;
  String? budgetId;
  int? amount;
  String? description;
  String? dateExpenses;

  ExpensesOfBudget(
    {
      required this.id,
      required this.userId,
      required this.categorieId,
      required this.budgetId,
      required this.amount,
      required this.description,
      required this.dateExpenses
    });

  factory ExpensesOfBudget.fromJson(Map<String, dynamic> json) {
    return ExpensesOfBudget(
        id: json["id"],
        userId: json["userId"],
        categorieId: json["categorieId"],
        budgetId: json["budgetId"],
        amount: json["amount"],
        description: json["description"],
        dateExpenses:json["date_expenses"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "categorie_id": categorieId,
      "budgetId": budgetId,
      "amount": amount,
      "description": description,
      "date_expenses": dateExpenses
    };
  }
}
