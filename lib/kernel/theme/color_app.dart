import 'package:flutter/material.dart';

class ColorsApp {
  Color primaryColor = const Color(0xFF326A6D);
  Color secondaryColor = const Color(0xFF18CB70);
  static const thirColor = Color(0xFF6FFD73);
  static const infoColor = Color(0xFF6085BB);
  static const buttonCancelColor = Color(0xFFA33F3F);
  static const buttonPrimaryColor = Color(0xFF589F56);

  static const estadoEnVenta = Color(0xFFC3EDC2);
  static const estadoEnUso = Color(0xFFD9D9D9);
  static const estadoSinRevisar = Color(0xFFCDDEF6);
  static const estadoConIncidencias = Color.fromARGB(255, 247, 199, 28);
  static const estadoSucio = Color.fromARGB(255, 233, 208, 238);

  void setPrimaryColor(Color color) {
    primaryColor = color;
  }

  void setSecondaryColor(Color color) {
    secondaryColor = color;
  }
}
