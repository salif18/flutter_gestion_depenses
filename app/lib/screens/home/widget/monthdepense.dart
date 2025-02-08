// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_depense.dart';
import 'package:gestionary/models/expenses.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/save_expense/saveexpense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/generate_icons.dart';

class MyMonthDepense extends StatefulWidget {
  const MyMonthDepense({super.key});

  @override
  State<MyMonthDepense> createState() => _MyMonthDepenseState();
}

class _MyMonthDepenseState extends State<MyMonthDepense> {
  ExpenseServicesApi expenseApi = ExpenseServicesApi();
  StreamController<List<ModelExpenses>> dataStream =
      StreamController<List<ModelExpenses>>.broadcast();
  String? month = "";
  int? totalMonth = 0;

//get depense for server data
  Future<void> getExpenseToServerData() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final response = await expenseApi.getExpensesUserByMonth(userId);
      dynamic decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          dataStream.add((decodedData["expenses"] as List)
              .map((json) => ModelExpenses.fromJson(json))
              .toList());
          month = decodedData["month"];
          totalMonth = decodedData["totalMonth"];
        });
      } else {
        expenseApi.showSnackBarErrorPersonalized(
            context, decodedData["message"]);
      }
    } on SocketException {
      expenseApi.showSnackBarErrorPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      expenseApi.showSnackBarErrorPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    } catch (err) {
      expenseApi.showSnackBarErrorPersonalized(
          context, "Erreur de serveur, veuillez réessayer. $err");
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    getExpenseToServerData();
  }

  @override
  void dispose() {
    dataStream.close();
    super.dispose();
  }

double responsiveValue(BuildContext context, double baseValue) {
  return MediaQuery.of(context).size.width * (baseValue / 360);
}

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
        color: isDark ? backgroundDark : const Color(0xfff0f1f5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0222),
                  child: Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width * 0.06),
                          SizedBox(width: MediaQuery.of(context).size.width*0.0277),
                          Text(
                            "$month",
                            style: GoogleFonts.roboto(
                                color: isDark ? textDark : null,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0111),
                  child: Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
                      child: Row(
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.roboto(
                                color: isDark ? textDark : null,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.01388),
                          Text(
                            "$totalMonth XOF",
                            style: GoogleFonts.roboto(
                                color: isDark ? Colors.red : Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.0277),
                          Icon(Icons.monetization_on_rounded,
                              color: Colors.amber,
                              size: MediaQuery.of(context).size.width * 0.06),
                        ],
                      )),
                ),
              ],
            ),
            StreamBuilder(
                stream: dataStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: BorderSide.strokeAlignInside,
                        color: Colors.grey,
                      )),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<ModelExpenses> expenseStream = snapshot.data ?? [];
                    if (expenseStream.isEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0416),
                        child: Column(
                          children: [
                            Text(
                              "Salut n'oublier pas d'insérer vos dépenses du jours",
                              style: GoogleFonts.roboto(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w300,
                                  color: isDark ? textDark : null),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width*0.0555),
                            ElevatedButton(
                              onPressed: () => _showAddExpenses(context),
                              child: Icon(Icons.add,
                                  size:
                                      MediaQuery.of(context).size.width * 0.06),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: expenseStream.length,
                          itemBuilder: (context, index) {
                            final expense = expenseStream[index];
                            final category = expense.category;
                            return _expenses(context, expense, category);
                          },
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ));
  }

  Widget _expenses(BuildContext context, expense, category) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0083),
        height: MediaQuery.of(context).size.width*0.1388,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.0277),
                      color: const Color(0xFF292D4E),
                    ),
                    child: regeneredIcon(context,
                        category?["name_categories".toLowerCase()] ?? "")),
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.0277,
                ),
                Text(category?["name_categories"] ?? "",
                    style: GoogleFonts.roboto(
                        color: isDark ? textDark : null,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Row(
              children: [
                Text("${expense.amount} XOF",
                    style: GoogleFonts.roboto(
                        color: isDark ? Colors.green : Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w800)),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.0277,
                ),
                Icon(Icons.monetization_on_sharp,
                    size: MediaQuery.of(context).size.width * 0.06,
                    color: Colors.amber)
              ],
            ),
          ],
        ),
      ),
    );
  }

  //showModalBottomSheet la fenetre modale contenant le formulaire
  void _showAddExpenses(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0555),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MediaQuery.of(context).size.width *0.0555),
                topRight: Radius.circular(MediaQuery.of(context).size.width * 0.0555),
              ),
            ),
            child: const SaveExpenses());
      },
    );
  }
}
