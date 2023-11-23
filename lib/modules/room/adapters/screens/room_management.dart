import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/adapters/screens/edit_room.dart';
import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_card_management.dart';
import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_register.dart';
import 'package:geco_mobile/modules/room/entities/room.dart';

class RoomManagement extends StatefulWidget {
  const RoomManagement({super.key});

  @override
  State<RoomManagement> createState() => _RoomManagementState();
}

class _RoomManagementState extends State<RoomManagement> {
  final double heightOfFirstContainer = 100.0;
  final _path = GlobalData.pathRoomUri;
  late bool hasChange = false;

  Future<List<Room>>? _listaHabitaciones;
  Future<List<Room>>? _listaHabitacionesRespaldo;
  // ignore: unused_field
  Future<List<dynamic>>? _listaHabitacionesTienenIncidencias;

  @override
  void initState() {
    super.initState();
    try {
      _listaHabitaciones = obtenerCuartosFetch();
      _listaHabitacionesRespaldo = _listaHabitaciones;
    } catch (e) {
      _listaHabitaciones = [] as Future<List<Room>>?;
      _listaHabitacionesRespaldo = _listaHabitaciones;
    }
  }

  Future<List<Room>> obtenerCuartosFetch() async {
    List<Room> habitaciones = [];
    try {
      final dio = Dio();
      final response = await dio.get('$_path/getAllRooms');
      if (response.data['msg'] == 'OK') {
        for (var habitacion in response.data['data']) {
          habitaciones.add(Room(habitacion['idRoom'], habitacion['identifier'],
              habitacion['status']));
        }
      }
      return habitaciones;
    } catch (e) {
      print(e);
      return habitaciones;
    }
  }

  List<Widget> crearCards(List<dynamic> data) {
    List<RoomCardManagement> roomsCards = [];
    if (data.isNotEmpty) {
      for (var room in data) {
        roomsCards.add(RoomCardManagement(
          room: room,
          path: _path,
        ));
      }
    }
    return roomsCards;
  }

  void filtrarHabitacion(String query) {
    query = query.toLowerCase();
    try {
      List<Room> habitacionesFiltradas = [];
      if (query.isEmpty) {
        _listaHabitaciones = _listaHabitacionesRespaldo;
      }
      if (_listaHabitaciones != null) {
        _listaHabitaciones!.then((habitaciones) {
          habitacionesFiltradas = habitaciones.where((habitacion) {
            return habitacion.identifier.toLowerCase().contains(query);
          }).toList();
          setState(() {
            _listaHabitaciones = Future.value(habitacionesFiltradas);
          });
        });
      }
    } catch (e) {
      throw (Exception(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (hasChange) {
      hasChange = false;
      // obtenerCuartosFetch();
      _listaHabitaciones = obtenerCuartosFetch();
      _listaHabitacionesRespaldo = _listaHabitaciones;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de habitaciones'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Stack(
        children: [
          Scaffold(
            body: Container(
              margin: const EdgeInsets.only(
                top: 100,
              ),
              child: FutureBuilder(
                future: _listaHabitaciones,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Room> sapoRoom = snapshot.data;
                    if (sapoRoom.isNotEmpty) {
                      return GridView.count(
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        children: crearCards(snapshot.data),
                      );
                    } else {
                      return const IsEmptyRooms();
                    }
                  } else if (!snapshot.hasData) {
                    return const IsEmptyRooms();
                  } else if (snapshot.hasError) {
                    return const Text("Ha sucedido un error maquiavélico.");
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),

          //Aqui va para registrar un usuario, buscar usuarios
          Positioned(
            child: SizedBox(
              height: heightOfFirstContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (text) {
                              filtrarHabitacion(text.toString());
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              labelText: 'Buscar habitación',
                              hintText:
                                  'Escribe aquí para buscar una habitación',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsApp.buttonPrimaryColor,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/manager/check_rooms/register',
                                arguments: {'path': _path});
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IsEmptyRooms extends StatelessWidget {
  const IsEmptyRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child:
            Text('No hay ningun Cuarto/Habitación registrado Actualmente :)'));
  }
}
