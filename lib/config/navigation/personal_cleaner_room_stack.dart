import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/cleaning_staff/adapters/screens/rooms_all_user.dart';

class PersonalCleanerRoomsStack extends StatelessWidget {
  const PersonalCleanerRoomsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/personal_cleaner/all_rooms',
      routes: {
        '/personal_cleaner/all_rooms': (context) => const RoomsAllUser(),
        //'personal_cleaner/all_rooms/mark_Room': (context) => const MarkRoom();
      },
    );
  }
}
