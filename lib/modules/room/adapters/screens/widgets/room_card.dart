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
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            5.0), // Ajusta el radio del borde de la tarjeta
        side: const BorderSide(
            color: Colors.black, width: 0.5), // Añade un borde más marcado
      ),
      child: ListTile(
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
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
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
            Container(
              decoration: BoxDecoration(
                color: widget.room.status == 0 ? Colors.green : Colors.red,
                // color: Colors.blue,
                shape: BoxShape.circle,
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
            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () {},
            // ),
          ],
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
