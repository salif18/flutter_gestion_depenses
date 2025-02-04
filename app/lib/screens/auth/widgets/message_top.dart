import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageTopWidget extends StatelessWidget {
  const MessageTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                padding: const EdgeInsets.only(top:50, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  
                      children: [
                        Text("Aw", 
                          style: GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.06,color:Colors.white)),
                          Text('Bissimilah !',
                          style: GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.06,color:Colors.white)
                          ),
                      ],
                    ),
                  ],
                ),
    );
  }
}