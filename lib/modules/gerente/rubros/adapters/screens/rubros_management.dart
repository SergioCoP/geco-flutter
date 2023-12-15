// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/rubros/adapters/screens/rubros_register.dart';
import 'package:geco_mobile/modules/gerente/rubros/adapters/screens/widgets/rubro_card.dart';
import 'package:geco_mobile/modules/gerente/rubros/entities/rubro.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RubrosManagement extends StatefulWidget {
  const RubrosManagement({super.key});

  @override
  State<RubrosManagement> createState() => _RubrosManagementState();
}

class _RubrosManagementState extends State<RubrosManagement> {
  final double heightOfFirstContainer = 100.0;
  final _path = GlobalData.pathRubroUri;
  late bool hasChange = false;
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  String namehotel = 'Geco';

  late Future<List<Rubro>> _listaRubros;
  late Future<List<Rubro>> _listaRubrosRepaldo;
  @override
  void initState() {
    super.initState();
    _listaRubros = obtenerRubrosFetch();
    _listaRubrosRepaldo = _listaRubros;
    setColor();
  }

  void setColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? color11 = prefs.getString('primaryColor');
    String? color22 = prefs.getString('secondaryColor');
    setState(() {
      color1 = Color(int.parse(color11!));
      color2 = Color(int.parse(color22!));
    });
  }

  Future<List<Rubro>> obtenerRubrosFetch() async {
    List<Rubro> listaRubrosFetch = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? idHotel = prefs.getInt('idHotel');
    try {
      final dio = Dio();

      final response = await dio.get(_path,
          options: Options(headers: {
            // "Accept": "application/json",
            // "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        if (response.data['data'] != null) {
          for (var rubro in response.data['data']) {
            if (rubro['idHotel']['idHotel'] == idHotel) {
              listaRubrosFetch.add(Rubro.fromJson(rubro));
            }
          }
        }
      }
      return listaRubrosFetch;
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer los rubros de revisión. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
          title: const Text('Gestión de Rubros de revisión'),
          backgroundColor: color1,
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
                child: Icon(Icons.logout, color: color2),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _listaRubros = obtenerRubrosFetch();
              _listaRubrosRepaldo = _listaRubros;
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
                            List<Rubro> rub = snapshot.data!;
                            if (rub.isNotEmpty) {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return RubroCard(
                                      rubro: snapshot.data![index]);
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text(
                                      'No hay ningún rubro de evaluacion registrado actualmente. '));
                            }
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
                              suffixIcon:
                                  Icon(Icons.search, color: Colors.blue),
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
                              // Navigator.of(context)
                              //     .pushNamed('/manager/rubros/register');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RubroRegister()),
                              );
                            },
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
