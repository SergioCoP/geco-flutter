import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class BottomNavigationTabPersonalCleaner extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigationTabPersonalCleaner({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.room_service), label: 'Pendientes'),
        BottomNavigationBarItem(icon: Icon(Icons.table_bar), label: 'Habitaciones'),
      ],
       currentIndex: selectedIndex,
      selectedItemColor: ColorsApp().secondaryColor,
      unselectedItemColor: ColorsApp().primaryColor,
      onTap: onItemTapped,
    );
  }
}