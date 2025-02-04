// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_categories.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateCategories extends StatefulWidget {
  const CreateCategories({super.key});

  @override
  State<CreateCategories> createState() => _CreateCategoriesState();
}

class _CreateCategoriesState extends State<CreateCategories> {
  final CategoriesApi _cateApi = CategoriesApi();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameCategorie = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameCategorie.dispose();
  }

  Future<void> sendCategorie() async {
    if (_formKey.currentState!.validate()) {
       final provider = Provider.of<AuthProvider>(context, listen: false);
       var userId = await provider.userId();
       var data = {
        "userId":userId,
        "name_categories": nameCategorie.text
        };
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final res = await _cateApi.postCategories(data);
        final dynamic decodedData = jsonDecode(res.body);
        if (res.statusCode == 201) {
          _cateApi.showSnackBarSuccessPersonalized(
              context, decodedData["message"].toString());
              Navigator.pop(context);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const CreateCategories()));
        } else {
          _cateApi.showSnackBarErrorPersonalized(
              context, decodedData["message"]);
        }
      } catch (e) {
        _cateApi.showSnackBarErrorPersonalized(
            context, "Erreur de serveur . Veuillez reessayer");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? textDark = provider.colorText;
    bool isDark = provider.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Personnaliser vos catégories",
                      style: GoogleFonts.roboto(
                          color: isDark ? textDark : null,
                          fontSize:  MediaQuery.of(context).size.width*0.05,
                          fontWeight: FontWeight.w300))),
              _categorieForm(context),
              const SizedBox(height: 20),
              _buttonSend(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _categorieForm(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextFormField(
            controller: nameCategorie,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer une categorie';
              }
              return null;
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 250, 250, 253),
              filled: true,
              hintText: "Nom de la catégorie",
              hintStyle: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 38, 38, 85),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.category_outlined,
                color: Color.fromARGB(255, 38, 38, 85),
                size:  MediaQuery.of(context).size.width*0.05,
              ),
            )));
  }

  Widget _buttonSend(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF292D4E),
                minimumSize: const Size(double.infinity, 50)),
            onPressed: sendCategorie,
            child: Text("Sauvegarder",
                style: GoogleFonts.roboto(
                    fontSize:  MediaQuery.of(context).size.width*0.04, color: Colors.grey[200]))));
  }
}
