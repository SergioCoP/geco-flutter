import 'package:flutter/material.dart';
import 'package:geco_mobile/config/navigation/personal_cleaner_pendients_stack.dart';
import 'package:geco_mobile/config/navigation/personal_cleaner_room_stack.dart';
import 'package:geco_mobile/kernel/widgets/navigation/bottom_navigation_tab_personal_cleaner.dart';
import 'package:geco_mobile/modules/user/adapters/screens/profile.dart';

class MenuPersonalCleaner extends StatefulWidget {
  const MenuPersonalCleaner({super.key});

  @override
  State<MenuPersonalCleaner> createState() => _MenuPersonalCleanerState();
}

class _MenuPersonalCleanerState extends State<MenuPersonalCleaner> {
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
        children: const [PersonalCleanerPendientsStack(),PersonalCleanerRoomsStack(),Profile()],
      ),
      bottomNavigationBar: BottomNavigationTabPersonalCleaner(selectedIndex: _selectedIndex,onItemTapped: _onItemTapped,),
    );
  }
}