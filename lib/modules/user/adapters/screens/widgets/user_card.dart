import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserCard extends StatefulWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool status = false;
  final dio = Dio();
  final path = GlobalData.pathUserUri;
  bool setOneTime = false;
  List roles = [
    "",
    "Gerente",
    "Recepcionista",
    "Personal de limpieza",
    "Sin definir",
    "Sin definir",
    "Sin definir",
    "Sin definir",
  ];

  Future<void> cambiarEstado() async {
    final response = await dio.put('$path/status/${widget.user.idUser}');
    if (response.data['status'] == 'OK') {
      print(response.data['status']);
      setState(() {
        widget.user.status = status ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    status = widget.user.status == 1 ? true : false;
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Colors.white,
      shadowColor: const Color.fromARGB(118, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 200.0,
                        height: 105.0,
                        child: Text(
                          //Nombre del usuario
                          '${widget.user.idPerson.name} ${widget.user.idPerson.surname} ${widget.user.idPerson.lastname}',
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        "Rol: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ///EL ROL DEL USUARIO
                        '${roles[widget.user.idRol.idRol] ?? 'Sin definir'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    ///SIWTCH Y LOS BOTONES
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Switch(
                          value: status,
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.red,
                          inactiveThumbColor: Colors.red.shade100,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          onChanged: (value) {
                            status = value;
                            cambiarEstado();
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            //Bton de info
                            margin: const EdgeInsets.all(1),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      '/manager/users/update',
                                      arguments: {
                                        'idUser': widget.user.idUser
                                      });
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            //Bton de cambiar estado
                            margin: const EdgeInsets.all(1),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Informacion del usuario"),
                                        content: SizedBox(
                                          height: 200.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Nombre de usuario: \n',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          widget.user.username,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),

                                              ///---------------------------
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      'Correo electrónico: \n',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: widget.user.email,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),

                                              ///---------------------------
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Rol: \n',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: widget
                                                          .user.idRol.name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),

                                              ///---------------------------
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cerrar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.info_outline_rounded),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
