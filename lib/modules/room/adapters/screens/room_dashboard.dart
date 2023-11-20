// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/room/adapters/screens/widgets/room_card_dashboard.dart';
import 'package:geco_mobile/modules/room/entities/rooms_incidences.dart';

class RoomsDashboard extends StatelessWidget {
  RoomsDashboard({super.key});
  final double heightOfFirstContainer = 250.0;
  final RoomIncidences roomIncidences = RoomIncidences(1, 'HAB01', 2, true);

  @override
  Widget build(BuildContext context) {
    String algo = 'Panel de control';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Stack(
        children: [
          Scaffold(
            body: Container(
                margin: const EdgeInsets.only(
                  top: 250,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  children: <Widget>[
                    RoomCardDashboard(roomIncidences: roomIncidences,),
                    RoomCardDashboard(roomIncidences: roomIncidences,),
                    RoomCardDashboard(roomIncidences: roomIncidences,),
                  ],
                )),
          ),
          Positioned(
              child: SizedBox(
            height: heightOfFirstContainer,
            child: Column(
              children: [
                // TITULO: PANEL DE CONTROL
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(algo),
                ),
                //CUADRO DONDE ESTA EL TOTAL DE CUARTOS
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      // TOTAL DE CUARTOS
                      Column(
                        children: [
                          Text('Total de Cuartos'),
                          Text('30'),
                        ],
                      ),
                      Spacer(),
                      //CUARTOS EN VENTA
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: ColorsApp.estadoEnVenta,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('En venta: 20'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //ETIQUETAS DE CUARTOS CON SUS ESTADOS
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.estadoSinRevisar,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Para revisar: 2'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.estadoConIncidencias,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Con incidencias: 1'),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.estadoSucio,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Sucias: 2'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.estadoEnUso,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('En uso: 5'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
