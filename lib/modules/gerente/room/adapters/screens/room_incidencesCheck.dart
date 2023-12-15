// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RoomIncidencesCheck extends StatefulWidget {
  const RoomIncidencesCheck({super.key});

  @override
  State<RoomIncidencesCheck> createState() => _RoomIncidencesCheckState();
}

class _RoomIncidencesCheckState extends State<RoomIncidencesCheck> {
  TextStyle textoLabel =
      const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold);
  Map<String, dynamic> incidences = {};

  Future<Map<String, dynamic>> fetchIncidenceRoom(idIncidence) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final dio = Dio();
      final response =
          await dio.get('${GlobalData.pathIncidenceUri}/$idIncidence',
              options: Options(headers: {
                // "Accept": "application/json",
                "Content-Type": "application/json",
                'Authorization': 'Bearer $token'
              }));
      Map<String, dynamic> inciden =
          Map<String, dynamic>.from(response.data['data']);
      return inciden;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idIncidence = arguments['idIncidence'];
    final idRoom = arguments['idRoom'];
    double widthImage = MediaQuery.of(context).size.width;

    void completarIncidencia(idRoom) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final dio = Dio();
        final response =
            await dio.put('${GlobalData.pathIncidenceUri}/status/$idIncidence',
                options: Options(headers: {
                  // "Accept": "application/json",
                  "Content-Type": "application/json",
                  'Authorization': 'Bearer $token'
                }));
        if (response.statusCode! >= 200) {
          if (response.data['status'] == 'OK') {
            //Si se cambio el estado con exito
            final response2 =
                await dio.get('${GlobalData.pathIncidenceUri}/room/$idRoom',
                    options: Options(headers: {
                      // "Accept": "application/json",
                      "Content-Type": "application/json",
                      'Authorization': 'Bearer $token'
                    }));
            final data = response2.data['data'];
            bool hasCompleted = false;
            for (var inciden in data) {
              if (inciden['status'] == 0) {
                hasCompleted = true;
              }
            }
            if (hasCompleted) {
              Toasts.showSuccessToast(
                  'Se ha completado la incidencia, Sin embargo, aún hay incidencias pendientes por revisar.');
              Navigator.of(context).popAndPushNamed('/manager');
            } else {
              await dio.put('${GlobalData.pathRoomUri}/status/$idRoom',
                  data: {"status": 4},
                  options: Options(headers: {
                    // "Accept": "application/json",
                    "Content-Type": "application/json",
                    'Authorization': 'Bearer $token'
                  }));
              Toasts.showSuccessToast(
                  'Se han completado todas las incidencias. La habitacion queda disponible para su revisión.');
              Navigator.of(context).popAndPushNamed('/manager');
            }
          }
        }
      } on DioException catch (e) {
        print('ERROR DIO AQUI: $e');
      } catch (e, f) {
        print('ERROR AQUI: $e ,  $f');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar incidencia'),
        backgroundColor: ColorsApp().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: fetchIncidenceRoom(idIncidence),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al cargar los detalles del registro'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No hay datos disponibles'));
            } else {
              final incidencia = snapshot.data!;
              final byteImage =
                  const Base64Decoder().convert(incidencia['image']);
              return Card(
                elevation: 5.0,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.memory(
                        byteImage,
                        width: widthImage,
                        height: 350,
                        fit: BoxFit.fill,
                      ),
                      DataTable(columns: const [
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Descripción',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                        ),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text(
                            incidencia['description'],
                            maxLines: 10,
                          )),
                        ]),
                      ]),
                      const SizedBox(height: 20.0),
                      DataTable(columnSpacing: 35.0, columns: const [
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Habitación',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Creador',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text(
                            'Fecha de creación',
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                        ),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text(incidencia['idRoom']['name'])),
                          DataCell(Text(incidencia['idUser']['username'])),
                          DataCell(Text(incidencia['discoveredOn'])),
                        ]),
                      ]),
                      const Spacer(),
                      Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.buttonPrimaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                            onPressed: () {
                              completarIncidencia(idRoom);
                            },
                            child: const Text('Marcar como completada')),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
