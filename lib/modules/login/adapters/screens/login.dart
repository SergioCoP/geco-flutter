import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
// import 'package:geco_mobile/kernel/widgets/navigation/menu_manager.dart';
// import 'package:geco_mobile/modules/room/adapters/screens/room_dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    //Image.asset('assets/images/geco_logo.png',width: 150,height: 150,),
    return Scaffold(
        body: Column(
      children: <Widget>[
        // ignore: avoid_unnecessary_containers
        Container(
          child: Container(
            alignment: Alignment.center,
            height: 150,
            color: ColorsApp.primaryColor,
            child: Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(48),
                  child: Image.asset(
                    'assets/images/geco_logo.png',
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              color: ColorsApp.secondaryColor,
              child: Container(
                alignment: Alignment.center,
                child: _FormCard(),
              )),
        ),
      ],
    ));
  }
}

class _FormCard extends StatefulWidget {
  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field, prefer_final_fields
  bool _isButtonDisabled = true;

  final TextEditingController _email = TextEditingController(text: '');

  final TextEditingController _password = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            margin: const EdgeInsets.all(15),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    onChanged: () {},
                    child: Column(children: <Container>[
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  "Usuario",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _email,
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Text(
                                "Contraseña",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _password,
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  onPressed: () {},
                                  child: const Text('Recuperar Contraseña'),
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      minimumSize: const Size(400, 60),
                                      backgroundColor:
                                          ColorsApp.secondaryColor),
                                  onPressed: () {
                                     Navigator.pushReplacementNamed(context, '/personal_cleaner');
                                    // Navigator.of(context).pushNamed('/rooms');
                                    // Navigator.pushReplacementNamed(context, '/manager');
                                  },
                                  child: const Text('Iniciar'),
                                ),
                              )
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 15),
                                      foregroundColor: Colors.black),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/registerUser');
                                  },
                                  child: const Text(
                                      '¿No tienes una cuenta?, Registrate'),
                                ),
                              )
                            ],
                          )),
                    ]))
              ],
            )),
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "GECO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  "@ SCP S.A de C.V 2023",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
