import 'package:flutter/material.dart';
import 'package:geco_mobile/config/navigation/manager_dashboard_stack.dart';
import 'package:geco_mobile/config/navigation/manager_stack.dart';
import 'package:geco_mobile/config/navigation/manager_user_stack.dart';
import 'package:geco_mobile/kernel/widgets/navigation/bottom_navigation_tab_gerente.dart';
import 'package:geco_mobile/modules/rubros/adapters/screens/rubros_management.dart';
import 'package:geco_mobile/modules/user/adapters/screens/profile.dart';

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  State<MenuManager> createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
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
        children: const [ManagerDashboardStack(),ManagerStack(),ManagerUserStack(),RubrosManagement(),Profile()],
      ),
      bottomNavigationBar: BottomNavigationTabGerente(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}