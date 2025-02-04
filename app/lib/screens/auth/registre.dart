import 'package:flutter/material.dart';
import 'package:gestionary/screens/auth/widgets/filed_registre.dart';
import 'package:gestionary/screens/auth/widgets/message_top.dart';

class RegistreWidget extends StatefulWidget {
  const RegistreWidget({super.key});

  @override
  State<RegistreWidget> createState() => _RegistreWidgetState();
}

class _RegistreWidgetState extends State<RegistreWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 29, 31, 48),
          Color(0xFF292D4E),
        ], 
        begin: Alignment.topCenter, 
        end: Alignment.bottomCenter
        ),
      ),
        child: const SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   MessageTopWidget(),
                   FieldFormRegistre(),
            ],
          ),
        ),
      ),
    );
  }
}