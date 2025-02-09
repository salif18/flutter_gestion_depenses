import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/budgets/addbudgets.dart';
import 'package:gestionary/screens/home/home.dart';
import 'package:gestionary/screens/Profile/profil.dart';
import 'package:gestionary/screens/save_expense/saveexpense.dart';
import 'package:gestionary/screens/statistiques/statistiques.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MainRoutes extends StatefulWidget {
  const MainRoutes({super.key});

  @override
  State<MainRoutes> createState() => _MainRoutesState();
}

class _MainRoutesState extends State<MainRoutes> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        Home(),
        MyStats(),
        MyProfile(),
      ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  //bottomNavigationBar
  Widget _buildBottomNavigationBar() {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    return Container(
      color: isDark ? backgroundDark : Colors.grey[200],
      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
            decoration: BoxDecoration(
              color: const Color(0xFF292D4E),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.13),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0277, vertical: MediaQuery.of(context).size.width*0.022),
                child: GNav(
                  onTabChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  tabBackgroundColor: Colors.white,
                  iconSize:  MediaQuery.of(context).size.width*0.06,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  padding:
                      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0555, vertical: MediaQuery.of(context).size.width*0.021),
                  color: Colors.white,
                  textSize:  MediaQuery.of(context).size.width*0.04,
                  textStyle: GoogleFonts.roboto(
                      fontSize:  MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.w500),
                  style: GnavStyle.google,
                  gap: 10,
                  tabs: const [
                    GButton(icon: LineIcons.home, text: "Home"),
                    GButton(icon: Icons.bar_chart_rounded, text: "Stats"),
                    GButton(icon: Icons.person_2_outlined, text: "Profil"),
                  ],
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: MediaQuery.of(context).size.width*0.08,
            backgroundColor: const Color(0xFF292D4E),
            child: IconButton(
              onPressed: () {
                awesomeWidget(context);
              },
              icon: Icon(Icons.add, size:  MediaQuery.of(context).size.width*0.06, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

//showModalBottomSheet la fenetre modale contenant le formulaire
  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        ThemeProvider provider = Provider.of<ThemeProvider>(context);
        Color? backgroundDark = provider.colorBackground;
        bool isDark = provider.isDark;
        return Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: isDark ? backgroundDark : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MediaQuery.of(context).size.width*0.07),
                topRight: Radius.circular(MediaQuery.of(context).size.width*0.07),
              ),
            ),
            child: const SaveExpenses());
      },
    );
  }

  _showAddBudget(BuildContext context, isDark, background, textDark) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MediaQuery.of(context).size.width*0.07), topRight: Radius.circular(MediaQuery.of(context).size.width*0.07)),
              color: isDark ? background : Colors.grey[200],
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
            height: MediaQuery.of(context).size.height * 0.6,
            child: const AddBudget(),
          );
        });
  }

// fenetre pour ajouter categorie
  void awesomeWidget(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          ThemeProvider provider = Provider.of<ThemeProvider>(context);
          Color? containerBg = provider.containerBackg;
          Color? backgroundDark = provider.colorBackground;
          Color? textDark = provider.colorText;
          bool isDark = provider.isDark;
          return AlertDialog(
            backgroundColor: isDark ? containerBg : Colors.grey[200],
            title: Center(
                child: Text("Actions",
                    style: GoogleFonts.aBeeZee(
                        color: isDark ? textDark : null,
                        fontSize:  MediaQuery.of(context).size.width*0.05,
                        fontWeight: FontWeight.w600))),
            contentPadding:
                EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02, horizontal: MediaQuery.of(context).size.width*0.02),
            content: Column(
                mainAxisSize: MainAxisSize
                    .min, //pour que l'espace column s'adapte a la taille du contenu
                children: [
                  // TextButton(
                  //     onPressed: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             backgroundColor:
                  //                 isDark ? containerBg : Colors.grey[200],
                  //             content: const CreateCategories(),
                  //           );
                  //         },
                  //       );
                  //     },
                  //     child: Text("Créer votre catégorie",
                  //         style: GoogleFonts.roboto(
                  //             fontSize:  MediaQuery.of(context).size.width*0.05,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.black))),
                  const Divider(
                    height: 2,
                  ),
                  TextButton(
                      onPressed: () {
                        _showAddBudget(
                            context, isDark, backgroundDark, textDark);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.006),
                            width: MediaQuery.of(context).size.width*0.069,height: MediaQuery.of(context).size.width*0.069,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color(0xFF292D4E),),
                            child: Icon(Icons.attach_money_sharp,size: MediaQuery.of(context).size.width*0.05 ,color:Colors.red)),
                          const SizedBox(width: 10),
                          Text("Entrer le budget du mois",
                              style: GoogleFonts.roboto(
                                  fontSize:  MediaQuery.of(context).size.width*0.043,
                                  fontWeight: FontWeight.w500,
                                  color:isDark ? textDark :  Colors.black)),
                        ],
                      )),
                  const Divider(
                    height: 2,
                  ),
                  TextButton(
                      onPressed: () {
                        _showAdd(context);
                      },
                      child: Row(
                        children: [
                           Container(
                             padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.006),
                            width: MediaQuery.of(context).size.width*0.069,height: MediaQuery.of(context).size.width*0.069,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color(0xFF292D4E),),
                            child: Icon(Icons.monetization_on_outlined,size: 20,color:Colors.orange)),
                            const SizedBox(width: 10),
                          Text("Enregistrer vos dépenses",
                              style: GoogleFonts.roboto(
                                  fontSize:  MediaQuery.of(context).size.width*0.043,
                                  fontWeight: FontWeight.w500,
                                  color:isDark ? textDark :Colors.black)),
                        ],
                      ))
                ]),
          );
        });
  }
}
