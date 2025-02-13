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
        // top: MediaQuery.of(context).padding.top * 1.2
        ),
      child: Container(
        color: isDark? null : const Color(0xFF292D4E),
        padding: EdgeInsets.only(
          left:MediaQuery.of(context).size.width * 0.0555,top:MediaQuery.of(context).size.width * 0.2
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.023),
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
                              print(statsYear);
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon(Icons.balance_rounded, size: MediaQuery.of(context).size.width*0.06, color:Colors.black),
                                  // SizedBox(width: MediaQuery.of(context).size.width * 0.0277),
                                  Text(
                                    "Balance de ${statsYear?.year}",
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
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon(Icons.balance_rounded, size: MediaQuery.of(context).size.width*0.06, color:Colors.black),
                                  // SizedBox(width: MediaQuery.of(context).size.width * 0.0277),
                                  Text(
                                    "Balance ",
                                    style: GoogleFonts.roboto(
                                      
                                      fontSize:  MediaQuery.of(context).size.width*0.05,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isDark ? textDark:const Color.fromARGB(255, 161, 161, 161),
                                    ),
                                  ),
                                ],
                              );
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
                              padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.width *0.0222),
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
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.width*0.0222),
                              child: Text("0 XOF",style: GoogleFonts.roboto(
                                        fontSize:  MediaQuery.of(context).size.width*0.05,
                                        fontWeight: FontWeight.w600,
                                        color:  Colors.red 
                                      ),),
                            );
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