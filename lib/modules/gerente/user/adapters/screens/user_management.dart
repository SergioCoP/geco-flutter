// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/user/adapters/screens/user_register.dart';
import 'package:geco_mobile/modules/gerente/user/adapters/screens/widgets/user_card.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final colorsApp = ColorsApp();
  bool hasChange = false;
  final double heightOfFirstContainer = 100.0;
  final path = GlobalData.pathUserUri;
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  bool hasData = false;
  Future<List<User>>? _listUsuarios;
  Future<List<User>>? _listUsuariosRespaldo;

  @override
  void initState() {
    super.initState();
    _listUsuarios = obtenerUsuariosFetch();
    _listUsuariosRespaldo = _listUsuarios;
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

  Future<List<User>> obtenerUsuariosFetch() async {
    List<User> usuariost = [];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idHotel = prefs.getInt('idHotel');
      String? primaryColor = prefs.getString('primaryColor');
      String? secondaryColor = prefs.getString('secondaryColor');
      color1 = Color(int.parse(primaryColor!));
      color2 = Color(int.parse(secondaryColor!));
      hasChange = true;

      final dio = Dio();
      final response = await dio.get(path,
          options: Options(headers: {
            // "Accept": "application/json",
            // "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        if (response.data['data'] != null) {
          for (var usuario in response.data['data']) {
            if (usuario['idHotel']['idHotel'] == idHotel) {
              usuariost.add(User.fromJson(usuario));
            }
          }
        }
      }
      return usuariost;
    } on DioException catch (e) {
      print('ERROR USERS DE DIO: $e');
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer a los usuarios. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return usuariost;
    } catch (e, f) {
      print('ESTE ES UN ERROR DESDE TIPOS DE USUARIOS: $e, $f');
      return usuariost;
    }
  }

  void filtrarUsuario(String query) {
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      _listUsuarios?.then((data) {
        setState(() {
          List<User> usuariosFiltrados = data.where((user) {
            String fullname =
                '${user.idPerson?.name} ${user.idPerson?.lastname} ${user.idPerson?.surname}';
            return user.username!.toLowerCase().contains(query) ||
                user.idRol!.name.toLowerCase().contains(query) ||
                fullname.toLowerCase().contains(query);
          }).toList();
          _listUsuarios = Future.value(usuariosFiltrados);
        });
      });
    } else {
      setState(() {
        _listUsuarios = _listUsuariosRespaldo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasChange) {
      setState(() {
        color1 = color1;
        color2 = color2;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de usuarios'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _listUsuarios = obtenerUsuariosFetch();
            _listUsuariosRespaldo = _listUsuarios;
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
                child: FutureBuilder(
                  future: _listUsuarios,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                          child: Text("Ha sucedido un error maquiavelico."));
                    } else {
                      List<User> sapoUser = snapshot.data;
                      if (sapoUser.isNotEmpty) {
                        return ListView.builder(
                          itemCount: sapoUser.length,
                          itemBuilder: (BuildContext context, int index) {
                            return UserCard(user: sapoUser[index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  'No hay ningun usuario registrado Actualmente.'),
                              SizedBox(
                                width: 130.0,
                                child: ElevatedButton(
                                    onPressed: () {
                                      // setState(() {
                                      //   obtenerUsuariosFetch();
                                      // });
                                      setState(() {
                                        _listUsuarios = obtenerUsuariosFetch();
                                        _listUsuariosRespaldo = _listUsuarios;
                                      });
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Recargar '),
                                        Icon(Icons.replay_outlined)
                                      ],
                                    )),
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            //Aqui va para registrar un usuario, buscar usuarios
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
                            filtrarUsuario(text);
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search, color: Colors.blue),
                            labelText: 'Buscar usuario',
                            hintText: 'Escribe aquí para buscar a un usuario',
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
                            ),
                          ),
                          onPressed: () {
                            // Navigator.of(context)
                            //     .pushNamed('/manager/users/register');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const UserRegister()));
                          },
                          child: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> cambiarEstadoUser(BuildContext context, User user) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Dar de baja a un usuario"),
      content:
          // Text('¿Está seguro de cambiar de activo a desactivado al usuario ${user.person.name} ?'),
          Text(
              '¿Está seguro de cambiar de activo a desactivado al usuario ${user.idPerson?.name} ?'),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorsApp.buttonPrimaryColor,
          child: const Text('Cancelar'),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorsApp.buttonCancelColor,
          child: const Text(
            'Dar de baja',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}
