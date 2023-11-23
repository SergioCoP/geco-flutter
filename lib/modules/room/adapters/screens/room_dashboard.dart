// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_card_dashboard.dart';
import 'package:geco_mobile/modules/room/entities/rooms_incidences.dart';

class RoomsDashboard extends StatefulWidget {
  const RoomsDashboard({super.key});

  @override
  State<RoomsDashboard> createState() => _RoomsDashboardState();
}

class _RoomsDashboardState extends State<RoomsDashboard> {
  late List<RoomIncidences> listaHabitaciones;
  final double heightOfFirstContainer = 190.0;
  late bool hasFetch = false;
  late int totalCuartos = 0;
  late int totalEnVenta = 0;
  late int totalEnUso = 0;
  late int totalSucio = 0;
  late int totalEnRevision = 0;
  late int totalIncidencias = 0;
  late int totalDeshabilitadas = 0;
  final RoomIncidences roomIncidences = RoomIncidences(1, 'HAB01', 2);

  @override
  void initState() {
    super.initState();
    listaHabitaciones = [];
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      final dio = Dio();
      const path = GlobalData.pathRoomUri;
      final response = await dio.get('$path/getAllRooms');
      if (response.data['msg'] == 'OK') {
        final roomsData = response.data['data'];
        setState(
          () {
            for (var room in roomsData) {
              totalCuartos += 1;
              listaHabitaciones.add(RoomIncidences(
                  room['idRoom'], room['identifier'], room['status']));
              switch (room['status']) {
                case 1: // esta en venta
                  totalEnVenta += 1;
                  break;
                case 2: // esta en uso
                  totalEnUso += 1;
                  break;
                case 3: // estan sucias
                  totalSucio += 1;
                  break;
                case 4: // esta en revision pendiente
                  totalEnRevision += 1;
                  break;
                case 5: // tienen incidencias
                  totalIncidencias += 1;
                  break;
                case 0: // Estan deshabilitadas
                  totalDeshabilitadas += 1;
                  break;
                default:
                  break;
              }
            }
            hasFetch = true;
          },
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        hasFetch = true;
        listaHabitaciones = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width - 16.0;
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Panel de control",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: hasFetch
          ? listaHabitaciones.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Scaffold(
                        body: Container(
                          margin: const EdgeInsets.only(
                            top: 190,
                          ),
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                            children: listaHabitaciones.map((room) {
                              return RoomCardDashboard(
                                  roomIncidences: roomIncidences);
                            }).toList(),
                          ),
                        ),
                      ),
                      Positioned(
                          child: SizedBox(
                        height: heightOfFirstContainer,
                        child: Column(
                          children: [
                            //CUADRO DONDE ESTA EL TOTAL DE CUARTOS
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Total de Cuartos',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$totalCuartos',
                                    style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            //AQUI ESTARAN LOS CONTAINER DE EN VENTA Y EN USO
                            Row(
                              children: [
                                Container(
                                    width: deviceWidth / 2,
                                    decoration: BoxDecoration(
                                      color: ColorsApp.estadoEnVenta,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'En venta',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$totalEnVenta',
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width: deviceWidth / 2,
                                  decoration: BoxDecoration(
                                    color: ColorsApp.estadoEnUso,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'En uso',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '$totalEnUso',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //AQUI ESTARAN LOS CONTAINER DE EN REVISION Y CON INCIDENCIAS
                            Row(
                              children: [
                                Container(
                                  width: deviceWidth / 2,
                                  decoration: BoxDecoration(
                                    color: ColorsApp.estadoSinRevisar,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'En revisión',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '$totalEnRevision',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: deviceWidth / 2,
                                  decoration: BoxDecoration(
                                    color: ColorsApp.estadoConIncidencias,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Con incidencias',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '$totalIncidencias',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                )
              : Center(
                  child: Text(
                      'No se encontraro habitaciones registradas en este hotel. :)'),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
