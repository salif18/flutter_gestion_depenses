import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestionary/models/week_stats.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BarChartExpense extends StatefulWidget {
  BarChartExpense({super.key});

  // ignore: deprecated_member_use
  final Color barBackgroundColor = Colors.black.withOpacity(0.4);

  final Color barColor = const Color(0xFFD5CEDD);
  final Color touchedBarColor = Colors.green;
  final Color touchedBarSumColor = Colors.amber;

  @override
  State<StatefulWidget> createState() => BarChartExpenseState();
}

class BarChartExpenseState extends State<BarChartExpense> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StatisticsProvider>(context);
    List<ModelWeekStats?>? receivedDataWeek = provider.receivedDataWeekNoStream;
    return receivedDataWeek!.isEmpty
        ? Center(
            child: Text("Aucuns données disponibles",
                style: GoogleFonts.roboto(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.white)))
        : AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0222),
                        child: BarChart(
                          mainBarData(),
                          // ignore: deprecated_member_use
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.0333,
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? log(y + 1) : log(y + 1),
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

// AFFICHER LE RESULTATS DES STATS DANS LE GRAPH
  List<BarChartGroupData> showingGroups() {
    final provider = Provider.of<StatisticsProvider>(context);
    List<ModelWeekStats>? receivedData = provider.receivedDataWeekNoStream;
    //  Vérifie si les données sont bien chargées et ont au moins 7 éléments
    if (receivedData == null || receivedData.length < 7) {
      return []; // Retourne une liste vide pour éviter l'erreur
    }
    return List.generate(7, (i) {
      final provider = Provider.of<StatisticsProvider>(context);
      List<ModelWeekStats>? receivedData = provider.receivedDataWeekNoStream;
      switch (i) {
        case 0:
          return makeGroupData(0, receivedData![0].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 1:
          return makeGroupData(1, receivedData![1].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 2:
          return makeGroupData(2, receivedData![2].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 3:
          return makeGroupData(3, receivedData![3].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 4:
          return makeGroupData(4, receivedData![4].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 5:
          return makeGroupData(5, receivedData![5].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        case 6:
          return makeGroupData(6, receivedData![6].total?.toDouble() ?? 0,
              isTouched: i == touchedIndex);
        default:
          return throw Error();
      }
    });
  }

  BarChartData mainBarData() {
    final provider = Provider.of<StatisticsProvider>(context);
    List<ModelWeekStats>? receivedData = provider.receivedDataWeekNoStream;
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          //  tooltipBgColor: Colors.transparent,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Lundi';
                break;
              case 1:
                weekDay = 'Mardi';
                break;
              case 2:
                weekDay = 'Mercredi';
                break;
              case 3:
                weekDay = 'Jeudi';
                break;
              case 4:
                weekDay = 'Vendredi';
                break;
              case 5:
                weekDay = 'Samedi';
                break;
              case 6:
                weekDay = 'Dimanche';
                break;
              default:
                throw Error();
            }
            String montant;
            montant = "${receivedData?[group.x].total ?? 0.0}";
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: montant,
                  style: TextStyle(
                    color: widget.touchedBarSumColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: getTitles,
            reservedSize: MediaQuery.of(context).size.width*0.1055,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Lun', style: style);
        break;
      case 1:
        text = const Text('Mar', style: style);
        break;
      case 2:
        text = const Text('Mer', style: style);
        break;
      case 3:
        text = const Text('Jeu', style: style);
        break;
      case 4:
        text = const Text('Ven', style: style);
        break;
      case 5:
        text = const Text('Sam', style: style);
        break;
      case 6:
        text = const Text('Dim', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
