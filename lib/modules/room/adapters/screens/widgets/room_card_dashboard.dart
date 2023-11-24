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
      elevation: 5.0,
      shadowColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: Text(
                  roomIncidences.identifier,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            botonPorEstado(context, roomIncidences.status),
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
            Text('Revisar', style: TextStyle( color: Colors.black),),
          ],
        ),
      );
    default:
      return const Text('Estado no válido');
  }
}
