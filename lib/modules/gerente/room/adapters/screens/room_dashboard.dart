// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/widgets/room_card_dashboard.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomsDashboard extends StatefulWidget {
  const RoomsDashboard({super.key});

  @override
  State<RoomsDashboard> createState() => _RoomsDashboardState();
}

class _RoomsDashboardState extends State<RoomsDashboard> {
  late List<Room> listaHabitaciones;

  late bool hasFetch = false;
  late int totalCuartos = 0;
  late int totalEnVenta = 0;
  late int totalEnUso = 0;
  late int totalSucio = 0;
  late int totalEnRevision = 0;
  late int totalIncidencias = 0;
  late int totalDeshabilitadas = 0;

  @override
  void initState() {
    super.initState();
    listaHabitaciones = [];
    fetchRooms();
    setColor();
  }

  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;

  void setColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? color11 = prefs.getString('primaryColor');
    String? color22 = prefs.getString('secondaryColor');
    setState(() {
      color1 = Color(int.parse(color11!));
      color2 = Color(int.parse(color22!));
    });
  }

  Future<void> fetchRooms() async {
    try {
      if (hasFetch) {
        totalCuartos = totalEnVenta = totalEnUso = totalSucio =
            totalEnRevision = totalIncidencias = totalDeshabilitadas = 0;
        listaHabitaciones = [];
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idHotel = prefs.getInt('idHotel');
      final dio = Dio();
      const path = GlobalData.pathRoomUri;
      final response = await dio.get(path,
          options: Options(headers: {
            // "Accept": "application/json",
            // "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        if (response.data['data'] != null) {
          final roomsData = response.data['data'];
          setState(
            () {
              for (var room in roomsData) {
                if (room['idHotel']['idHotel'] == idHotel) {
                  totalCuartos += 1;
                  List<User> users = [];
                  if (room['firstIdUser'] != null) {
                    users.add(User.fromJson(room['firstIdUser']));
                  }
                  if (room['secondIdUser'] != null) {
                    users.add(User.fromJson(room['secondIdUser']));
                  }
                  listaHabitaciones.add(Room.fromJson(room, users));
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
              }
              hasFetch = true;
            },
          );
        } else {
          setState(() {
            hasFetch = true;
            listaHabitaciones = [];
          });
        }
      }
    } on DioException catch (e) {
      print('ERROR DIO EN DASHBOARD: $e');
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer las habitaciones. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (e.response!.statusCode == 403) {
        print('Entró en un error 403');
        listaHabitaciones = [];
        fetchRooms();
        setColor();
      }
      setState(() {
        hasFetch = true;
        listaHabitaciones = [];
      });
    } catch (e, f) {
      print('ESTE ES UN ERROR DESDE DASHBOARD $e   ,    $f');
      hasFetch = true;
      listaHabitaciones = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width - 56.2;
    double heightOfFirstContainer = 250.0;
    TextStyle labelText =
        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
    TextStyle labelNumber =
        TextStyle(fontSize: 30.0, fontWeight: FontWeight.normal);
    // var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    // final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de control"),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            child: Container(
              width: 50,
              height: 60,
              margin: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, color: color2),
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
                              top: 270,
                            ),
                            child: ListView.builder(
                              itemCount: listaHabitaciones.length,
                              itemBuilder: (context, index) {
                                return RoomCardDashboard(
                                    room: listaHabitaciones[index]);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2.0,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'En uso',
                                                        style: labelText,
                                                      ),
                                                      Text(
                                                        '$totalEnUso',
                                                        style: labelNumber,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                            ),
                                            child: SizedBox(
                                              width: deviceWidth / 2,
                                              child: Container(
                                                color: ColorsApp.estadoEnVenta,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Disponibles',
                                                        style: labelText,
                                                      ),
                                                      Text(
                                                        '$totalEnVenta',
                                                        style: labelNumber,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Sucias',
                                                        style: labelText,
                                                      ),
                                                      Text(
                                                        '$totalSucio',
                                                        style: labelNumber,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: deviceWidth / 3,
                                            decoration: BoxDecoration(
                                              color: ColorsApp.estadoSinRevisar,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text('Limpias',
                                                      style: labelText),
                                                  Text(
                                                    '$totalEnRevision',
                                                    style: labelNumber,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                            ),
                                            child: SizedBox(
                                              width: deviceWidth / 3,
                                              child: Container(
                                                color: ColorsApp
                                                    .estadoConIncidencias,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Con detalles',
                                                        style: labelText,
                                                      ),
                                                      Text(
                                                        '$totalIncidencias',
                                                        style: labelNumber,
                                                      ),
                                                    ],
                                                  ),
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
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchRooms,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'No se encontraron habitaciones registradas en este hotel. :)'),
                        SizedBox(
                          width: 125.0,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  fetchRooms();
                                });
                              },
                              child: Row(
                                children: [
                                  Text('Recargar'),
                                  Icon(Icons.replay_outlined),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
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
