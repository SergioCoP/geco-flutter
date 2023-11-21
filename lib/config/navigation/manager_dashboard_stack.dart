import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/room/adapters/screens/room_dashboard.dart';
import 'package:geco_mobile/modules/room/adapters/screens/room_incidencesCheck.dart';

class ManagerDashboardStack extends StatelessWidget {
  const ManagerDashboardStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => RoomsDashboard(),
        '/dashboard/checkIncindences': (context) => RoomIncidencesCheck(),
        // 'manager/dashboard/checkRoom': (context) => const RoomIncidencesCheck(),
      },
    );
  }
}