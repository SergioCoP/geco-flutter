import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/widgets/navigation/bottom_navigation_tab_personal_cleaner.dart';
import 'package:geco_mobile/modules/cleaning_staff/adapters/screens/rooms_all_user.dart';
import 'package:geco_mobile/modules/cleaning_staff/adapters/screens/rooms_owner_user.dart';
import 'package:geco_mobile/modules/gerente/user/adapters/screens/profile.dart';

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
        children: const [RoomsOwnerUser(),RoomsAllUser(),Profile()],
      ),
      bottomNavigationBar: BottomNavigationTabPersonalCleaner(selectedIndex: _selectedIndex,onItemTapped: _onItemTapped,),
    );
  }
}