import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/entities/rooms_incidences.dart';

class RoomCardDashboard extends StatelessWidget {
  final RoomIncidences roomIncidences;
  const RoomCardDashboard({super.key, required this.roomIncidences});

  @override
  Widget build(BuildContext context) {
    Color? buttonColor;
    String? estado;
    switch (roomIncidences.status) {
      case 0: //eliminada o deshabilitada
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
      shadowColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        onTap: () {},
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
              roomIncidences.identifier,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (roomIncidences.status == 5) //Si Tiene incidencias
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        //Si hay incidencias
                        onPressed: () {
                          Navigator.of(context).pushNamed('/dashboard/checkIncindences');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 200, 2),
                        ),
                        child: const Icon(Icons.warning),
                      ),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
