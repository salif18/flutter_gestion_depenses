// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:gestionary/api/api_auth.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/auth/login.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/screens/settings/settings.dart';
import 'package:gestionary/screens/update/edituser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyReglages extends StatefulWidget {
  const MyReglages({super.key});

  @override
  State<MyReglages> createState() => _MyReglagesState();
}

class _MyReglagesState extends State<MyReglages> {
  AuthServicesApi api = AuthServicesApi();

  //action supprimer compte
   Future<void> _deleteUserClearTokenTosServer(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    var token = await provider.token();
    try {
      final res = await api.postUserLogoutToken(token);
      if (res.statusCode == 200) {
        provider.logoutButton(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyLogin()));
      }
    } catch (error) {
      showSnackBarErrorPersonalized(
          context, "Erreur lors de la deconnexion. $error");
    }
  }

  //message en cas de succes!
  void showSnackBarSuccessPersonalized(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
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
          style: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w500)),
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

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0555),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditUser()));
              },
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
                child: Column(
                  children: [
                    Row(
                      children: [
                      Icon(Icons.edit, size:  MediaQuery.of(context).size.width*0.05,color:isDark ? textDark : null,),
                        SizedBox(width: MediaQuery.of(context).size.width*0.0555),
                        Text(
                          "Modifier votre compte",
                          style: GoogleFonts.roboto(
                            color:isDark ? textDark : null,
                              fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                         Icon(
                          Icons.arrow_forward_ios,
                          size:  MediaQuery.of(context).size.width*0.05,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Settings()));
              },
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0555),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size:  MediaQuery.of(context).size.width*0.05,color:isDark ? textDark : null,),
                    SizedBox(width: MediaQuery.of(context).size.width*0.0555),
                    Text(
                      "Réglages",
                      style: GoogleFonts.roboto(
                        color:isDark ? textDark : null,
                          fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size:  MediaQuery.of(context).size.width*0.05,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
            child: InkWell(
              onTap: (){
                 final provider = Provider.of<AuthProvider>(context, listen: false);
                 provider.logoutButton(context);
              },
              child: Center(
                child: Container(     
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300]),
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
                  width: MediaQuery.of(context).size.width*0.777,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //const Icon(Icons.logout_rounded, size:30),
                      SizedBox(width: MediaQuery.of(context).size.width*0.0555),
                      Text(
                        "Se déconnecter",
                        style: GoogleFonts.roboto(
                            fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width*0.0555),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
            child: InkWell(
              onTap: () {
                _showConfirmDelete(context);
              },
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0277),
                child: Center(
                  child: Text(
                    "Supprimer mon compte",
                    style: GoogleFonts.roboto(
                      
                        fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w600,color:const Color.fromARGB(255, 107, 111, 148)),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  _showConfirmDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text("Avertissement")),
            contentPadding:
                EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.0555, horizontal: MediaQuery.of(context).size.width*0.0555),
            content: Column(
              mainAxisSize: MainAxisSize
                  .min, //pour que l'espace column s'adapte a la taille du contenu
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0222),
                  child: Text(
                      "Etes-vous sur de vouloir supprimer votre compte? cette action est irreversible.",
                      style:
                          GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04, color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0222),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Non",
                              style: TextStyle(color: Color(0xFF292D4E)))),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF292D4E),
                          ),
                          onPressed:() =>_deleteUserClearTokenTosServer(context),
                          child: const Text("Oui",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
