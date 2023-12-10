// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';
import 'package:geco_mobile/modules/rubros/entities/rubro.dart';

class RubroUpdate extends StatefulWidget {
  const RubroUpdate({super.key});

  @override
  State<RubroUpdate> createState() => _RubroUpdateState();
}

class _RubroUpdateState extends State<RubroUpdate> {
  final TextStyle textStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  late Rubro rubro;
  final _path = GlobalData.pathRubroUri;
  bool hasData = false;
  bool hasError = false;

  final _formKeyUpdateRubro = GlobalKey<FormState>();
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> rubroDataFetch(final idRubro) async {
    try {
      final dio = Dio();
      final response = await dio
          .get('$_path/getRubro', queryParameters: {"idRubro": idRubro});
      if (response.data['msg'] == 'OK') {
        final data = response.data['data'];
        rubro = Rubro(data['idEvaluationItem'] ?? idRubro,
            data['name'] ?? 'Sin nombre', 
            data['status'] ?? 0,
            data['idHotel'] as Hotel
            );
        setState(() {
          hasData = true;
        });
      }
    } catch (e) {
      print(e);
      hasError = true;
    }
  }

  void updateRubro(Rubro rubro) async {
    try {
      final dio = Dio();
      final response = await dio.put(
        _path,
        data: {
          'idEvaluationItem': rubro.idEvaluationItem,
          'name': rubro.name,
          // 'status': rubro.status,
        },
      );
      if (response.data['status'] == 'UPDATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rubro actualizado exitosamente.')),
        );
        Navigator.of(context).popAndPushNamed('/manager/rubros');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Hubo un error al actualizar el rubro. Verifica que el nombre del rubro no exista')),
        );
      }
    } catch (e, e2) {
      print('$e, $e2');
      hasError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idRubro = arguments['idRubro'];
    if (!hasData) {
      rubroDataFetch(idRubro);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Rubro'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: hasData
          ? Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKeyUpdateRubro,
                    onChanged: () {
                      setState(() {
                        _isButtonDisabled =
                            !_formKeyUpdateRubro.currentState!.validate();
                      });
                    },
                    child: Card(
                      elevation: 4.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Ajusta el radio del borde de la tarjeta
                        side: const BorderSide(
                            color: Colors.black,
                            width: 0.5), // Añade un borde más marcado
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Identificador',
                              style: textStyle,
                            ),
                            TextFormField(
                              initialValue: rubro.name,
                              decoration: const InputDecoration(
                                labelText: "Descripcion del rubro",
                                hintText: "Descripcion del rubro",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "La descripcion del rubro es requerida";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                rubro.name = value!;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                  onPressed: _isButtonDisabled
                                      ? null
                                      : () async {
                                          updateRubro(rubro);
                                        },
                                  child: const Text("Actualizar rubro")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
