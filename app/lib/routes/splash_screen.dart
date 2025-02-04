import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestionary/routes/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MainRoutes())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
            child: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          duration: const Duration(seconds: 5),
          child: Container(
            padding: const EdgeInsets.only(top: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    key: UniqueKey(),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: const Color(0xFF292D4E),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage("assets/images/finance.png"),
                                fit: BoxFit.contain
                                )
                              ),  
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "FinanceFlow",
                              style: GoogleFonts.roboto(fontSize: 16),
                            )),
                      ],
                    )),
                Column(
                  children: [
                    Text(
                      "from",
                      style: GoogleFonts.aBeeZee(fontSize: 16),
                    ),
                    Text(
                      "devSoft",
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 39, 41, 41),
                          fontWeight: FontWeight.w800),
                    )
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
