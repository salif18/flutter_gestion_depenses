import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/utils/server_uri.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const String urlServer = AppURI.URLSERVER;

class AuthServicesApi {
  //fontion de registre
  postUserRegistreData(data) async {
    var uri = "$urlServer/auth/registre";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getCountry() async {
    var uri = "https://restcountries.com/v2/all?fields=name,callingCodes";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //fonction de connexion
  postUserLoginData(data) async {
    var uri = "$urlServer/auth/login";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

//deconnexion
  postUserLogoutToken(token) async {
    var uri = "$urlServer/logout";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
  }

  //fontion de update user
  postUpdateUserData(data, userId) async {
    var uri = "$urlServer/profil/update/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //fontion de update passeword
  postUpdatePassword(data, userId) async {
    var uri = "$urlServer/auth/update_password/$userId";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //fontion de reset password
  postResetPassword(data) async {
    var uri = "$urlServer/auth/reset_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //fontion de validate password
  postValidatePassword(data) async {
    var uri = "$urlServer/auth/validate_password";
    return await http.post(
      Uri.parse(uri),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  //suppression compte
  deleteUserTokenUserId(token) async {
    var uri = "$urlServer/delete";
    return await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
  }

  //message en cas de succès!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  //message en cas d'erreur!
  void showSnackBarErrorPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500)),
      backgroundColor: const Color.fromARGB(255, 255, 35, 19),
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
