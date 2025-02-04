// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/models/indicatifs.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:gestionary/screens/update/widgets/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final AuthServicesApi _api = AuthServicesApi();
  final List<Country?> _countryStream = Country.getCountries();

  final _name = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  String? selectedCountryIndicatif;

  Future _sendUpdate() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final providerProfil =
        Provider.of<UserInfosProvider>(context, listen: false);
    final userId = await provider.userId();
    var data = {
      "name": _name.text,
      "phone_number": _numero.text,
      "email": _email.text,
    };
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final res = await _api.postUpdateUserData(data, userId);
      final body = json.decode(res.body);
      if (res.statusCode == 200) {
        ModelUser user = ModelUser.fromJson(body['profil']);
        providerProfil.saveToLocalStorage(user);
        _api.showSnackBarSuccessPersonalized(context, body['message']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const EditUser()));
      } else {
        _api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (err) {
      _api.showSnackBarErrorPersonalized(context,
          "Erreur lors de l'envoi des données , veuillez réessayer. $err");
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _numero.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    Color? containerDark = provider.containerBackg;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor: isDark? containerDark :Colors.grey[200],
      appBar: const UpdateAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: isDark ? backgroundDark:Colors.white, 
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                _text(context ,isDark , textDark),
                _textFieldName(context,),
                _textFieldNumber(context),
                _textFieldMail(context),
                const SizedBox(height: 100),
                _buttonSend(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(BuildContext context,isDark , textDark) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Changer le profil ",
              style:
                  GoogleFonts.roboto(
                    color:isDark ? textDark : null,
                    fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vous pouvez apporter des modifications à votre profil",
              style:
                  GoogleFonts.roboto(
                    color:isDark ? textDark : null,
                    fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFieldName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _name,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Name",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.person_2_outlined, size:  MediaQuery.of(context).size.width*0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _countryDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        hint: Text("(+ code)", style: GoogleFonts.roboto(fontSize: 16)),
        isExpanded: true,
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
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "${country?.dialCode}",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
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

  Widget _textFieldNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _numero,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Numero",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.phone_android, size:  MediaQuery.of(context).size.width*0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _textFieldMail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Email",
          hintStyle:
              GoogleFonts.aBeeZee(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.mail_outline, size:  MediaQuery.of(context).size.width*0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buttonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF292D4E),
              elevation: 5,
              fixedSize: const Size(320, 50)),
          onPressed: _sendUpdate,
          icon: Icon(Icons.edit, size:  MediaQuery.of(context).size.width*0.05, color: Colors.grey[100]),
          label: Text("Modifier le profil",
              style: GoogleFonts.roboto(
                  fontSize:  MediaQuery.of(context).size.width*0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[100]))),
    );
  }
}
