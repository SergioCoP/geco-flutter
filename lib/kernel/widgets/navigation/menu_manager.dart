import 'package:flutter/material.dart';
import 'package:geco_mobile/config/navigation/manager_dashboard_stack.dart';
import 'package:geco_mobile/config/navigation/manager_rubros_stack.dart';
import 'package:geco_mobile/config/navigation/manager_stack.dart';
import 'package:geco_mobile/config/navigation/manager_type_rooms_stack.dart';
import 'package:geco_mobile/config/navigation/manager_user_stack.dart';
import 'package:geco_mobile/kernel/widgets/navigation/bottom_navigation_tab_gerente.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_dashboard.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_management.dart';
import 'package:geco_mobile/modules/gerente/rubros/adapters/screens/rubros_management.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_management.dart';
import 'package:geco_mobile/modules/gerente/user/adapters/screens/user_management.dart';

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  State<MenuManager> createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          RoomsDashboard(),
          RoomManagement(),
          TypeRoomManagement(),
          UserManagement(),
          RubrosManagement()
          // ManagerDashboardStack(),
          // ManagerStack(),
          // ManagerTypeRoomsStack(),
          // ManagerUserStack(),
          // ManagerRubrosStack(),
        ],
      ),
      bottomNavigationBar: BottomNavigationTabGerente(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
