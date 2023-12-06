import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/entities/room.dart';

class RoomCard extends StatefulWidget {
  final Room room;
  final String path;
  const RoomCard({super.key, required this.room, required this.path});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  List<String> switches = [];
  bool stvalue = false;
  bool statusSw = false;
  @override
  Widget build(BuildContext context) {
    statusSw = widget.room.status == 1 ? true : false;
    Color? buttonColor;
    String? estado;
    switch (widget.room.status) {
      case 0: //eliminnada o desg¡habilitada
        estado = 'No disponible';
        buttonColor = Colors.red;
        break;
      case 1: //Estado: disponible para rentar
        estado = 'En venta';
        buttonColor = ColorsApp.estadoEnVenta;
        break;
      case 2: //Estado: en uso
        estado = 'En uso';
        buttonColor = ColorsApp.estadoEnUso;
        break;
      case 3: //Estado: sucio
        estado = 'Sucia';
        buttonColor = ColorsApp.estadoSucio;
        break;
      case 4: //Estado: Lista para ser revisada
        estado = 'Para revisar';
        buttonColor = ColorsApp.estadoSinRevisar;
        break;
      case 5: //Estado con incidencias
        estado = 'Con incidencias';
        buttonColor = ColorsApp.estadoConIncidencias;
        break;
      default:
        estado = 'Sin definir';
        buttonColor = Colors.grey;
        break;
    }
    void selectRubros(Room room) {
      bool switchStatus = false;
      AlertDialog(
          title: const Text('Selecciona un rubro'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Esta es la habitación $room.name'),
                const Text('Esta sería la lista de rubros disponibles'),
                Switch(
                  value: switchStatus,
                  onChanged: (bool value) {
                    setState(() {
                      switchStatus = value;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.red.shade100,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Establecer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]);
    }

    return Card(
        margin: const EdgeInsets.all(12.0),
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(color: Colors.black, width: 0.5),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  // SE MUESTRA EL IDENTIFICADOR Y SUS BOTONES
                  children: [
                    Text(
                      widget.room.identifier,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  // SE MUESTRA EL ESTADO DE LA HABITACIÓN
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // AQUI VAN LOS BOTONES
                        Ink(
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/manager/check_rooms/edit_room',
                                arguments: {'idRoom': widget.room.idRoom},
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Ink(
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              mostrarInfo(context, widget.room, estado!);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  /**
   * ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          widget.room.identifier,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          estado,
          style: const TextStyle(fontSize: 16.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Ink(
              decoration: ShapeDecoration(
                color: Colors.lightBlue,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/manager/check_rooms/edit_room',
                    arguments: {'idRoom': widget.room.idRoom},
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Ink(
              decoration: ShapeDecoration(
                color: widget.room.status == 0 ? Colors.green : Colors.red,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.check_box_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, 'manager/rooms/rubros');
                },
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Ink(
              decoration: ShapeDecoration(
                color: Colors.green,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.change_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  cambiarEstado(context, widget.room, widget.path);
                },
              ),
            ),
          ],
        ),
      ),
    
   */

  void mostrarInfo(context, Room room, String estado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informacion del usuario"),
          content: SizedBox(
            height: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Identificador de la habitación: \n',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: widget.room.identifier,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),

                ///---------------------------
                RichText(
                  text: TextSpan(
                    text: 'Estado de la habitación: \n',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: estado,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),

                ///---------------------------
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void cambiarEstado(context, Room room, String path) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        bool flagEstado = room.status == 1 ? true : false;
        final estadoMessage = flagEstado == true
            ? {
                'title': 'Deshabilitar Habitación',
                'desc': '¿Quieres deshabilitar la habitación '
              }
            : {
                'title': 'Habilitar Habitación',
                'desc': '¿Quieres volver a activar la habitación '
              };
        return AlertDialog(
          title: Text(estadoMessage['title']!),
          content: RichText(
            text: TextSpan(
                text: estadoMessage['desc'],
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: room.identifier,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: '?',
                  )
                ]),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                print('Estado: ' + room.identifier);
                // try {
                //   final dio = Dio();
                //   final response = await dio.put('$path/updateRoom', data: {
                //     'idRoom': room.idRoom,
                //     'identifier': room.identifier,
                //     'status': 2
                //   });
                //   if (response.statusCode == 200) {
                //     // ignore: use_build_context_synchronously
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const RoomRent(),
                //       ),
                //     );
                //   }
                // } catch (e) {}
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
