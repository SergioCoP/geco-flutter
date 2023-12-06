import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class BottomNavigationTabGerente extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigationTabGerente(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_rounded), label: 'Habitaciones'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_search_rounded), label: 'Usuarios'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded), label: 'Rubros'),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: ColorsApp.secondaryColor,
      unselectedItemColor: ColorsApp.primaryColor,
      onTap: onItemTapped,
    );
  }
}
