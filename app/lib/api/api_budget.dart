import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/utils/server_uri.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const String urlServer = AppURI.URLSERVER;

class BudgetApi {
  postBudget(data) async {
    var uri = "$urlServer/budgets";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getCurrentBudget(userId) async {
    var uri = "$urlServer/budgets/current_budget/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getRapportsBudgetCurrent(userId) async {
    var uri = "$urlServer/budgets/rapports_currentBudget/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getAllBudgetWithExpenses(userId) async {
    var uri = "$urlServer/budgets/all/budgets/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //messade d'affichage de reponse de la requette recus
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize:MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF292D4E),
      // const Color(0xFF292D4E),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          label: "",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    ));
  }
}
