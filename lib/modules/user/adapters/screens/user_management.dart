import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/user/adapters/screens/widgets/user_card.dart';
import 'package:geco_mobile/modules/user/entities/person.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final double heightOfFirstContainer = 200.0;
  final double brCards = 50.0;
  final path = 'http://192.168.1.75:8080';
  Future<List<User>>? _listUsuarios;
  Future<List<User>>? _listUsuariosRespaldo;

  Future<List<User>> obtenerUsuariosFetch() async {
    List<User> usuarios = [];
    final dio = Dio();
    final response = await dio.get('$path/getUsers');
    if (response.statusCode == 200) {
      for (var user in response.data) {
        usuarios.add(User(
            user["idUser"],
            user["status"],
            Person(user["idPerson"]["name"], user["idPerson"]["lastname"],
                user["idPerson"]["surname"])));
      }
      return usuarios;
    } else {
      throw Exception("Fallà la peticiòn");
    }
  }

  List<Widget> crearCards(List<User> data) {
    List<UserCard> userCards = [];
    for (var user in data) {
      userCards.add(UserCard(user: user));
    }
    return userCards;
  }

  @override
  void initState() {
    super.initState();
    _listUsuarios = obtenerUsuariosFetch();
    _listUsuariosRespaldo = _listUsuarios;
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
          final fullName =
              "${user.person?.name} ${user.person?.lastname} ${user.person?.surname}"
                  .toLowerCase();
          return fullName.contains(query);
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
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Stack(
        children: [
          Scaffold(
            body: Container(
              margin: const EdgeInsets.only(
                top: 140,
              ),
              child: FutureBuilder(
                future: _listUsuarios,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                      children: crearCards(snapshot.data),
                    );
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          "Gestión de usuarios",
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.buttonPrimaryColor,
                            ),
                            onPressed: () {},
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (text) {
                        filtrarUsuario(text.toString());
                      },
                      decoration: const InputDecoration(
                        labelText: 'Buscar usuario',
                        hintText: 'Escribe aquí para buscar a un usuario',
                      ),
                    ),
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

cambiarEstadoUser(context, User user) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Dar de baja a un usuario"),
      content: Text(
          '¿Está seguro de cambiar de activo a desactivado al usuario ${user.person!.name} ?'),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorsApp.buttonPrimaryColor,
          child: const Text('Cancelar'),
        ),
        MaterialButton(
          onPressed: () {
            print(user.person!.name);
            Navigator.pop(context);
          },
          color: ColorsApp.buttonCancelColor,
          child: const Text('Dar de baja', style: TextStyle(color: Colors.white),),
        )
      ],
    ),
  );
}
