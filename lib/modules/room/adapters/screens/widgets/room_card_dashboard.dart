import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/entities/rooms_incidences.dart';

class RoomCardDashboard extends StatelessWidget {
  final RoomIncidences roomIncidences;
  const RoomCardDashboard({super.key, required this.roomIncidences});

  @override
  Widget build(BuildContext context) {
    Color? buttonColor;
    switch (roomIncidences.status) {
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
                    roomIncidences.identifier,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20.0),
                botonPorEstado(context, roomIncidences.status),
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

Widget botonPorEstado(BuildContext context, int estado) {
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
      return ElevatedButton(
        //Si hay incidencias
        onPressed: () {
          Navigator.of(context).pushNamed('/dashboard/checkIncindences');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.estadoConIncidencias,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.read_more),
            Text(
              'Verificar',
              style: TextStyle(color: Colors.black),
            ),
          ],
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
