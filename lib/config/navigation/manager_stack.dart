import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/room/adapters/screens/edit_room.dart';
import 'package:geco_mobile/modules/room/adapters/screens/room_management.dart';
import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_register.dart';

class ManagerStack extends StatelessWidget {
  const ManagerStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/manager/check_rooms',
      routes: {
        '/manager/check_rooms': (context) => const RoomManagement(),
        '/manager/check_rooms/register': (context) => const RoomRegister(),
        '/manager/check_rooms/edit_room': (context) => const EditRoom(),
        // '/manager/room' : (context) => const RoomIncidences(idRoom, identifier, status, hasIncidences)
      },
    );
  }
}