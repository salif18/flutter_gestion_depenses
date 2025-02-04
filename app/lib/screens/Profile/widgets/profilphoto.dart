import 'package:flutter/material.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyProfilPictureInfos extends StatelessWidget {
  const MyProfilPictureInfos({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Consumer<UserInfosProvider>(
      builder: (context, provider, child) {
       return FutureBuilder<ModelUser?>(
          future: provider.loadProfilFromLocalStorage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final ModelUser? profil = snapshot.data;
              return SizedBox(
                height: 250,
                child: Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(profil?.name ?? "",
                                style: GoogleFonts.aBeeZee(
                                  color: isDark ? textDark : null,
                                    fontSize:  MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w600)),
                            Text(profil?.email ?? "",
                                style: GoogleFonts.roboto(
                                   color: isDark ? textDark :Colors.grey ,
                                    fontSize:  MediaQuery.of(context).size.width*0.04,))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Text('Aucune donnée disponible',
                  style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width*0.04, color: Colors.grey));
            }
          });
    });
  }
}
