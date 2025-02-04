import 'package:flutter/material.dart';
import 'package:gestionary/models/month_stats.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Mensuels extends StatefulWidget {
  const Mensuels({super.key});

  @override
  State<Mensuels> createState() => _MensuelsState();
}

class _MensuelsState extends State<Mensuels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<List<ModelMonthStats>?>(
              stream: provider.loadDataMonthStream(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(child: CircularProgressIndicator());
                // } else 
                if (snapshot.hasData) {
                  List<ModelMonthStats>? data = snapshot.data;
                  if (data!.isEmpty) {
                    return _aucunsDonnees(context);
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          ModelMonthStats? item = data[index];
                          return _cardMonthStats(context, item);
                        });
                  }
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }

  Widget _aucunsDonnees(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
      child: Center(
          child: Text("Aucuns données enregistrés ",
              style: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04))),
    );
  }

  Widget _cardMonthStats(BuildContext context, item) {
    return Container(
      height:  100,
      width:  MediaQuery.of(context).size.width*0.5,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        elevation: 4,
        color: const Color(0xFF292D4E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: formatDate(item.month ?? ''),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.arrow_right,
                      size:  MediaQuery.of(context).size.width*0.06, color: Color.fromARGB(255, 221, 221, 221)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${item.total ?? 0} ",
                      style: GoogleFonts.roboto(
                          fontSize:  MediaQuery.of(context).size.width*0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                 Expanded(
                  child: Icon(Icons.monetization_on, 
                  color: Colors.greenAccent,
                  size:MediaQuery.of(context).size.width*0.06))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formatDate(String month) {
  
    switch (int.parse(month)) {
      case 01:
        return Text("Janvier",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 02:
        return Text("Fevrier",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 03:
        return Text("Mars",
            style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 04:
        return Text("Avril",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 05:
        return Text("Mai",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 06:
        return Text("Juin",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 07:
        return Text("Juillet",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 08:
        return Text("Aout",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 09:
        return Text("Septembre",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 10:
        return Text("Octobre",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 11:
        return Text("Novembre",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      case 12:
        return Text("Decembre",
            style: GoogleFonts.roboto(
                fontSize:  MediaQuery.of(context).size.width*0.04,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 221, 221, 221)));
      default:
        return Text("Non definit", style: GoogleFonts.roboto(fontSize:  MediaQuery.of(context).size.width*0.04,));
    }
  }
}
