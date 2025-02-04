import 'package:flutter/material.dart';
import 'package:gestionary/models/budget.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SingleBudget extends StatefulWidget {
  final ModelBudgets? itemPassToProps;
  const SingleBudget({super.key, required this.itemPassToProps});

  @override
  State<SingleBudget> createState() => _SingleBudgetState();
}

class _SingleBudgetState extends State<SingleBudget> {
  late ModelBudgets? _receivedData;

  @override
  void initState() {
    super.initState();
    _receivedData = widget.itemPassToProps;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    Color? containerBg = provider.containerBackg;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return Scaffold(
      backgroundColor: isDark? backgroundDark :Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: isDark ? backgroundDark :const Color(0xFF292D4E),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, size: 24, color:Colors.grey[100])),
        centerTitle: true,
        title: Row(
          children: [
            Text("Vos Transactions",
                style: GoogleFonts.roboto(
                    fontSize:  MediaQuery.of(context).size.width*0.05, 
                    fontWeight: FontWeight.w500,
                    color:Colors.grey[100]
                    )),
            const SizedBox(width: 10),
            Icon(Icons.sync_alt, size:  MediaQuery.of(context).size.width*0.05,color:Colors.grey[100])
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("Vos differentes transactions sur ce budget du mois",
              style:GoogleFonts.roboto(
                color:isDark ? textDark :null,
                fontSize: MediaQuery.of(context).size.width*0.04,fontWeight:FontWeight.w400))),
          ),
          if (_receivedData?.depense != null)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _receivedData!.depense.length,
                itemBuilder: (context, index) {
                  List<ExpensesOfBudget?> expenses = _receivedData!.depense;
                  ExpensesOfBudget? item = expenses[index];
                  return _detailExpenses(context, item, isDark ,containerBg);
                },
              ),
            ),
          if (_receivedData!.depense.isEmpty)
            Expanded(
              child: Center(
                child: Text("Aucunes dépenses effectuées",
                    style: GoogleFonts.roboto(
                        fontSize:  MediaQuery.of(context).size.width*0.04,
                        color: const Color.fromARGB(255, 109, 109, 109))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailExpenses(BuildContext context, item, isDark ,containerDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10,vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        height: 130,
        decoration: BoxDecoration(
            color: isDark ? containerDark :const Color(0xFF292D4E),
            borderRadius: BorderRadius.circular(10)),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item?.dateExpenses}",
                      style: GoogleFonts.roboto(
                          fontSize:  MediaQuery.of(context).size.width*0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[300])),
                  Text("${item?.description ?? "Aucunes notes "}",
                      style: GoogleFonts.aBeeZee(
                          fontSize:  MediaQuery.of(context).size.width*0.04,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 3, 224, 253))),
                ],
              ),
            ),
            Row(
              children: [
                Text("${item?.amount ?? 0}",
                    style: GoogleFonts.roboto(
                        fontSize:  MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber)),
                const SizedBox(width: 10),
                Icon(Icons.monetization_on_rounded,
                    color: Colors.amber, size:  MediaQuery.of(context).size.width*0.05)
              ],
            )
          ],
        ),
      ),
    );
  }
}
