import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/settings/widgets/appbar.dart';
import 'package:gestionary/screens/update/updatepassword.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? backgroundDark = provider.colorBackground;
    Color? containerDark = provider.containerBackg;
    return Scaffold(
      backgroundColor: isDark ? backgroundDark : Colors.grey[200],
      appBar: const SettingsAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: isDark ? containerDark : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _notificationReglage(context, provider),
                    Container(height: 1, width: 320, color: Colors.grey[200]),
                    _themeReglage(context, provider),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: isDark ? containerDark : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _changerMotdePass(context, provider),
                    Container(height: 1, width: 320, color: Colors.grey[200]),
                    _about(context, provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationReglage(BuildContext context, ThemeProvider provider) {
    bool isDark = provider.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notifications_none_outlined,
                      color: isDark ? Colors.white : null, size:  MediaQuery.of(context).size.width*0.05),
                  const SizedBox(width: 10),
                  Text("Notification",
                      style: GoogleFonts.aBeeZee(
                          color: isDark ? Colors.white : null,
                          fontSize:  MediaQuery.of(context).size.width*0.04,
                          fontWeight: FontWeight.w300))
                ],
              ),
            ],
          ),
          const Expanded(child: Switch(value: true, onChanged: null))
        ],
      ),
    );
  }

  Widget _themeReglage(BuildContext context, provider) {
    bool isDark = provider.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Icon(Icons.wb_sunny_outlined,
                  color: isDark ? Colors.white : null,
                      size:  MediaQuery.of(context).size.width*0.05 ),
                  const SizedBox(width: 10),
                  Text(isDark ? "Thème sombre" : "Thème clair",
                      style: GoogleFonts.aBeeZee(
                          color: isDark ? Colors.white : null,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                          fontWeight: FontWeight.w300))
                ],
              ),
            ],
          ),
          Expanded(
              child: Switch(
            value: isDark,
            onChanged: (value) {
              provider.changeTheme();
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.grey[200],
            inactiveThumbColor: Colors.white,
            
          ))
        ],
      ),
    );
  }

  Widget _changerMotdePass(BuildContext context, ThemeProvider provider) {
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      height: 100,
      child: InkWell(
        onTap: () => _showUpdatePassword(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.sync_lock_rounded,
                        color: isDark ? textDark : null, size:  MediaQuery.of(context).size.width*0.05),
                    const SizedBox(width: 10),
                    Text("Changer mot de passe",
                        style: GoogleFonts.aBeeZee(
                            color: isDark ? textDark : null,
                            fontSize:  MediaQuery.of(context).size.width*0.04,
                            fontWeight: FontWeight.w300))
                  ],
                ),
              ],
            ),
            Expanded(
                child: Icon(Icons.arrow_forward_ios_rounded,
                    color: isDark ? textDark : null, size:  MediaQuery.of(context).size.width*0.05))
          ],
        ),
      ),
    );
  }

  Widget _about(BuildContext context, ThemeProvider provider) {
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      height: 100,
      child: InkWell(
        onTap: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.help_outline_outlined, color: isDark ? textDark : null, size:  MediaQuery.of(context).size.width*0.05),
                    const SizedBox(width: 10),
                    Text("A propos",
                        style: GoogleFonts.aBeeZee(
                            color: isDark ? textDark : null,
                            fontSize:  MediaQuery.of(context).size.width*0.04,
                            fontWeight: FontWeight.w300))
                  ],
                ),
              ],
            ),
            Expanded(
                child: Icon(Icons.arrow_forward_ios_rounded,
                    color: isDark ? textDark : null, size:  MediaQuery.of(context).size.width*0.05))
          ],
        ),
      ),
    );
  }

  void _showUpdatePassword(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          ThemeProvider provider = Provider.of<ThemeProvider>(context);
          bool isDark = provider.isDark;

          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.black : null,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: const UpdatePassword());
        });
  }
}
