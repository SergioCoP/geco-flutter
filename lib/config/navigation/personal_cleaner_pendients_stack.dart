import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/cleaning_staff/adapters/screens/rooms_owner_user.dart';

class PersonalCleanerPendientsStack extends StatelessWidget {
  const PersonalCleanerPendientsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/personal_cleaner/pendients',
      routes: {
        '/personal_cleaner/pendients': (context) => const RoomsOwnerUser(),
        //'personal_cleaner/pendients/mark_rooms': (context) => const MarkRoom();
      },
    );
  }
}