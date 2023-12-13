import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_revisionCheck.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            5.0), // Ajusta el radio del borde de la tarjeta
        side: const BorderSide(
            color: Colors.black, width: 0.5), // Añade un borde más marcado
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  child: Text(
                    room.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20.0),
                botonPorEstado(context, room.status, room.idRoom),
              ],
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
      ),
    );
  }
}

Widget botonPorEstado(BuildContext context, int estado, int idRoom) {
  switch (estado) {
    case 0:
      return const Text('Deshabilitada');
    case 1: //En venta
      return const Text('Disponible');
    case 2: //En uso
      return const Text('En uso');
    case 3: //Sucia
      return const Text('Desocupada');
    case 4: //Para revisar
      return Ink(
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
      );

    case 5: //Con incidencias
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/dashboard/checkRevision');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.estadoSinRevisar,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning),
            Text(
              'Revisar',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    default:
      return const Text('Estado no válido');
  }
}
