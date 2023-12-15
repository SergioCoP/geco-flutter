// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/create_incidence_gerente.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_incidencesCheck.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_revisionCheck.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomCardDashboard extends StatelessWidget {
  final Room room;
  const RoomCardDashboard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    Color? buttonColor;
    switch (room.status) {
      case 0: //eliminada o deshabilitada
        buttonColor = Colors.red;
        break;
      case 1: //Estado: disponible para rentar
        buttonColor = ColorsApp.estadoEnVenta;
        break;
      case 2: //Estado: en uso
        buttonColor = ColorsApp.estadoEnUso;
        break;
      case 3: //Estado: sucio
        buttonColor = ColorsApp.estadoSucio;
        break;
      case 4: //Estado: Lista para ser revisada
        buttonColor = ColorsApp.estadoSinRevisar;
        break;
      case 5: //Estado con incidencias
        buttonColor = ColorsApp.estadoConIncidencias;
        break;
      default:
        buttonColor = Colors.grey;
        break;
    }
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(color: Colors.white)),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //NOMBRE DE LA HABITACION
                  Text(
                    room.name,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    width: 30,
                    height: 31,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25.0),
              botonPorEstado(context, room.status, room.idRoom, room),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable

Widget botonPorEstado(BuildContext context, int estado, int idRoom, Room room) {
  switch (estado) {
    case 0:
      return const Text('Deshabilitada');
    case 1: //En venta
      return const Text('Disponible');
    case 2: //En uso
      return const Text('En uso');
    case 3: //Sucia
      return const Text('Sucia');
    case 4: //Para revisar
      return Row(
        children: [
          Ink(
            decoration: ShapeDecoration(
              color: ColorsApp.estadoSinRevisar,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RoomRevisionCheck(),
                      settings: RouteSettings(arguments: {'idroom': idRoom})),
                );
              },
            ),
          ),
          const SizedBox(width: 5.0),
          Ink(
            decoration: ShapeDecoration(
              color: ColorsApp.estadoConIncidencias,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.warning,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateIncidenceGerente(room: room),
                      settings: RouteSettings(arguments: {'idroom': idRoom})),
                );
              },
            ),
          ),
        ],
      );
    case 5: //Con incidencias
      return Ink(
        decoration: ShapeDecoration(
          color: ColorsApp.estadoConIncidencias,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          onPressed: () async {
            try {
              print('Boton para ver las incidencias');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder(
                      future: fetchIncidencias(idRoom),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return const AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Ha ocurrido un error al cargar las incidencias.'),
                          );
                        } else if (snapshot.data!.isEmpty) {
                          return const AlertDialog(
                            title: Text('Sin incidencias'),
                            content: Text(
                                'Esta habitación no cuenta con incidencias.'),
                          );
                        } else {
                          return IncidenciasDialog(incidencias: snapshot.data!);
                        }
                      });
                },
              );
            } catch (e, f) {
              print('ESTO ES UN ERROR: $e  , $f');
            }
          },
        ),
      );
    default:
      return const Text('Estado no válido');
  }
}

Future<List<Map<String, dynamic>>> fetchIncidencias(idRoom) async {
  try {
    print('Entera en la peticion');
    List<Map<String, dynamic>> incidences = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final dio = Dio();
    print('Antes del primer get');
    final response =
        await dio.get('${GlobalData.pathIncidenceUri}/room/$idRoom',
            options: Options(headers: {
              // "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token'
            }));
    print('despues del primer get: ${response.data}');
    if (response.statusCode == 200) {
      if (response.data['status'] == 'OK') {
        final data = response.data['data'];
        incidences = List.generate(
          data.length,
          (i) => {
            'idIncidence': data[i]['idIncidence'],
            'image': data[i]['image'],
            'discoveredOn': data[i]['discoveredOn'],
            'resolvedOn': data[i]['resolvedOn'] ?? '---',
            'description': data[i]['description'],
            'status': data[i]['status'],
            'idUser': data[i]['idUser']['idUser'],
            'username': data[i]['idUser']['username'],
            'idRoom': data[i]['idRoom']['idRoom'],
          },
        );
      }
    }
    return incidences;
  } catch (e) {
    print(e);
    rethrow;
  }
}

// ignore: must_be_immutable
class IncidenciasDialog extends StatelessWidget {
  final List<Map<String, dynamic>> incidencias;

  const IncidenciasDialog({super.key, required this.incidencias});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Tabla de Incidencias'),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: SizedBox(
            child: DataTable(
              columnSpacing: 12.0,
              columns: const [
                DataColumn(label: Text('Fecha Incidencia')),
                DataColumn(label: Text('Fecha Resuelta')),
                DataColumn(label: Text('Estado')),
              ],
              rows: incidencias.map((incidencia) {
                return DataRow(
                  cells: [
                    DataCell(Center(child: Text(incidencia['discoveredOn']))),
                    DataCell(
                      Center(
                        child: Text(incidencia['resolvedOn'] ?? '---'),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: incidencia['status'] == 0
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsApp.infoColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RoomIncidencesCheck(),
                                        settings: RouteSettings(arguments: {
                                          'idIncidence':
                                              incidencia['idIncidence'],
                                          'idRoom': incidencia['idRoom']
                                        })),
                                  );
                                },
                                child: const Text('Ver'),
                              )
                            : const Text('Resuelta'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
