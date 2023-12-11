import 'package:flutter/material.dart';

class AllRoomsTable extends StatelessWidget {
  const AllRoomsTable({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: const Text('Todas las habitaciones')),
      body: const Center(
        child: Text('Aqui estarán todas las habitaciones disponibles'),
      ),
    );
  }
}