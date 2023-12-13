import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/widgets/room_card.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/widgets/room_register.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';

class RoomManagement extends StatefulWidget {
  const RoomManagement({super.key});

  @override
  State<RoomManagement> createState() => _RoomManagementState();
}

class _RoomManagementState extends State<RoomManagement> {
  final double heightOfFirstContainer = 100.0;
  final _path = GlobalData.pathRoomUri;
  late bool hasChange = false;

  late Future<List<Room>> _listaHabitaciones;
  late Future<List<Room>> _listaHabitacionesRespaldo;
  // ignore: unused_field
  Future<List<dynamic>>? _listaHabitacionesTienenIncidencias;

  @override
  void initState() {
    super.initState();
    // try {
    _listaHabitaciones = obtenerCuartosFetch();
    _listaHabitacionesRespaldo = _listaHabitaciones;
    // } catch (e) {
    //   _listaHabitaciones = fetchError();
    //   _listaHabitacionesRespaldo = _listaHabitaciones;
    //   throw Exception(e);
    // }
  }

  Future<List<Room>> fetchError() async {
    try {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Room>> obtenerCuartosFetch() async {
    List<Room> habitaciones = [];
    try {
      final dio = Dio();
      final response = await dio.get(_path);
      if (response.data['status'] == 'OK') {
        for (var habitacion in response.data['data']) {
          habitaciones.add(Room.fromJson(habitacion));
        }
      }
      return habitaciones;
    } catch (e) {
      return habitaciones;
    }
  }

  void filterCards(String query) {
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      _listaHabitaciones.then((data) {
        setState(() {
          List<Room> filteredData = data.where((card) {
            return card.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
          _listaHabitaciones = Future.value(filteredData);
        });
      });
    } else {
      setState(() {
        _listaHabitaciones = _listaHabitacionesRespaldo;
      });
    }
  }

  // ignore: prefer_final_fields
  // TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de habitaciones'),
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              print(Navigator.defaultRouteName);
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              width: 50,
              height: 60,
              margin: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _listaHabitaciones = obtenerCuartosFetch();
            _listaHabitacionesRespaldo = _listaHabitaciones;
          });
          return Future.value();
        },
        child: Stack(
          children: [
            Scaffold(
              body: Container(
                margin: const EdgeInsets.only(
                  top: 100,
                ),
                child: FutureBuilder<List<Room>>(
                  future: _listaHabitaciones,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Room> data = snapshot.data!;
                      if (data.isNotEmpty) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return RoomCard(room: data[index], path: _path);
                          },
                        );
                      } else {
                        return const IsEmptyRooms();
                      }
                    }
                  },
                ),
              ),
            ),
            Positioned(
              child: SizedBox(
                height: heightOfFirstContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          onChanged: (value) {
                            //filterCards(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Buscar por Identificador',
                            hintText: 'Buscar habitación',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.buttonPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          onPressed: () {
                            // Navigator.of(context)
                            //     .pushNamed('/manager/check_rooms/register');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RoomRegister()),
                            );
                          },
                          child: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IsEmptyRooms extends StatelessWidget {
  const IsEmptyRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('No hay ninguna Habitación registrada Actualmente. :)'));
  }
}
