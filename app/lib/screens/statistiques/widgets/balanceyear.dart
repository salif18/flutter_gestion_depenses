import 'package:flutter/material.dart';
import 'package:gestionary/models/year_stats.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyYearBalance extends StatefulWidget {
  const MyYearBalance({super.key});

  @override
  State<MyYearBalance> createState() => _MyYearBalanceState();
}

class _MyYearBalanceState extends State<MyYearBalance> {
  
  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top * 1.2),
      child: Container(
        padding: const EdgeInsets.only(
          left:20,top:20
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Consumer<StatisticsProvider>(
                        builder: (context, provider, child) {
                      return StreamBuilder<ModelYearStats?>(
                          stream: provider.loadStatsYearStream(),
                          builder: (context, snapshot) {
                            // if (snapshot.connectionState ==
                            //     ConnectionState.waiting) {
                            //   return const Center(
                            //       child: CircularProgressIndicator.adaptive());
                            // } else 
                            if (snapshot.hasError) {
                              return Text("errer: ${snapshot.error}");
                            } else if (snapshot.hasData) {
                              ModelYearStats? statsYear = snapshot.data;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.balance_rounded, size: MediaQuery.of(context).size.width*0.06, color:Color.fromARGB(255, 161, 161, 161)),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Balance de ${statsYear?.year ?? 0}",
                                    style: GoogleFonts.roboto(
                                      
                                      fontSize:  MediaQuery.of(context).size.width*0.05,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isDark ? textDark:const Color.fromARGB(255, 161, 161, 161),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Text("");
                            }
                          });
                    })),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Consumer<StatisticsProvider>(
                      builder: (context, provider, child) {
                    return StreamBuilder<ModelYearStats?>(
                        stream: provider.loadStatsYearStream(),
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const Center(
                          //       child: CircularProgressIndicator());
                          // } else 
                          if (snapshot.hasError) {
                            return Text("err:${snapshot.error}");
                          } else if (snapshot.hasData) {
                            ModelYearStats? statsYear = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical:8),
                              child: Text(
                                    "${statsYear?.totalExpenses ?? 0} XOF",
                                    style: GoogleFonts.roboto(
                                      fontSize:  MediaQuery.of(context).size.width*0.05,
                                      fontWeight: FontWeight.w600,
                                      color:  Colors.red 
                                    ),
                                  ),
                            );
                          } else {
                            return const Text("0");
                          }
                        });
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}