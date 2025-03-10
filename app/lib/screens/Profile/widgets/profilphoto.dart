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
                height: MediaQuery.of(context).size.width*0.694,
                child: Center(
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.111),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width*0.277,
                          width: MediaQuery.of(context).size.width*0.277,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0555),
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
