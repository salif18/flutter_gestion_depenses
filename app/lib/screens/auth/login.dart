import 'package:flutter/material.dart';
import 'package:gestionary/screens/auth/widgets/field_login.dart';
import 'package:gestionary/screens/auth/widgets/message_top.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _LoginState();
}

class _LoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   MessageTopWidget(),
                   MyFieldForms()
            ],
          ),
        ),
      ),
    );
  }
}
