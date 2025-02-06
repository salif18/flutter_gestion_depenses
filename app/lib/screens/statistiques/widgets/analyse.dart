import 'package:flutter/material.dart';
import 'package:gestionary/models/raportcurrentbudget.dart';
import 'package:gestionary/models/mostexpenses.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnalyseGeneral extends StatelessWidget {
  const AnalyseGeneral({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 275,
            width:  MediaQuery.of(context).size.width*0.45,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF292D4E),
            ),
            child: Consumer<StatisticsProvider>(
              builder: (context, provider, child) {
                return StreamBuilder<ModelRapportCurrentBudgets?>(
                  stream: provider.loadTheStatsBudgetStream(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(child: CircularProgressIndicator());
                    // } else 
                    if (snapshot.hasData && snapshot.data != null) {
                      ModelRapportCurrentBudgets? item = snapshot.data;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularPercentIndicator(
                              animation: true,
                              animationDuration: 270,
                              radius: 55,
                              lineWidth: 12,
                              percent: double.parse(item?.percent ?? '0') / 100,
                              progressColor:double.parse(item?.percent! ?? "0.0") >= 80 ? Colors.red : Colors.blueAccent,
                              backgroundColor:
                                  const Color.fromARGB(64, 64, 83, 255),
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                "${item?.percent ?? 0}%",
                                style: GoogleFonts.roboto(
                                  fontSize:  MediaQuery.of(context).size.width*0.06,
                                  color: double.parse(item?.percent! ?? "0.0") >= 80 ? Colors.red : Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: Text(
                              "De Consommation du budget",
                              style: GoogleFonts.roboto(
                                fontSize:  MediaQuery.of(context).size.width*0.04,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 221, 221, 221),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    "${item!.budgetAmount ?? 0}",
                                    style: GoogleFonts.roboto(
                                      fontSize:  MediaQuery.of(context).size.width*0.05,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                Expanded(child: Icon(Icons.monetization_on,color:Colors.blueAccent, size: MediaQuery.of(context).size.width*0.06))
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularPercentIndicator(
                              animation: true,
                              animationDuration: 270,
                              radius: 55,
                              lineWidth: 12,
                              percent: 0.0,
                              progressColor: Colors.blue,
                              backgroundColor:
                                  const Color.fromARGB(64, 64, 83, 255),
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                "0%",
                                style: GoogleFonts.roboto(
                                  fontSize:  MediaQuery.of(context).size.width*0.06,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: Text(
                              "De Consommation du budget",
                              style: GoogleFonts.roboto(
                                fontSize:  MediaQuery.of(context).size.width*0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    "0",
                                    style: GoogleFonts.roboto(
                                      fontSize:  MediaQuery.of(context).size.width*0.05,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(255, 255, 5, 5),
                                    ),
                                  ),
                                  Expanded(child: Icon(Icons.monetization_on,color:Colors.blueAccent, size: MediaQuery.of(context).size.width*0.06,))
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Container(
                height: 130.5,
                width:  MediaQuery.of(context).size.width*0.4,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 224, 41, 28),
                ),
                child: Consumer<StatisticsProvider>(
                  builder: (context, provider, child) {
                    return StreamBuilder<ModelTheMostExpense?>(
                      stream: provider.loadTheMostExpenseStream(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //       child: CircularProgressIndicator());
                        // } else 
                        if (snapshot.hasData && snapshot.data != null) {
                          ModelTheMostExpense? item = snapshot.data;
                          Map<String, dynamic>? category = item?.category;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 2),
                                child: Text(
                                  "Le plus investis",
                                  style: GoogleFonts.roboto(
                                    fontSize:  MediaQuery.of(context).size.width*0.04,
                                    color: const Color.fromARGB(
                                        255, 221, 221, 221),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 2),
                                    child: regeneredIcon(context,
                                        category?['name_categories']),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "${category?['name_categories'] ?? ""}",
                                      style: GoogleFonts.roboto(
                                        fontSize:  MediaQuery.of(context).size.width*0.04,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${item?.totalAmount ?? 0}",
                                        style: GoogleFonts.roboto(
                                          fontSize:  MediaQuery.of(context).size.width*0.04,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.monetization_on,color:Colors.grey[200], size: MediaQuery.of(context).size.width*0.06)
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            child: Center(child: Text("Pas de données enregistrés",style: GoogleFonts.roboto(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04),)),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 130.5,
                width:  MediaQuery.of(context).size.width*0.4,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF292D4E),
                ),
                child: Consumer<StatisticsProvider>(
                  builder: (context, provider, child) {
                    return StreamBuilder<ModelRapportCurrentBudgets?>(
                      stream: provider.loadTheStatsBudgetStream(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //       child: CircularProgressIndicator.adaptive());
                        // } else 
                        if (snapshot.hasData && snapshot.data != null) {
                          ModelRapportCurrentBudgets? item = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 2),
                                child: Icon(
                                  Icons.token,
                                  size:  MediaQuery.of(context).size.width*0.06,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 2),
                                child: Text(
                                  "Epargnes",
                                  style: GoogleFonts.roboto(
                                    fontSize:  MediaQuery.of(context).size.width*0.04,
                                    color: const Color.fromARGB(
                                        255, 221, 221, 221),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "${item?.epargnes ?? 0}",
                                      style: GoogleFonts.roboto(
                                        fontSize:  MediaQuery.of(context).size.width*0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Expanded(child: Icon(Icons.monetization_on, color:Colors.orange,size: MediaQuery.of(context).size.width*0.06))
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            child: Center(child: Text("Aucuns données", style: GoogleFonts.roboto(
                                        fontSize:  MediaQuery.of(context).size.width*0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )),),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// CREER DES ICONS EN FONCTION DU TYPE DE DEPENSES
Icon regeneredIcon(BuildContext context,expense) {
  switch (expense) {
    case "Electricité":
      return Icon(Icons.electrical_services_outlined,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Eau":
      return Icon(Icons.water_drop, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Logement":
      return Icon(Icons.home, color: Colors.white, size:MediaQuery.of(context).size.width*0.05);
    case "Communication":
      return Icon(Icons.phone_android_outlined,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Forfait":
      return Icon(Icons.phonelink_ring_rounded,
          color: Colors.white, size:MediaQuery.of(context).size.width*0.05);
    case "Abonnement TV":
      return Icon(Icons.tv, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Abonnement Wifi":
      return Icon(Icons.wifi, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Foods":
      return Icon(Icons.fastfood_sharp, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Transports":
      return Icon(Icons.tram_sharp, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Shoppings":
      return Icon(Icons.checkroom_sharp, color: Colors.white, size:MediaQuery.of(context).size.width*0.05);
    case "Loteries":
      return Icon(Icons.sports_esports_rounded,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Medical":
      return Icon(Icons.medical_services_rounded,
          color: Colors.white, size:MediaQuery.of(context).size.width*0.05);
    case "Divertissements":
      return Icon(Icons.multitrack_audio_sharp,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Garage":
      return Icon(Icons.build, color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Dettes":
      return Icon(Icons.soap_rounded, color: Colors.white, size:MediaQuery.of(context).size.width*0.05);
    case "Carburants":
      return Icon(Icons.oil_barrel_rounded,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Sports":
      return Icon(Icons.sports_gymnastics_outlined,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    case "Gims":
      return Icon(Icons.sports_kabaddi_rounded,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
    default:
      return Icon(Icons.account_balance_wallet,
          color: Colors.white, size: MediaQuery.of(context).size.width*0.05);
  }
}
