import 'package:flutter/material.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StatSHeader extends StatelessWidget {
  const StatSHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top * 1.4, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<UserInfosProvider>(
                  builder: (context, provider, child) {
                return FutureBuilder<ModelUser?>(
                    future: provider.loadProfilFromLocalStorage(),
                    builder: (context, snapshot) {
                      final profil = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Welcome, ",
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        color: const Color.fromARGB(
                                            135, 129, 129, 129))),
                                TextSpan(
                                    text: "${profil.name} !",
                                    style: GoogleFonts.roboto(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)))
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 1,
                color: const Color.fromARGB(255, 219, 208, 208).withOpacity(1),
                width: MediaQuery.of(context).size.width,
              ),
            )
          ],
        ),
      ),
    );
  }
}
