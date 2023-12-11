// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/rubros/entities/rubro.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/entities/type_room.dart';

class TypeRoomUpdate extends StatefulWidget {
  const TypeRoomUpdate({super.key});

  @override
  State<TypeRoomUpdate> createState() => _TypeRoomUpdateState();
}

class _TypeRoomUpdateState extends State<TypeRoomUpdate> {
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();
  bool _isButtonDisabled = false;
  bool hasData = false;
  bool hasError = false;
  final _path = GlobalData.pathTypeRoomUri;
  List<Map<String, int>> listEvaluationItems = [];
  List<Rubro> listaRubros = [];
  List<bool> rubrosValue = [];
  late TypeRoom typeRoom;
  final TextEditingController _nameController = TextEditingController(text: '');

  Future<void> getTypeRoomFetch(final idTypeRoom) async {
    try {
      Response response;
      response = await dio.get('$_path/$idTypeRoom');
      if (response.data['status'] == 'OK') {
        typeRoom = TypeRoom.fromJson(response.data['data']);
        _nameController.text = typeRoom.name;
        Response response2;
        response2 = await dio.get(GlobalData.pathRubroUri);
        if (response2.data['status'] == 'OK') {
          final data = response2.data['data'];
          if (data is List) {
            listaRubros = List.generate(
                data.length, (index) => Rubro.fromJson(data[index]));
            rubrosValue = List.generate(
              listaRubros.length,
              (index) {
                bool flag = false;
                Rubro rubro = listaRubros[index];
                for (var tR in typeRoom.rubros) {
                  if (tR.idEvaluationItem == rubro.idEvaluationItem) {
                    flag = true;
                  }
                }
                return flag;
              },
            );
          } else {
            listaRubros = [];
          }
          setState(() {
            hasData = true;
          });
        }
        setState(() {
          typeRoom = TypeRoom.fromJson(response.data['data']);
          hasData = true;
        });
      }
    } catch (e) {
      setState(() {
        // hasData = true;
        hasError = true;
        throw Exception('Error al obtener los datos');
      });
    }
  }

  void updateTypeRoom() async {
    try {
      final data = {
        'idTypeRoom': typeRoom.idTypeRoom,
        'name': _nameController.text,
        'idHotel': {
          'idHotel': typeRoom.idHotel.idHotel,
        },
        'evaluationItems': listEvaluationItems
      };

      Response response;
      response = await dio.put(_path, data: data);
      if (response.data['status'] == 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('registro actualizado exitosamente.')),
        );
        Navigator.of(context).popAndPushNamed('/manager/types');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Hubo un error al actualizar el rubro. Verifique sus datos y pruebe más tarde.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Hubo un error al actualizar el rubro. Verifique sus datos y pruebe más tarde.')),
      );
      throw Exception('Error al obtener los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idTypeRoom = arguments['idTypeRoom'] ?? 0;
    if (!hasData) {
      getTypeRoomFetch(idTypeRoom);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar tipo de habitación'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: hasData
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  onChanged: () {
                    setState(() {
                      _isButtonDisabled = !_formKey.currentState!.validate();
                    });
                  },
                  child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: Colors.black, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                labelText: 'Nombre del tipo de habitación'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'El nombre del tipo de habitación es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text('Selecciona las opciones:'),
                          Column(
                            children: List.generate(
                              listaRubros.length,
                              (index) {
                                Rubro rubro = listaRubros[index];
                                return CheckboxListTile(
                                  title: Text(rubro.name),
                                  value: rubrosValue[index],
                                  onChanged: (value) {
                                    setState(() {
                                      rubrosValue[index] = value!;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.buttonPrimaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () {
                                      List<int> selected = [];
                                      for (var i = 0;
                                          i < rubrosValue.length;
                                          i++) {
                                        if (rubrosValue[i]) {
                                          selected.add(i);
                                        }
                                      }

                                      listEvaluationItems = List.generate(
                                          selected.length, (index) {
                                        return {
                                          'idEvaluationItem':
                                              listaRubros[selected[index]]
                                                  .idEvaluationItem
                                        };
                                      });
                                      updateTypeRoom();
                                    },
                              child: const Text('Actualizar'))
                        ],
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