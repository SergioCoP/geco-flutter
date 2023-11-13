import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/adapters/screens/room_rent.dart';
import 'package:geco_mobile/modules/room/entities/room.dart';

class RoomCard extends StatefulWidget {
  final Room room;
  final String path;
  const RoomCard({super.key, required this.room, required this.path});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
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

    return Card(
      elevation: 5.0,
      shadowColor: const Color.fromARGB(118, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        onTap: () {
          cambiarEstado(context, widget.room, widget.path);
        },
        child: SizedBox(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
                child: Text(
                  estado,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              const Spacer(),
              Text(
                widget.room.identifier,
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (widget.room.status == 1)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Rentar',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: Color.fromARGB(255, 149, 33, 243),
                      //     fontWeight: FontWeight.bold),
                      // ),
                      Icon(
                        Icons.swap_horizontal_circle,
                        color: Colors.red,
                        size: 50.0,
                      )
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '',
                    style: TextStyle(
                        fontSize: 50,
                        color: Color.fromARGB(255, 149, 33, 243),
                        fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void cambiarEstado(context, Room room, String path) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        bool flagEstado = room.status == 1 ? true : false;
        if (flagEstado) {
          return AlertDialog(
            title: const Text('Rentar habitación'),
            content: RichText(
              text: TextSpan(
                  text: '¿Quieres rentar la habitación ',
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
                  final dio = Dio();
                  final response = await dio.put('$path/updateRoom', data: {
                    'idRoom': room.idRoom,
                    'identifier': room.identifier,
                    'status': 2
                  });
                  if (response.statusCode == 200) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoomRent(),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Cambiar estado'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Cancelar'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Lo sentimos'),
            content: const Text(
                'No puedes rentar una habitacion que no esté en venta.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 196, 34, 34),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Cerrar'),
              ),
            ],
          );
        }
      },
    );
  }
}
