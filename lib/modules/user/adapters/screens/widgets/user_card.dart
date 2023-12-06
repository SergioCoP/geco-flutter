import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserCard extends StatefulWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool status = false;

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
                          widget.user.userName,
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
                        '${roles[widget.user.idRol] ?? 'Sin definir'}',
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
                            // setState(() async {
                            // final dio = Dio();
                            // final _path = GlobalData.pathUserUri;
                            // Response response;
                            // response = await dio.put('$_path/status',
                            //     data: {'idUser': widget.user.idUser});
                            // if (response.data['msg'] == 'update') {
                            //   setState(() {
                            //     widget.rubro.status = switchStatus ? 1 : 0;
                            //     switchStatus = value;
                            //   });
                            // }
                            // });
                            setState(() {
                              status = value;
                              widget.user.status = status ? 1 : 0;
                            });
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
                                                          widget.user.userName,
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
                                                      text: widget.user.rolName,
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
