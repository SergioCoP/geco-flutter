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
  final double heightOfFirstContainer = 220.0;
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
      if (hasFetch) {
        totalCuartos = totalEnVenta = totalEnUso = totalSucio =
            totalEnRevision = totalIncidencias = totalDeshabilitadas = 0;
        listaHabitaciones = [];
      }
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
    final deviceWidth = MediaQuery.of(context).size.width - 40.5;
    // var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    // final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de control"),
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              print('Boton de deslogueo asies jaja');
              // Navigator.pushNamed(context, '/login');
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
      body: hasFetch
          ? listaHabitaciones.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: fetchRooms,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Scaffold(
                          body: Container(
                            margin: const EdgeInsets.only(
                              top: 235,
                            ),
                            child: ListView.builder(
                              itemCount: listaHabitaciones.length,
                              itemBuilder: (context, index) {
                                return RoomCardDashboard(
                                    roomIncidences: listaHabitaciones[index]);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            child: Card(
                          elevation: 5.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                                color: Colors.black, width: 0.1),
                          ),
                          child: SizedBox(
                            height: heightOfFirstContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  //CUADRO DONDE ESTA EL TOTAL DE CUARTOS
                                  Container(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: deviceWidth / 2,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Total de habitaciones',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '$totalCuartos',
                                                style: TextStyle(
                                                    fontSize: 35.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  //AQUI ESTARAN LOS CONTAINER DE EN VENTA Y EN USO
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Ajusta el valor según sea necesario
                                      border: Border.all(
                                          color: Colors.black, width: 0.1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                          ),
                                          child: SizedBox(
                                            width: deviceWidth / 2,
                                            child: Container(
                                              color: ColorsApp.estadoEnUso,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'En uso',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '$totalEnUso',
                                                    style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0.0),
                                            bottomLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          child: SizedBox(
                                            width: deviceWidth / 2,
                                            child: Container(
                                              color: ColorsApp.estadoEnVenta,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'En renta',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '$totalEnVenta',
                                                    style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  //AQUI ESTARAN LOS CONTAINER DE EN REVISION Y CON INCIDENCIAS
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Ajusta el valor según sea necesario
                                      border: Border.all(
                                          color: Colors.black, width: 0.1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                          ),
                                          child: SizedBox(
                                            width: deviceWidth / 3,
                                            child: Container(
                                              color: ColorsApp.estadoSucio,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Sucias',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '$totalSucio',
                                                    style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: deviceWidth / 3,
                                          decoration: BoxDecoration(
                                            color: ColorsApp.estadoSinRevisar,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'En revisión',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '$totalEnRevision',
                                                style: TextStyle(
                                                    fontSize: 30.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0.0),
                                            bottomLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          child: SizedBox(
                                            width: deviceWidth / 3,
                                            child: Container(
                                              color: ColorsApp
                                                  .estadoConIncidencias,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Con detalles',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '$totalIncidencias',
                                                    style: TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                      'No se encontraron habitaciones registradas en este hotel. :)'),
                )
          : RefreshIndicator(
              onRefresh: fetchRooms,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
