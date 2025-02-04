import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? backgroundDark = provider.colorBackground;
    Color? iconDark = provider.colorText;
    return AppBar(
      toolbarHeight: 80,
      centerTitle: false,
      backgroundColor: isDark ? backgroundDark : null,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? iconDark : null, size: 25)),
      title: Row(
        children: [
          Text("Reglages",
              style: GoogleFonts.roboto(
                  color: isDark ? iconDark : null,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 20),
          Icon(Icons.settings_outlined,
              color: isDark ? iconDark : null, size: 25)
        ],
      ),
    );
  }
}
