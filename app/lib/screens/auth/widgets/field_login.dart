// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/models/indicatifs.dart';
import 'package:gestionary/screens/auth/registre.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:gestionary/routes/routes.dart';
import 'package:gestionary/screens/recuperation/reset.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyFieldForms extends StatefulWidget {
  const MyFieldForms({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFieldFormsState createState() => _MyFieldFormsState();
}

class _MyFieldFormsState extends State<MyFieldForms> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthServicesApi api = AuthServicesApi();
  final List<Country?> _countryStream = Country.getCountries();

  //INITIALISATION DES CHAMPS DE FORMULAIRE
  final contacts = TextEditingController();
  final password = TextEditingController();
  String? selectedCountryIndicatif;

  @override
  void dispose() {
    contacts.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> sendToServer(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "contacts": 
        // contacts.text.contains("@")
            // ? contacts.text.trim()
            // : 
            // "$selectedCountryIndicatif$
            contacts.text.trim(),
        "password": password.text
      };
      final providerAuth = Provider.of<AuthProvider>(context, listen: false);
      final providerProfil =
          Provider.of<UserInfosProvider>(context, listen: false);
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final response = await api.postUserLoginData(data);
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ModelUser user = ModelUser.fromJson(body['profil']);
          providerAuth.loginButton(body['token'], body["userId"].toString());
          providerProfil.saveToLocalStorage(user);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainRoutes()));
        } else {
          api.showSnackBarErrorPersonalized(context, body["message"]);
          print(body["message"]);
        }
      } catch (error) {
        api.showSnackBarErrorPersonalized(context,
            "Erreur lors de l'envoi des données , veuillez réessayer, $error");
            print(error);
      }
    }
  }

  //visibilité de password
  bool visibilityPassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _text(context),
              // _countryDropdown(context),
              _formFieldContact(context),
              _formFieldPassword(context),
              _forgetPassword(context),
              _button(context),
              _asKACount(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Renseignez les informations demandées pour vous connecter à votre compte",
        style: GoogleFonts.aBeeZee(
          fontSize: MediaQuery.of(context).size.width*0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _formFieldContact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: contacts,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un numéro ou un e-mail';
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 250, 250, 253),
          filled: true,
          hintText: "Numéro ou e-mail",
          hintStyle: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.phone_android_rounded,
            color: Color.fromARGB(255, 38, 38, 85),
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _countryDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text("(+ Indicatif)",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w300)),
        isExpanded: true,
        value: selectedCountryIndicatif,
        items: _countryStream.map((country) {
          return DropdownMenuItem<String>(
            value: country?.dialCode,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${country?.name}',
                  style: GoogleFonts.roboto(
                    fontSize: MediaQuery.of(context).size.width*0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "${country?.dialCode}",
                  style: GoogleFonts.roboto(
                    fontSize: MediaQuery.of(context).size.width*0.04,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCountryIndicatif = value?.toString();
          });
        },
        decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _formFieldPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: visibilityPassword,
        controller: password,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer un mot de passe';
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 250, 250, 253),
          filled: true,
          hintText: "Votre mot de passe",
          hintStyle: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.key,
            color: Color.fromARGB(255, 38, 38, 85),
            size: 28,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                visibilityPassword = !visibilityPassword;
              });
            },
            icon: Icon(
              visibilityPassword ? Icons.visibility_off : Icons.visibility,
              size: 28,
            ),
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
        ),
      ),
    );
  }

  Widget _forgetPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(children: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResetToken()));
            },
            child: Text("Mot de passe oublié ?",
                style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04,)))
      ]),
    );
  }

  Widget _button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ElevatedButton(
        onPressed: () => sendToServer(context),
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(400, 50),
          backgroundColor: const Color.fromARGB(255, 111, 116, 161),
        ),
        child: Center(
          child: Text(
            "Se connecter",
            style: GoogleFonts.roboto(
              fontSize: MediaQuery.of(context).size.width*0.04,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ou(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Ou",
          style: GoogleFonts.aBeeZee(
              fontSize: MediaQuery.of(context).size.width*0.04,
              color: const Color.fromARGB(255, 38, 38, 85),
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _reseauxSociaux(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainRoutes()));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/images/google.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFF292D4E),
                ),
                child: Image.asset(
                  'assets/images/apple.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _asKACount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Vous n'avez pas de compte ? -",
            style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04,),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistreWidget()),
              );
            },
            child: Text(
              "Créer",
              style: GoogleFonts.roboto(
                fontSize: MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
