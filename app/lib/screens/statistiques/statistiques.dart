import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/screens/statistiques/graphiques/bar_chart.dart';
import 'package:gestionary/screens/statistiques/graphiques/line_chartwidget.dart';
import 'package:gestionary/screens/statistiques/graphiques/pie_chartwidget.dart';
// import 'package:gestionary/screens/statistiques/graphiques/bar_chart.dart';
// import 'package:gestionary/screens/statistiques/graphiques/line_chartwidget.dart';
// import 'package:gestionary/screens/statistiques/graphiques/pie_chartwidget.dart';
import 'package:gestionary/screens/statistiques/widgets/analyse.dart';
import 'package:gestionary/screens/statistiques/widgets/balanceyear.dart';
import 'package:gestionary/screens/statistiques/widgets/bonus.dart';
import 'package:gestionary/screens/statistiques/widgets/mensuel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyStats extends StatefulWidget {
  const MyStats({super.key});
  @override
  State<MyStats> createState() => _MyStatsState();
}

class _MyStatsState extends State<MyStats> {
//rafraichire la page en actualisant la requette
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    fetchData();
  }

 Future<void> fetchData() async {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsYear(context);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsMonth(context);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsTheMost(context);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsCurrentBudget(context);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsAllYear(context);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsWeek(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //  Timer.periodic( const Duration(seconds:1 ), (Timer timer) { 
      fetchData();
    //  });
    
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return  SafeArea(
        child: RefreshIndicator(
          backgroundColor: const Color.fromARGB(255, 34, 12, 49),
          color: Colors.grey[100],
          onRefresh: _refresh,
          child: Scaffold(
            backgroundColor: isDark ? backgroundDark:Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const MyYearBalance(),
                  Container(height: 1, width: 350, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "Mensuelle",
                          style: GoogleFonts.roboto(
                            color:isDark ? textDark : null,
                              fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  const Mensuels(),
                  const BonusDay(),
                  const AnalyseGeneral(),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Hebdomadaire",
                              style: GoogleFonts.roboto(
                                color:isDark ? textDark : null,
                                  fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500)),
                        ],
                      )),
                  const BarChartWidget(),
                  Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Etude detaillée du budget",
                              style: GoogleFonts.roboto(
                                color:isDark ? textDark : null,
                                  fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500)),
                        ],
                      )),
                  const PieChartWidget(),
                    Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Statistics annuel",
                              style: GoogleFonts.roboto(
                                color:isDark ? textDark : null,
                                  fontSize:  MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500)),
                        ],
                      )),
                  const LineChartWidget(),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
    );
  }
}
