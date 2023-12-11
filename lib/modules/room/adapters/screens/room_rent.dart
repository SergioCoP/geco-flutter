// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:geco_mobile/kernel/global/global_data.dart';
// import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_card.dart';
// import 'package:geco_mobile/modules/room/entities/room.dart';

// import '../../../../kernel/theme/color_app.dart';

// class RoomRent extends StatefulWidget {
//   const RoomRent({super.key});

//   @override
//   State<RoomRent> createState() => _RoomRentState();
// }

// class _RoomRentState extends State<RoomRent> {
//   final double heightOfFirstContainer = 200.0;
//   static const String _path = GlobalData.pathRoomUri;
//   Future<List<Room>>? _listaHabitaciones;
//   Future<List<Room>>? _listaHabitacionesRespaldo;

//   @override
//   void initState() {
//     super.initState();
//     _listaHabitaciones = obtenerCuartosFetch();
//     _listaHabitacionesRespaldo = _listaHabitaciones;
//   }

//   Future<List<Room>> obtenerCuartosFetch() async {
//     try {
//       List<Room> habitaciones = [];
//       final dio = Dio();
//       final response = await dio.get('$_path/getAllRooms');
//       if (response.statusCode == 200) {
//         for (var habitacion in response.data) {
//           habitaciones.add(Room(habitacion['idRoom'], habitacion['identifier'],
//               habitacion['status']));
//         }
//       }
//       return habitaciones;
//     } catch (e) {
//       throw Exception('Falló el intentar traer las habitaciones. $e');
//     }
//   }

//   List<Widget> crearCards(List<dynamic> data) {
//     List<RoomCard> roomsCards = [];
//     for (var room in data) {
//       roomsCards.add(RoomCard(
//         room: room,
//         path: _path,
//       ));
//     }
//     return roomsCards;
//   }

//   void filtrarHabitacion(String query) {
//     query = query.toLowerCase();
//     List<Room> habitacionesFiltradas = [];
//     if (query.isEmpty) {
//       _listaHabitaciones = _listaHabitacionesRespaldo;
//     }
//     if (_listaHabitaciones != null) {
//       _listaHabitaciones!.then((habitaciones) {
//         habitacionesFiltradas = habitaciones.where((habitacion) {
//           return habitacion.identifier.toLowerCase().contains(query);
//         }).toList();
//         setState(() {
//           _listaHabitaciones = Future.value(habitacionesFiltradas);
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorsApp.primaryColor,
//       ),
//       body: Stack(
//         children: [
//           Scaffold(
//             body: Container(
//               margin: const EdgeInsets.only(
//                 top: 160,
//               ),
//               child: FutureBuilder(
//                 future: _listaHabitaciones,
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   if (snapshot.hasData) {
//                     return GridView.count(
//                       mainAxisSpacing: 2,
//                       crossAxisCount: 2,
//                       children: crearCards(snapshot.data),
//                     );
//                   } else if (!snapshot.hasData) {
//                     return const IsEmptyRooms();
//                   } else if (snapshot.hasError) {
//                     return const Text("Ha sucedido un error maquiavélico.");
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ),
//           ),

//           //Aqui va para registrar un usuario, buscar usuarios
//           Positioned(
//             child: SizedBox(
//               height: heightOfFirstContainer,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(right: 12),
//                         padding: const EdgeInsets.all(8),
//                         child: const Text(
//                           "Habitaciones",
//                           style: TextStyle(fontSize: 30.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       onChanged: (text) {
//                         filtrarHabitacion(text.toString());
//                       },
//                       decoration: const InputDecoration(
//                         suffixIcon: Icon(Icons.search),
//                         labelText: 'Buscar habitación',
//                         hintText: 'Escribe aquí para buscar una habitación',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class IsEmptyRooms extends StatelessWidget {
//   const IsEmptyRooms({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//         child:
//             Text('No hay ningun Cuarto/Habitación registrado Actualmente :)'));
//   }
// }

// void cambiarEstado(context, Room room, String path) {
//   showDialog(
//     context: context,
//     builder: (
//       BuildContext context,
//     ) {
//       bool flagEstado = room.status == 1 ? true : false;
//       if (flagEstado) {
//         return AlertDialog(
//           title: const Text('Estado de la habitación'),
//           content: const Text(
//               '¿Estas segura(o) de cambiar el estado de la habitacion de "En venta" a "En uso" ?'),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 final dio = Dio();
//                 final response = await dio.put('$path/updateRoom', data: {
//                   'idRoom': room.idRoom,
//                   'identifier': room.identifier,
//                   'status': 2
//                 });
//                 if (response.statusCode == 200) {
//                   reloadScreen();
//                 }
//               },
//               child: const Text('Cambiar estado'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Cerrar el diálogo
//               },
//               child: const Text('Cancelar'),
//             ),
//           ],
//         );
//       } else {
//         return AlertDialog(
//           title: const Text('Estado de la habitación'),
//           content: const Text(
//               'No puedes rentar una habitacion que no esté en venta.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Cerrar el diálogo
//               },
//               child: const Text('Cerrar'),
//             ),
//           ],
//         );
//       }
//     },
//   );
// }

// void reloadScreen() {}
