import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/room/adapters/screens/room_rent.dart';

class MenuRecepcionist extends StatefulWidget {
  const MenuRecepcionist({super.key});

  @override
  State<MenuRecepcionist> createState() => _MenuRecepcionistState();
}

class _MenuRecepcionistState extends State<MenuRecepcionist> {
  int _selectedIndex = 0;
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        // children: const [RoomRent(),],
      ),
      // bottomNavigationBar: BottomNavigationTabRecpcionist(selectedIndex: _selectedIndex,onItemTapped: _onItemTapped,),
    );
  }
}