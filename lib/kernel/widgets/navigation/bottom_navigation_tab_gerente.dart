import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationTabGerente extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigationTabGerente(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<BottomNavigationTabGerente> createState() =>
      _BottomNavigationTabGerenteState();
}

class _BottomNavigationTabGerenteState
    extends State<BottomNavigationTabGerente> {
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  @override
  void initState() {
    super.initState();
    setColor();
  }

  void setColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? color11 = prefs.getString('primaryColor');
    String? color22 = prefs.getString('secondaryColor');
    setState(() {
      color1 = Color(int.parse(color11!));
      color2 = Color(int.parse(color22!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_rounded), label: 'Habitaciones'),
        BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences_outlined),
            label: 'Tipos de habitación'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_search_rounded), label: 'Usuarios'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded), label: 'Rubros'),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: color1,
      unselectedItemColor: color2,
      onTap: widget.onItemTapped,
    );
  }
}
