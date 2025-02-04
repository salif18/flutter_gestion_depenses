// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ValidationPassword extends StatefulWidget {
  const ValidationPassword({super.key});

  @override
  State<ValidationPassword> createState() => _ValidationPasswordState();
}

class _ValidationPasswordState extends State<ValidationPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthServicesApi _api = AuthServicesApi();

  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  String resetTokenValue = "";

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future _send(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "resetToken": resetTokenValue,
        "new_password": _newPassword.text.trim(),
        "confirm_password": _confirmPassword.text.trim()
      };
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final res = await _api.postValidatePassword(data);
        final decodedData = jsonDecode(res.body);
        if (res.statusCode == 200) {
          _api.showSnackBarSuccessPersonalized(context, decodedData['message']);
          Navigator.pop(context);
        } else {
          _api.showSnackBarErrorPersonalized(context, decodedData["message"]);
        }
      } catch (err) {
        _api.showSnackBarErrorPersonalized(context,
            "Erreur lors de l'envoi des données , veuillez réessayer.");
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
      backgroundColor: isDark ? backgroundDark : Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: isDark ? backgroundDark : Colors.grey[200],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: isDark ? textDark : null, size: 24)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _text(context, isDark, textDark),
                _formNewPassword(context),
                _formConfirmPassword(context),
                _secondText(context, isDark, textDark),
                _codes4Champs(context),
                const SizedBox(height: 100),
                _sendButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context, isDark, textDark) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Validation le mot de passe",
                style: GoogleFonts.roboto(
                    color: isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.05,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Veuillez entrer les bonnes informations pour pouvoir valider le nouveau mot de passe",
                style: GoogleFonts.roboto(
                    color: isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                    fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _formNewPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _newPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un nouveau mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.key_rounded, size:  MediaQuery.of(context).size.width*0.05,),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Nouveau mot de passe",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _formConfirmPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _confirmPassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez retaper le meme mot de passe';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, size:  MediaQuery.of(context).size.width*0.05,),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: "Confirmer",
          labelStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _secondText(BuildContext context, isDark, textDark) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Entrez les 4 chiffres envoyés sur votre e-mail",
                style: GoogleFonts.roboto(
                    color: isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                    fontWeight: FontWeight.w400))));
  }

  Widget _codes4Champs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PinCodeTextField(
            appContext: context,
            length: 4,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 80,
                fieldWidth: 75,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey),
            onCompleted: (value) {
              setState(() {
                resetTokenValue = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer les 4 chiffres de validation';
              }
              return null;
            },
          )),
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
