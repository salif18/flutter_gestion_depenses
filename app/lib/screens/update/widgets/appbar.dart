import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateAppBar extends StatelessWidget implements PreferredSizeWidget {
 const UpdateAppBar({super.key});
@override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return AppBar(
      toolbarHeight: 80,
      backgroundColor:  isDark ? backgroundDark : null,
      leading: IconButton(
        onPressed: ()=> Navigator.pop(context),
       icon: Icon(Icons.arrow_back_ios_new_rounded ,
       size:24, color:isDark ? textDark : null)),
       title: Text("Modification de compte",
       style:GoogleFonts.roboto(
        color:isDark ? textDark : null,
        fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500,) ,),
    );
  }
}