import 'package:flutter/material.dart';
import 'package:gestionary/models/user.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:gestionary/screens/budgets/budgets.dart';
import 'package:gestionary/screens/home/widget/carousel.dart';
import 'package:gestionary/screens/home/widget/monthdepense.dart';
import 'package:gestionary/screens/home/widget/todaydepense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//rafraichire la page en actualisanst la requete
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsWeek(context);
      });
    });
  }

  Future<void> myFetchdata() async {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatisticsWeek(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    myFetchdata();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    Color? backgroundDark = provider.colorBackground;
    bool isDark = provider.isDark;
    Color? textDark = provider.colorText;
    return  Scaffold(
        backgroundColor: isDark? backgroundDark:Colors.white,
        body: RefreshIndicator(
      backgroundColor: const Color.fromARGB(255, 34, 12, 49),
      color: Colors.grey[100],
      onRefresh: _refresh,
      displacement: 50,
      child:CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.0222),
                    child: Container(
                      padding:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.0555,right: MediaQuery.of(context).size.width*0.0555,top: MediaQuery.of(context).size.width*0.1399),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Salut !",
                                  style: GoogleFonts.roboto(
                                    color:isDark ? textDark : null,
                                    fontSize: MediaQuery.of(context).size.width*0.06)),
                              Consumer<UserInfosProvider>(
                                  builder: (context, provider, child) {
                                return FutureBuilder<ModelUser?>(
                                    future:
                                        provider.loadProfilFromLocalStorage(),
                                    builder: (context, snapshot) {
                                      final profil = snapshot.data;
                                      return Text("${profil?.name},",
                                          style: GoogleFonts.roboto(
                                              fontSize: MediaQuery.of(context).size.width*0.05,
                                              fontWeight: FontWeight.w900,
                                              color: isDark ? textDark : const Color.fromARGB(
                                                  255, 34, 12, 49)));
                                    });
                              })
                            ],
                          ),
                            
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Budgets()));
                                  },
                                  icon:Container(
                                    width: MediaQuery.of(context).size.width*0.12,height: MediaQuery.of(context).size.width*0.12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF292D4E),
                                      borderRadius: BorderRadius.circular(5)),
                                    child: Icon(LineIcons.balanceScale,
                                     color:isDark ? textDark : const Color.fromARGB(255, 231, 150, 0),
                                        size: MediaQuery.of(context).size.width*0.08),
                                  )),
                              // Text("budgets",
                              //     style: GoogleFonts.aBeeZee(
                              //        color:isDark ? textDark : null,
                              //         fontSize: MediaQuery.of(context).size.width*0.04,
                              //         fontWeight: FontWeight.w600))
                            ],
                          ),
                            
                          // const SizedBox(width: 5)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width*0.0555),
                  const MyCarousel(),
                ],
              ),
            ),
            SliverFillRemaining(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.12,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.0555),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(MediaQuery.of(context).size.width*0.0694),
                            topRight: Radius.circular(MediaQuery.of(context).size.width*0.0694)),
                        color:isDark ? backgroundDark : const Color(0xfff0f1f5),                          
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.0555, right: MediaQuery.of(context).size.width*0.0555),
                        child: Material(
                          color: const Color(0xFFD5CEDD),       
                          shape: RoundedRectangleBorder(                      
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(MediaQuery.of(context).size.width*0.006),
                                  right: Radius.circular(MediaQuery.of(context).size.width*0.006))),
                          child: TabBar(                            
                            indicator: BoxDecoration(
                                color: const Color(0xFF292D4E),
                                borderRadius: BorderRadius.circular(0)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor:
                                const Color.fromARGB(255, 253, 253, 253),
                            unselectedLabelColor:
                                const Color.fromARGB(255, 48, 33, 58),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Aujourd'hui",
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.w600,
                                      fontSize: MediaQuery.of(context).size.width*0.04),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Mois",
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.w600,
                                      fontSize: MediaQuery.of(context).size.width*0.04),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          MyDepenseDay(),
                          MyMonthDepense(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
