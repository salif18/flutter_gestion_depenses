import 'package:flutter/material.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/Profile/widgets/profilphoto.dart';
import 'package:gestionary/screens/Profile/widgets/zonereglages.dart';
import 'package:gestionary/screens/Profile/widgets/profilappbar.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    return  Scaffold(
        backgroundColor: isDark ? backgroundDark :Colors.white,
      appBar: const SettingsAppBar(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MyProfilPictureInfos(),
            MyReglages()
          ],
        ),
      )
    );
  }
}