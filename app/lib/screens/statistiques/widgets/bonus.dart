import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BonusDay extends StatelessWidget {
  const BonusDay({super.key});

  @override
  Widget build(BuildContext context) {
     ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text("Analyse votre ",
              style: GoogleFonts.roboto(
                  fontSize:  MediaQuery.of(context).size.width*0.05,
                  fontWeight: FontWeight.w500,
                  color:isDark ? textDark : null,)),
        ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            // height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF292D4E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("Dépenses ",
                style: GoogleFonts.roboto(
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
        )
      ]),
    );
  }
}
