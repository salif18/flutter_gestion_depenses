import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/utils/server_uri.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

const String urlServer = AppURI.URLSERVER;

class CategoriesApi {
  //ajouter de categorie pour formulaire
  postCategories(data) async {
    var uri = "$urlServer/categories";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //obtenir categorie pour formulaire
  getCategories(userId) async {
    var uri = "$urlServer/categories/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //messade d'affichage de reponse de la requette recus
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF292D4E),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          label: "",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    ));
  }

//messade d'affichage des reponse de la requette en cas dechec
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF292D4E),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
