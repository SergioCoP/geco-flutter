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

  void filtrarUsuario(String query) {
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      _listUsuarios?.then((data) {
        setState(() {
          List<User> usuariosFiltrados = data.where((user) {
            return user.userName.toLowerCase().contains(query) ||
                user.rolName.toLowerCase().contains(query);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de usuarios'),
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              print('Boton de deslogueo asies jaja');
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
          ),
        ],
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Ha sucedido un error maquiavelico.");
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
                      return const IsEmpty();
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
                          Navigator.of(context)
                              .pushNamed('/manager/users/register');
                        },
                        child: const Icon(Icons.add)),
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
