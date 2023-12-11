import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/gerente/room/personal_cleaner/adpters/screens/pendient_rooms.dart';

class PersonalCleanerPendientsStack extends StatelessWidget {
  const PersonalCleanerPendientsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/personal_cleaner/pendients',
      routes: {
        '/personal_cleaner/pendients': (context) => const PendientRooms(),
      },
    );
  }
}