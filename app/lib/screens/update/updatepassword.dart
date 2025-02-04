// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/recuperation/reset.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  AuthServicesApi api = AuthServicesApi();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  Future _sendUpdate() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await provider.userId();
      var data = {
        "current_password": _currentPassword.text,
        "new_password": _newPassword.text,
        "confirm_password": _passwordConfirmation.text
      };
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final res = await api.postUpdatePassword(data, userId);
        final decodedData = json.decode(res.body);
        if (res.statusCode == 200) {
          api.showSnackBarSuccessPersonalized(
              context, decodedData['message'].toString());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UpdatePassword()));
        } else {
          api.showSnackBarErrorPersonalized(
              context, decodedData["message"].toString());
        }
      } catch (err) {
        api.showSnackBarErrorPersonalized(context,
            "Erreur lors de l'envoi des données , veuillez réessayer. $err");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    Color? containerDark = provider.containerBackg;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor: isDark ? containerDark :Colors.grey[200],
      appBar: AppBar(
        backgroundColor: isDark? containerDark:Colors.grey[200],
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 24, color: Colors.grey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? backgroundDark :Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _text(context,isDark ,textDark),
                  _textFieldPassword(context),
                  _textFieldNewPassword(context),
                  _textFieldConfirmPassword(context),
                  _textPasswordForget(context),
                  const SizedBox(height: 100),
                  _buttonSend(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context,isDark ,textDark) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Changer de mot de passe",
              style:
                  GoogleFonts.roboto(
                    color:isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Votre mot de passe doit contenir au moins 6 caractères",
              style:
                  GoogleFonts.roboto(
                    color:isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFieldPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _currentPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un mot de passe actuel';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Mot de passe actuel",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _textFieldNewPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _newPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez rentrer un nouveau mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Nouveau mot de passe",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _passwordConfirmation,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez retaper le meme mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Retapez le nouveau mot de passe",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          // prefixIcon: const Icon(Icons.lock_outline_rounded, size: 33),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _textPasswordForget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResetToken()));
            },
            child: Text("Mot de passe oublié ?",
                style: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04,)))
      ]),
    );
  }

  Widget _buttonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF292D4E),
          elevation: 5,
          fixedSize: const Size(400, 50),
        ),
        onPressed: _sendUpdate,
        child: Text(
          "Changer le mot de passe",
          style: GoogleFonts.roboto(
            fontSize:  MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w500,
            color: Colors.grey[100],
          ),
        ),
      ),
    );
  }
}
