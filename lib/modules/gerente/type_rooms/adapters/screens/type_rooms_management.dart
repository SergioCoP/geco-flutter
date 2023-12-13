// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_register.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/widgets/type_room_card.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/entities/type_room.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeRoomManagement extends StatefulWidget {
  const TypeRoomManagement({super.key});

  @override
  State<TypeRoomManagement> createState() => _TypeRoomManagementState();
}

class _TypeRoomManagementState extends State<TypeRoomManagement> {
  final double heightOfFirstContainer = 100.0;
  final _path = GlobalData.pathTypeRoomUri;
  bool hasChange = false;

  late Future<List<TypeRoom>> _listaTiposRoom;
  late Future<List<TypeRoom>> _listaTiposRoomRespaldo;

  @override
  void initState() {
    super.initState();
    _listaTiposRoom = obtenerTiposCuartoFetch();
    _listaTiposRoomRespaldo = _listaTiposRoom;
  }

  Future<List<TypeRoom>> obtenerTiposCuartoFetch() async {
    List<TypeRoom> listaTiposCuarto = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idHotel = prefs.getInt('idHotel');
      final dio = Dio();
      final response = await dio.get(_path,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        if (response.data['data'] != null) {
          for (var tipoRoom in response.data['data']) {
            if (tipoRoom['idHotel']['idHotel'] == idHotel) {
              listaTiposCuarto.add(TypeRoom.fromJson(tipoRoom));
            }
          }
        }
      } else {
        return [];
      }
      return listaTiposCuarto;
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer los tipos de habitación. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return listaTiposCuarto;
    } catch (e, f) {
      print('$e, $f');
      return listaTiposCuarto;
    }
  }

  void filtrarTiposRoom(String query) {
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      _listaTiposRoom.then((data) {
        List<TypeRoom> listaTipos = data.where((type) {
          return type.name.toLowerCase().contains(query);
        }).toList();
        setState(() {
          _listaTiposRoom = Future.value(listaTipos);
        });
      });
    } else {
      setState(() {
        _listaTiposRoom = _listaTiposRoomRespaldo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tipo de Cuarto'),
        backgroundColor: ColorsApp().primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            child: Container(
              width: 50,
              height: 60,
              margin: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _listaTiposRoomRespaldo = obtenerTiposCuartoFetch();
            _listaTiposRoom = _listaTiposRoomRespaldo;
          });
          // ignore: void_checks
          return Future.value(true);
        },
        child: Stack(
          children: [
            Scaffold(
              body: Container(
                margin: const EdgeInsets.only(
                  top: 100,
                ),
                child: FutureBuilder<List<TypeRoom>>(
                    future: _listaTiposRoom,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              'Ha sucedido un error al intentar procesar los datos'),
                        );
                      } else {
                        List<TypeRoom> tp = snapshot.data!;
                        if (tp.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return TypeRoomCard(snapshot.data![index]);
                            },
                          );
                        } else {
                          return const Center(
                            child: Text(
                                'No hay nigún tipo de habitacion regitrado actualmente.'),
                          );
                        }
                      }
                    }),
              ),
            ),
            Positioned(
              child: SizedBox(
                height: heightOfFirstContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          onChanged: (text) {
                            filtrarTiposRoom(text.toString());
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search, color: Colors.blue),
                            labelText: 'Buscar tipo de habitacion',
                            hintText: 'Buscar por nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.buttonPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          onPressed: () {
                            // Navigator.of(context)
                            //     .pushNamed('/manager/types/register');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TypeRoomRegister()),
                            );
                          },
                          child: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
