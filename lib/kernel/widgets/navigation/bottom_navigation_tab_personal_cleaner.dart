import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationTabPersonalCleaner extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const BottomNavigationTabPersonalCleaner(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<BottomNavigationTabPersonalCleaner> createState() =>
      _BottomNavigationTabPersonalCleanerState();
}

class _BottomNavigationTabPersonalCleanerState
    extends State<BottomNavigationTabPersonalCleaner> {
  @override
  void initState() {
    super.initState();
    setColor();
  }

  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
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
            icon: Icon(Icons.room_service), label: 'Pendientes'),
        BottomNavigationBarItem(
            icon: Icon(Icons.table_bar), label: 'Habitaciones'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: color1,
      unselectedItemColor: color2,
      onTap: widget.onItemTapped,
    );
  }
}
