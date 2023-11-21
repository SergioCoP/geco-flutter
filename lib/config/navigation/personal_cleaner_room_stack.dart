import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/room/personal_cleaner/adpters/screens/all_rooms_table.dart';

class PersonalCleanerRoomsStack extends StatelessWidget {
  const PersonalCleanerRoomsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/personal_cleaner/all_rooms',
      routes: {
        '/personal_cleaner/all_rooms': (context) => const AllRoomsTable(),
      },
    );
  }
}