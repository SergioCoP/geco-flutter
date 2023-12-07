import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/rubros/adapters/screens/widgets/rubro_card.dart';
import 'package:geco_mobile/modules/rubros/entities/rubro.dart';

class RubrosManagement extends StatefulWidget {
  const RubrosManagement({super.key});

  @override
  State<RubrosManagement> createState() => _RubrosManagementState();
}

class _RubrosManagementState extends State<RubrosManagement> {
  final double heightOfFirstContainer = 100.0;
  final _path = GlobalData.pathRubroUri;
  late bool hasChange = false;

  late Future<List<Rubro>> _listaRubros;
  late Future<List<Rubro>> _listaRubrosRepaldo;
  @override
  void initState() {
    super.initState();
    _listaRubros = obtenerRubrosFetch();
  }

  Future<List<Rubro>> obtenerRubrosFetch() async {
    List<Rubro> listaRubrosFetch = [];
    try {
      final dio = Dio();
      final response = await dio.get(_path);
      if (response.data['status'] == 'OK') {
        for (var rubro in response.data['data']) {
          listaRubrosFetch.add(Rubro.fromJson(rubro));
        }
      }
      return listaRubrosFetch;
    } catch (e) {
      return listaRubrosFetch;
    }
  }

  void filtrarRubros(String query) {
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      _listaRubros.then((data) {
        setState(() {
          List<Rubro> datosFiltrados = data.where((rubro) {
            return rubro.name.toLowerCase().contains(query);
          }).toList();
          _listaRubros = Future.value(datosFiltrados);
        });
      });
    } else {
      setState(() {
        _listaRubros = _listaRubrosRepaldo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Gestión de Rubros de evaluación'),
          backgroundColor: ColorsApp.primaryColor,
          foregroundColor: Colors.white,
          actions: [
            InkWell(
              onTap: () {
                print("Boton para logot, asies");
                // Navigator.pushNamed(context, '/login');
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
        body: Stack(
          children: [
            Scaffold(
              body: Container(
                  margin: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: FutureBuilder<List<Rubro>>(
                      future: _listaRubros,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return RubroCard(rubro: snapshot.data![index]);
                            },
                          );
                        }
                      })),
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
                            filtrarRubros(text.toString());
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search, color: Colors.blue),
                            labelText: 'Buscar Rubro',
                            hintText: 'Buscar por nombre de rubro',
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
                                .pushNamed('/manager/rubros/register');
                          },
                          child: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
