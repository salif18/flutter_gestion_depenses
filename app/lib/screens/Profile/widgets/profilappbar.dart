import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {

 @override 
 Size get preferredSize => const Size.fromHeight(80);
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color:Color.fromARGB(255, 224, 224, 224))),
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 85,
           title: Text("Profil",
             style:GoogleFonts.aBeeZee(
              fontSize: MediaQuery.of(context).size.width*0.05,
              fontWeight: FontWeight.w700, 
              color:isDark ? textDark :Colors.black),
            ),
            centerTitle: true,
            backgroundColor: isDark ? backgroundDark :Colors.white,
            elevation: 0,
      ),
    );
  }
}