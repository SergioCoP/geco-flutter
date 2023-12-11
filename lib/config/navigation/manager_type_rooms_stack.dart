import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_management.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_register.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_update.dart';

class ManagerTypeRoomsStack extends StatelessWidget {
  const ManagerTypeRoomsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/manager/types',
        routes: {
          '/manager/types': (context) => const TypeRoomManagement(),
          '/manager/types/register': (context) => const TypeRoomRegister(),
          '/manger/types/update': (context) => const TypeRoomUpdate(),
        });
  }
}
