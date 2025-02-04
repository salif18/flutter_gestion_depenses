import 'package:flutter/material.dart';

Icon regeneredIcon(BuildContext context, String expense) {
  double iconSize = MediaQuery.of(context).size.width * 0.05; // Calculer la taille une fois

   switch (expense) {
    case "Electricité":
      return Icon(Icons.electrical_services_outlined,
          color: Colors.amber, size: iconSize);
    case "L'eau":
      return Icon(Icons.water_drop, color: Colors.blue, size:iconSize);
    case "Logement":
      return Icon(Icons.home, color: Colors.green, size: iconSize);
    case "Abonnement TV":
      return Icon(Icons.tv,
          color: Color.fromARGB(255, 7, 6, 1), size: iconSize);
    case "Communication":
      return Icon(Icons.phone_android_outlined,
          color: Color.fromARGB(255, 46, 37, 34), size:iconSize);
    case "Abonnement Wifi":
      return Icon(Icons.wifi,
          color: Color.fromARGB(255, 59, 144, 255), size: iconSize);
           case "Foods":
      return Icon(Icons.fastfood_rounded, color: Colors.brown, size: iconSize);
    case "Echange bancaire":
      return Icon(Icons.sync, color: const Color.fromARGB(255, 183, 0, 255), size: iconSize);
    case "Forfait":
      return Icon(Icons.phonelink_ring_rounded,
          color: Color.fromARGB(255, 10, 44, 116), size: iconSize);
    case "Transports":
      return Icon(Icons.tram_sharp,
          color: Color.fromARGB(255, 206, 59, 59), size: iconSize);
    case "Shoppings":
      return Icon(Icons.checkroom_sharp,
          color: Color.fromARGB(255, 51, 177, 135), size: iconSize);
    case "Medical":
      return Icon(Icons.medical_services_outlined,
          color: Color.fromARGB(255, 238, 11, 11), size: iconSize);
    case "Loteries":
      return Icon(Icons.sports_esports_rounded,
          color: Color.fromARGB(255, 206, 0, 96), size: iconSize);
    case "Divertissements":
      return Icon(Icons.multitrack_audio_sharp,
          color: Color.fromARGB(255, 43, 13, 150), size: iconSize);
    case "Garage":
      return Icon(Icons.build, color: Colors.blueAccent, size: iconSize);
    case "Dettes":
      return Icon(Icons.soap_rounded,
          color: Color.fromARGB(255, 255, 137, 68), size: iconSize);
    case "Sports":
      return Icon(Icons.sports_gymnastics_outlined,
          color: Color.fromARGB(255, 68, 218, 255), size: iconSize);
       case "Gims":
      return Icon(Icons.sports_kabaddi_rounded,
          color: Color.fromARGB(255, 255, 94, 0), size:iconSize);
    case "Carburants":
      return Icon(Icons.oil_barrel_rounded, color: Colors.red, size: iconSize);
    default:
      return Icon(Icons.account_balance_wallet,
          color: Colors.grey, size: iconSize);
  }
}
