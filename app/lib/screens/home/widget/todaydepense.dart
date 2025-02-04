// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_depense.dart';
import 'package:gestionary/models/expenses.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/save_expense/saveexpense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/generate_icons.dart';

class MyDepenseDay extends StatefulWidget {
  const MyDepenseDay({super.key});

  @override
  State<MyDepenseDay> createState() => _MyDepenseDayState();
}

class _MyDepenseDayState extends State<MyDepenseDay> {
  ExpenseServicesApi expenseApi = ExpenseServicesApi();
  StreamController<List<ModelExpenses>> dataStream =
      StreamController<List<ModelExpenses>>.broadcast();
  String? day = "";
  int? totalDay = 0;

//get depense for server data
  Future<void> getExpenseToServerData() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final response = await expenseApi.getExpensesUserByDay(userId);
      dynamic decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          dataStream.add((decodedData["expenses"] as List)
              .map((json) => ModelExpenses.fromJson(json))
              .toList());
          day = decodedData["day"];
          totalDay = decodedData["totalDay"];
        });
      } else {
        expenseApi.showSnackBarErrorPersonalized(
            context, decodedData["message"]);
      }
    } catch (err) {
      expenseApi.showSnackBarErrorPersonalized(
          context, "Erreur de serveur, veuillez réessayer. $err");
    }
  }

  @override
  void initState() {
    super.initState();
    getExpenseToServerData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
        color: isDark ? backgroundDark : Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                           Icon(Icons.calendar_month_rounded,
                              color: Colors.red, size:MediaQuery.of(context).size.width*0.06),
                          const SizedBox(width: 10),
                          Text(
                            "$day".toLowerCase(),
                            style: GoogleFonts.roboto(
                                color: isDark ? textDark : null,
                                fontSize: MediaQuery.of(context).size.width*0.04,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.roboto(
                                color: isDark ? textDark : null,
                                fontSize:  MediaQuery.of(context).size.width*0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "$totalDay XOF",
                            style: GoogleFonts.roboto(
                                color: isDark ? Colors.red : Colors.black,
                                fontSize:  MediaQuery.of(context).size.width*0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.monetization_on_rounded,
                              color: Colors.amber, size: MediaQuery.of(context).size.width*0.06),
                        ],
                      )),
                ),
              ],
            ),
            StreamBuilder(
                stream: dataStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<ModelExpenses> expenseStream = snapshot.data ?? [];
                    if (expenseStream.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              "Salut n'oublier pas d'insérer vos dépenses du jours",
                              style: GoogleFonts.roboto(
                                  fontSize:  MediaQuery.of(context).size.width*0.04,
                                  fontWeight: FontWeight.w300,
                                  color: isDark ? textDark : Colors.black),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _showAddExpenses(context),
                              child: Icon(Icons.add, size:  MediaQuery.of(context).size.width*0.06),
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
                    return Center(
                        child: Text(
                      "aucunes donnees",
                      style: GoogleFonts.roboto(
                        fontSize:  MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.w300,
                        color: isDark ? textDark : null,
                      ),
                    ));
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
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                regeneredIcon(context,category?["name_categories".toLowerCase()] ?? ""),
                const SizedBox(
                  width: 10,
                ),
                Text(category?["name_categories"] ?? "",
                    style: GoogleFonts.roboto(
                        color: isDark ? textDark : null,
                        fontSize:  MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Row(
              children: [
                Text("${expense.amount} XOF",
                    style: GoogleFonts.roboto(
                        color: isDark ? Colors.green : Colors.black,
                        fontSize:  MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  width: 10,
                ),
                 Icon(Icons.monetization_on_sharp,
                    size: MediaQuery.of(context).size.width*0.06, color: Colors.amber)
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
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const SaveExpenses());
      },
    );
  }
}
