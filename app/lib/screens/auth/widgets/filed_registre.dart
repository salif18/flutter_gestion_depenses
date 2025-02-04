// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/models/indicatifs.dart';
import 'package:gestionary/screens/auth/login.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:gestionary/routes/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FieldFormRegistre extends StatefulWidget {
  const FieldFormRegistre({super.key});

  @override
  State<FieldFormRegistre> createState() => _FieldFormRegistreState();
}

class _FieldFormRegistreState extends State<FieldFormRegistre> {
  final AuthServicesApi api = AuthServicesApi();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Country?> _countryStream = Country.getCountries();

  //INITIALISATION DES CHAMPS DE FORMULAIRE
  final name = TextEditingController();
  final numero = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String? selectedCountryIndicatif;

  @override
  void dispose() {
    name.dispose();
    numero.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> postToServerDataRegistre() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "name": name.text,
        "phone_number": numero.text.trim(),
        "email": email.text,
        "password": password.text
      };
      final provider = Provider.of<AuthProvider>(context, listen: false);
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
        final response = await api.postUserRegistreData(data);
        final body = json.decode(response.body);
        if (response.statusCode == 201) {
          ModelUser user = ModelUser.fromJson(body['profil']);
          provider.loginButton(body['token'], body["userId"].toString());
          providerProfil.saveToLocalStorage(user);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainRoutes()));
        } else {
          api.showSnackBarErrorPersonalized(context, body["message"]);
           print(body["message"]);
        }
      } catch (error) {
        api.showSnackBarErrorPersonalized(context,
            "Erreur lors de l'envoi des données , veuillez réessayer. $error");
            print(error);
      }
    }
  }

//visibiliter de password
  bool visibilityPassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                _text(context),
                _formPseudoField(context),
                // _countryDropdown(context),
                _formNumberField(context),
                _formEmailField(context),
                _formPasswordField(context),
                _button(context),
                // _ou(context),
                // _reseauxSociaux(context),
                _askACount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Renseignez les informations demandées ",
        style: GoogleFonts.aBeeZee(
          fontSize: MediaQuery.of(context).size.width*0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _formPseudoField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: name,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un nom utilisateur';
          }
          return null;
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 250, 250, 253),
          filled: true,
          hintText: "Votre pseudo",
          hintStyle: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          prefixIcon: Icon(Icons.person_2_outlined,
              color: Color.fromARGB(255, 38, 38, 85), size:MediaQuery.of(context).size.width*0.06),
        ),
      ),
    );
  }

  Widget _countryDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text("(+ Indicatif)", style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04,)),
        isExpanded: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un indicatif ';
          }
          return null;
        },
        value: selectedCountryIndicatif,
        items: _countryStream.map((country) {
          return DropdownMenuItem<String>(
            value: country?.dialCode,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget _formNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: numero,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un numero ';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 250, 250, 253),
          filled: true,
          hintText: "Numéro avec indicatif",
          hintStyle: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          prefixIcon: Icon(Icons.phone_android_rounded,
              color: Color.fromARGB(255, 38, 38, 85), size: MediaQuery.of(context).size.width*0.06),
        ),
      ),
    );
  }

  Widget _formEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez entrer un e-mail';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 250, 250, 253),
          filled: true,
          hintText: "Votre email",
          hintStyle: GoogleFonts.roboto(
            fontSize: MediaQuery.of(context).size.width*0.04,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 38, 38, 85),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          prefixIcon: Icon(Icons.mail_outline,
              color: Color.fromARGB(255, 38, 38, 85), size: MediaQuery.of(context).size.width*0.06),
        ),
      ),
    );
  }

  Widget _formPasswordField(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: password,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Veuillez entrer un mot de passe';
            }
            return null;
          },
          keyboardType: TextInputType.visiblePassword,
          obscureText: visibilityPassword,
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
                borderSide: BorderSide.none),
            prefixIcon: Icon(Icons.key,
                color: Color.fromARGB(255, 38, 38, 85), size: MediaQuery.of(context).size.width*0.06),
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
        ));
  }

  Widget _button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          onPressed: postToServerDataRegistre,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              minimumSize: const Size(400, 50),
              backgroundColor: const Color.fromARGB(255, 111, 116, 161)),
          child: Text("Créer",
              style: GoogleFonts.roboto(
                  fontSize: MediaQuery.of(context).size.width*0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.white))),
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

  Widget _askACount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Déjà un de compte ? -", style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04,)),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyLogin()));
            },
            child: Text(
              "Sign",
              style: GoogleFonts.roboto(
                  fontSize: MediaQuery.of(context).size.width*0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[400]),
            ))
      ]),
    );
  }
}
