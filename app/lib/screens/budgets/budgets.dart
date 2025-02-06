import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_budget.dart';
import 'package:gestionary/models/budget.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/budgets/addbudgets.dart';
import 'package:gestionary/screens/budgets/details/singlebudget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Budgets extends StatefulWidget {
  const Budgets({super.key});

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  final StreamController<List<ModelBudgets?>> _streamBudgets =
      StreamController<List<ModelBudgets?>>.broadcast();

  final BudgetApi _budgetApi = BudgetApi();

  Future<void> _getBudgetWithExpenses() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _budgetApi.getAllBudgetWithExpenses(userId);
      dynamic decodedData = jsonDecode(res.body);
      print(decodedData);
      if (res.statusCode == 200) {
        List<ModelBudgets?> converToModel =
            (decodedData["ExpensesOfBudget"] as List)
                .map((json) => ModelBudgets.fromJson(json))
                .toList();
        setState(() {
          _streamBudgets.add(converToModel);
        });
      }
    } on SocketException {
      _budgetApi.showSnackBarSuccessPersonalized(
          context, "Problème de connexion : Vérifiez votre Internet.");
      print("Erreur de connexion : Impossible d'accéder au serveur.");
    } on TimeoutException {
      _budgetApi.showSnackBarSuccessPersonalized(
          context, "Le serveur ne répond pas. Veuillez réessayer plus tard.");
      print("Erreur : Temps d'attente dépassé.");
    } catch (err) {
      Exception(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _getBudgetWithExpenses();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    Color? containerBg = provider.containerBackg;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor: isDark ? backgroundDark : Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: isDark ? backgroundDark : const Color(0xFF292D4E),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new,
                color: isDark ? textDark : Colors.grey[100], size: 24)),
        centerTitle: true,
        title: Text("Budgets",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Archives de vos Budgets",
                      style: GoogleFonts.aBeeZee(
                          color: isDark ? textDark : null,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500)),
                )),
            StreamBuilder(
                stream: _streamBudgets.stream,
                builder: (context, snaptshot) {
                  if (snaptshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: BorderSide.strokeAlignInside,
                          color: Colors.grey,
                        )));
                  } else if (snaptshot.hasData) {
                    List<ModelBudgets?> data = snaptshot.data!;
                    if (data.isNotEmpty) {
                      return Column(
                          children: data.map((item) {
                        return _cardBudget(context, item, isDark, containerBg);
                      }).toList());
                    } else {
                      return Text("aucuns donnees",
                          style: GoogleFonts.roboto(
                              color: isDark ? textDark : null,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w500));
                    }
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          backgroundColor: Colors.grey[200],
          onPressed: () =>
              _showAddBudget(context, isDark, backgroundDark, textDark),
          child:
              Icon(Icons.add, size: MediaQuery.of(context).size.width * 0.05),
        ),
        const SizedBox(
          height: 40,
        )
      ]),
    );
  }

//card widget
  Widget _cardBudget(BuildContext context, item, isDark, conteinerBg) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleBudget(itemPassToProps: item)));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: isDark ? conteinerBg : const Color(0xFF292D4E),
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: formatDate(item?.budgetDate ?? "")),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("${item?.budgetAmount ?? 0} Fcfa",
                      style: GoogleFonts.roboto(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 3, 224, 253))),
                ),
              ]),
        ),
      ),
    );
  }

  _showAddBudget(BuildContext context, isDark, background, textDark) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: isDark ? background : Colors.grey[200],
            ),
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.6,
            child: const AddBudget(),
          );
        });
  }

  //convertir la date
  Widget formatDate(String data) {
    List<String> parts = data.split('-');
    int month = int.parse(parts[1]);
    int year = int.parse(parts[0]);
    switch (month) {
      case 01:
        return Text("Janvier $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 02:
        return Text("Fevrier $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 03:
        return Text("Mars  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 04:
        return Text("Avril  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 05:
        return Text("Mai  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 06:
        return Text("Juin  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 07:
        return Text("Juillet  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 08:
        return Text("Aout  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 09:
        return Text("Septembre  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 10:
        return Text("Octobre  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 11:
        return Text("Novembre  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 12:
        return Text("Decembre  $year",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      default:
        return Text("Non definit",
            style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width * 0.04));
    }
  }
}
