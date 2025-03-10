import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:gestionary/screens/statistiques/graphiques/statsexpensebarchart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: CarouselSlider.builder(
        itemCount: 1,
        itemBuilder: (context, index, realIndex) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color(0xFF292D4E),
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.0555)),
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: ListView(
                  physics:const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only( left: MediaQuery.of(context).size.width*0.065),
                      child: Text("Hebdomadaire",
                          style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width*0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.013, left: MediaQuery.of(context).size.width*0.065),
                        child: Consumer<StatisticsProvider>(
                            builder: (context, provider, child) {
                          return StreamBuilder<String?>(
                              stream: provider.loadTotalWeekStream(),
                              builder: (context, snapshot) {
                                String? sum = snapshot.data;
                                return Text("${sum ?? 0} Fcfa",
                                    style: GoogleFonts.roboto(
                                        fontSize: MediaQuery.of(context).size.width*0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500));
                              });
                        })),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.013,bottom: MediaQuery.of(context).size.width*0.0444),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width*0.333,
                        child: BarChartExpense(),
                      ),
                    ),
                  ]),
            ),
          );
        },
        options: CarouselOptions(
            height: MediaQuery.of(context).size.width*0.6111, viewportFraction: 0.9, 
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal
            ),
      ),
    );
  }
}