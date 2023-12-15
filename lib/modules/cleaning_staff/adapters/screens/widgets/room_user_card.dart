// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/cleaning_staff/adapters/screens/create_incidence.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:geco_mobile/modules/incidences/entities/incidence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomUserCard extends StatefulWidget {
  final Room room;

  final String path;

  const RoomUserCard({Key? key, required this.room, required this.path})
      : super(key: key);

  @override
  State<RoomUserCard> createState() => _RoomUserCardState();
}

class _RoomUserCardState extends State<RoomUserCard> {
  @override
  Widget build(BuildContext context) {
    Color? buttonColor;
    String? estado;
    List<Incidence> listaIncidencias = [];
    switch (widget.room.status) {
      case 0:
        estado = 'No disponible';
        buttonColor = Colors.red;
        break;
      case 1:
        estado = 'Disponible';
        buttonColor = ColorsApp.estadoEnVenta;
        break;
      case 2:
        estado = 'En uso';
        buttonColor = ColorsApp.estadoEnUso;
        break;
      case 4:
        estado = 'Con detalles';
        buttonColor = ColorsApp.estadoConIncidencias;
        break;
      case 3:
        estado = 'Para revisar';
        buttonColor = ColorsApp.estadoSinRevisar;
        break;
      case 5:
        estado = 'Sucia';
        buttonColor = ColorsApp.estadoEnUso;
        break;
      default:
        estado = 'Sin definir';
        buttonColor = Colors.grey;
        break;
    }
    void cambiarEstado(String roomName) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // width: 100.0,
                  // height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(
                        10.0), // Ajusta el valor según sea necesario
                  ),
                  child: Text(
                    roomName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                // const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '¿Quieres marcar la habitación para su revisión?',
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            final dio = Dio();
                            int estado = 4;
                            Response response;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? token = prefs.getString('token');
                            final response1 = await dio.get(
                                '${GlobalData.pathIncidenceUri}/room/${widget.room.idRoom}',
                                options: Options(headers: {
                                  // "Accept": "application/json",
                                  // "Content-Type": "application/json",
                                  'Authorization': 'Bearer $token'
                                }));
                            if (response1.data['status'] == 'OK') {
                              if (response1.data['data'] != null) {
                                for (var inci in response1.data['data']) {
                                  if (inci['status'] == 1) {
                                    listaIncidencias
                                        .add(Incidence.fromJson(inci));
                                  }
                                }
                              }
                            }
                            if (listaIncidencias.isEmpty) {
                              //Marcar como con detalle
                              estado = 5;
                            }

                            response = await dio.put(
                                '${GlobalData.pathRoomUri}/status/${widget.room.idRoom}',
                                data: {'status': estado},
                                options: Options(headers: {
                                  // "Accept": "application/json",
                                  // "Content-Type": "application/json",
                                  'Authorization': 'Bearer $token'
                                }));
                            if (response.data['status'] == 'OK') {
                              setState(() {
                                widget.room.status = 4;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Habitacion en espera para revisión.')),
                                );
                                Navigator.of(context).pop();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'No se pudo cambiar el estado de la habitación. Intenta más tarde.')),
                              );
                              Navigator.of(context).pop();
                            }
                          } on DioException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No se pudo cambiar el estado de la habitación. Intenta más tarde.')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No se pudo cambiar el estado de la habitación. Intenta más tarde.')),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(color: Colors.black, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          widget.room.name,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          estado,
          style: const TextStyle(fontSize: 16.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.room.status == 5
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.pending_actions_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        cambiarEstado(widget.room.name);
                      },
                    ),
                  )
                : const SizedBox(
                    width: 10.0,
                  ),
            const SizedBox(
              width: 10.0,
            ),
            widget.room.status == 3 ||
                    widget.room.status == 4 ||
                    widget.room.status == 5
                ? Container(
                    decoration: const BoxDecoration(
                      color: ColorsApp.estadoConIncidencias,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // showCustomDialogForm(widget.room.name);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateIncidence(
                              room: widget.room,
                            ),
                            settings: RouteSettings(
                              arguments: {'idRoom': widget.room.idRoom},
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(
                    width: 1.0,
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              width: 30.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
