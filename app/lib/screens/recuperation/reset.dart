// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/recuperation/validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetToken extends StatefulWidget {
  const ResetToken({super.key});

  @override
  State<ResetToken> createState() => _ResetTokenState();
}

class _ResetTokenState extends State<ResetToken> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthServicesApi _api = AuthServicesApi();

  final _numero = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _numero.dispose();
    _email.dispose();
    super.dispose();
  }

  Future _send(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var data = {"numero": _numero.text, "email": _email.text};
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final res = await _api.postResetPassword(data);
        final decodedData = jsonDecode(res.body);
        if (res.statusCode == 200) {
          _api.showSnackBarSuccessPersonalized(context, decodedData['message']);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ValidationPassword()));
        } else {
          _api.showSnackBarErrorPersonalized(context, decodedData["message"]);
        }
      } catch (err) {
        _api.showSnackBarErrorPersonalized(context,
            "Erreur lors de l'envoi des données , veuillez réessayer. ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? backgroundDark = provider.colorBackground;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor: isDark ? backgroundDark: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: isDark ? backgroundDark:Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:Icon(Icons.arrow_back_ios_new_rounded,color:isDark ? textDark :null, size: 24)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _text(context,isDark, textDark),
                  _formNumberField(context),
                  _formEmailField(context),
                  const SizedBox(height: 100),
                  _sendButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context, isDark , textDark) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Réinitialiser le mot de passe",
                style: GoogleFonts.roboto(
                  color:isDark ? textDark :null,
                    fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir nous aider à réinitialiser votre mot de passe",
                style: GoogleFonts.roboto(
                  color:isDark ? textDark :null,
                    fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _numero,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre numero ';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_android_rounded, size:  MediaQuery.of(context).size.width*0.05),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numéro",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _formEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer votre email';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail_outline, size:  MediaQuery.of(context).size.width*0.05,),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF292D4E),
            minimumSize: const Size(350, 50)),
        onPressed: () => _send(context),
        child: Text("Envoyer",
            style: GoogleFonts.aBeeZee(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: Colors.white)));
  }
}
