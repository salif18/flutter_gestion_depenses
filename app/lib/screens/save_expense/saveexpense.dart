// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:gestionary/api/api_budget.dart';
import 'package:gestionary/api/api_categories.dart';
import 'package:gestionary/api/api_depense.dart';
import 'package:gestionary/models/categories.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/budgets/addbudgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaveExpenses extends StatefulWidget {
  const SaveExpenses({super.key});

  @override
  State<SaveExpenses> createState() => _SaveExpensesState();
}

class _SaveExpensesState extends State<SaveExpenses> {
  final ExpenseServicesApi expenseApi = ExpenseServicesApi();
  final CategoriesApi categApi = CategoriesApi();
  final BudgetApi _budgetApi = BudgetApi();

  List<ModelCategories> modelCategories = [];
  dynamic _currentBudget;

//une cle global pour le formulaire
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //declarations des champs de formulaire
  final amount = TextEditingController();
  final description = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedCategoryValue;

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    super.dispose();
  }

//recuperer les cetegories par defaults
  Future<void> getCategoriesForm() async {
     final provider = Provider.of<AuthProvider>(context, listen: false);
       var userId = await provider.userId();
    try {
      final res = await categApi.getCategories(userId);
      dynamic decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          modelCategories = (decodedData['categories'] as List)
              .map((json) => ModelCategories.fromJson(json))
              .toList();
        });
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> getCurrentBudget() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _budgetApi.getCurrentBudget(userId);
      dynamic decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          _currentBudget = decodedData["budget"];
        });
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

//envoyer les donnees formulaires vers la base de donnees
  Future<void> postToServerData() async {
    if (_currentBudget != null) {
      if (_formKey.currentState!.validate()) {
        final provider = Provider.of<AuthProvider>(context, listen: false);
        var userId = await provider.userId();
        var data = {
          "userId": userId.toString(),
          "categorie_id": selectedCategoryValue.toString(),
          "budgetId": _currentBudget["id"],
          "amount": amount.text,
          "description": description.text,
          "date_expenses": selectedDate.toIso8601String(),
        };
        try {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
          final response = await expenseApi.postExpenses(data);
          final body = json.decode(response.body);
          if (response.statusCode == 201) {
            expenseApi.showSnackBarSuccessPersonalized(
                context, body["message"]);
                
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const SaveExpenses()));
          } else {
            expenseApi.showSnackBarErrorPersonalized(
                context, "Erreur donnees non enregistres, veuillez réessayer");
          }
        } catch (err) {
          expenseApi.showSnackBarErrorPersonalized(
              context, "Erreur de serveur, veuillez réessayer");
        }
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AddBudget()));
    }
  }

  @override
  void initState() {
    getCategoriesForm();
    getCurrentBudget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    Color? containerBg = provider.containerBackg;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor:isDark? backgroundDark: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: isDark? backgroundDark:Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isDark? backgroundDark:Colors.grey[100]
                    // const Color.fromARGB(255, 60, 66, 122)
                    ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    size:  MediaQuery.of(context).size.width*0.05, color: Colors.grey[400]))),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark? containerBg:Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _text(context,isDark ,textDark),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _textFormMontant(context),
                      _textSelectCategorie(context),
                      _textDescritptionForm(context),
                      _dateForm(context),
                      const SizedBox(height: 20),
                      _buttonSend(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context,isDark,textDark) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nouvelles dépenses",
                  style: GoogleFonts.roboto(
                      fontSize:  MediaQuery.of(context).size.width*0.04,
                      color: isDark ? textDark:Colors.black,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Enregistrer toutes vos dépenses effectuees de la journee",
                  style: GoogleFonts.aBeeZee(
                      fontSize: MediaQuery.of(context).size.width*0.04,
                      color: isDark ? textDark:const Color.fromARGB(255, 46, 44, 44),
                      fontWeight: FontWeight.w300)),
            )
          ],
        ));
  }

  Widget _textFormMontant(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: amount,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un montant';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Montant",
          hintStyle: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04),
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.monetization_on_outlined, size:  MediaQuery.of(context).size.width*0.05),
        ),
      ),
    );
  }

  Widget _textSelectCategorie(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          hint: Text("Choisir une categories",
              style: GoogleFonts.roboto(
                  fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
          value: selectedCategoryValue,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Veuillez choisir une categorie';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedCategoryValue = value;
            });
          },
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.category_outlined, size:  MediaQuery.of(context).size.width*0.05),
          ),
          items: modelCategories.map((categorie) {
            return DropdownMenuItem<String?>(
              value: categorie.id.toString(),
              child: Text(
                categorie.categoryName ?? "",
                style: GoogleFonts.roboto(
                  fontSize: MediaQuery.of(context).size.width*0.04,
                  color: Colors.black,
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget _textDescritptionForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: description,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un detail sur cette depense';
          }
          return null;
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Description",
          hintStyle: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04,),
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.list_alt_rounded,
              color: Color.fromARGB(255, 5, 5, 5), size:  MediaQuery.of(context).size.width*0.05),
        ),
      ),
    );
  }

  Widget _dateForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DateTimeFormField(
        decoration: InputDecoration(
          hintText: 'Ajouter une date',
          hintStyle: GoogleFonts.roboto(fontSize: 20),
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.calendar_month_rounded,
              color: Color.fromARGB(255, 255, 136, 128), size:  MediaQuery.of(context).size.width*0.05),
        ),
        hideDefaultSuffixIcon: true,
        mode: DateTimeFieldPickerMode.date,
        initialValue: DateTime.now(),
        onChanged: (DateTime? value) {
          selectedDate = value!;
        },
      ),
    );
  }

  Widget _buttonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF292D4E),
            minimumSize: const Size(double.infinity, 60),
          ),
          onPressed: postToServerData,
          icon: Icon(Icons.save_outlined, color: Colors.grey[100], size:  MediaQuery.of(context).size.width*0.05),
          label: Text(
            "Enregistrer",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: Colors.grey[100]),
          ),
        ),
      ),
    );
  }
}
