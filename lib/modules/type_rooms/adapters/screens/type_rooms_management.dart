import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/type_rooms/adapters/screens/widgets/type_room_card.dart';
import 'package:geco_mobile/modules/type_rooms/entities/type_room.dart';

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
    final dio = Dio();
    final response = await dio.get(_path);
    if (response.data['status'] == 'OK') {
      for (var tipoRoom in response.data['data']) {
        listaTiposCuarto.add(TypeRoom.fromJson(tipoRoom));
      }
    } else {
      return [];
    }
    return listaTiposCuarto;
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
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/login');
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
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TypeRoomCard(snapshot.data![index]);
                          },
                        );
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
                            Navigator.of(context)
                                .pushNamed('/manager/types/register');
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
