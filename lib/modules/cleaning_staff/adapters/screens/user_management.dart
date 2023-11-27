import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/user/adapters/screens/widgets/user_card.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final double heightOfFirstContainer = 100.0;
  final path = GlobalData.pathUserUri;
  bool hasData = false;
  Future<List<User>>? _listUsuarios;
  Future<List<User>>? _listUsuariosRespaldo;

  @override
  void initState() {
    super.initState();
    _listUsuarios = obtenerUsuariosFetch();
    _listUsuariosRespaldo = _listUsuarios;
  }

  Future<List<User>> obtenerUsuariosFetch() async {
    List<User> usuariost = [];
    // try {
    final dio = Dio();
    final response = await dio.get('$path/getUsers');
    if (response.data['msg'] == 'OK') {
      for (var usuario in response.data['data']) {
        User user = User(
            usuario['idUser'],
            usuario['status'] ?? 0,
            usuario['userName'],
            usuario['userEmail'],
            usuario['password'] ?? '',
            usuario['turn'] ?? '',
            usuario['userRol'] ?? 'Role_Limpieza',
            usuario['idRol'] ?? 3,
            usuario['idHotel'] ?? 0);
        usuariost.add(user);
      }
    }
    return usuariost;
    // } catch (e) {
    //   print(e);
    //   return usuarios;
    // }
  }

  List<Widget> crearCards(List<User> data) {
    List<Widget> userCards = [];
    for (var user in data) {
      userCards.add(UserCard(user: user));
    }
    return userCards;
  }

  void filtrarUsuario(String query) {
    query = query.toLowerCase();
    List<User> usuariosFiltrados = [];
    if (query.isEmpty) {
      _listUsuarios = _listUsuariosRespaldo;
    }
    if (_listUsuarios != null) {
      _listUsuarios!.then((usuarios) {
        usuariosFiltrados = usuarios.where((user) {
          return user.userName.toLowerCase().contains(query);
        }).toList();
        setState(() {
          _listUsuarios = Future.value(usuariosFiltrados);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de usuarios'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Stack(
        children: [
          Scaffold(
            body: Container(
              margin: const EdgeInsets.only(
                top: 100,
              ),
              child: FutureBuilder(
                future: _listUsuarios,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<User> sapoUser = snapshot.data;
                    if (sapoUser.isNotEmpty) {
                      return GridView.count(
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        children: crearCards(snapshot.data),
                      );
                    } else {
                      return const IsEmpty();
                    }
                  } else if (!snapshot.hasData) {
                    return const IsEmpty();
                  } else if (snapshot.hasError) {
                    return const Text("Ha sucedido un error maquiavelico.");
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          //Aqui va para registrar un usuario, buscar usuarios
          Positioned(
            child: SizedBox(
              height: heightOfFirstContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (text) {
                              filtrarUsuario(text.toString());
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              labelText: 'Buscar usuario',
                              hintText: 'Escribe aquí para buscar a un usuario',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.buttonPrimaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/manager/users/register');
                            },
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IsEmpty extends StatelessWidget {
  const IsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('No hay ningun usuario registrado Actualmente :)'));
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
              '¿Está seguro de cambiar de activo a desactivado al usuario ${user.userName} ?'),
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
            // print(user.person.idUser);
            print(user.idUser);
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
