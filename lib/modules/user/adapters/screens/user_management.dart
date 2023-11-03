import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/user/adapters/screens/widgets/user_card.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final double heightOfFirstContainer = 150.0;
  final double brCards = 40.0;

  List<Map> usersData = [
    {
      'idUser': 1,
      'status': 1,
      'idPerson': {
        'name': 'Alberto',
        'lastname': 'Quiñonez',
        'surname': 'Bahena'
      }
    },
    {
      'idUser': 1,
      'status': 0,
      'idPerson': {'name': 'Sergio', 'lastname': 'Montes', 'surname': 'De Oca'}
    },
  ];
  List<Map> filteredUsersData = [];

  List<Widget> cardList = [];

  @override
  void initState() {
    super.initState();
    filteredUsersData = List.from(usersData);
    for (var user in filteredUsersData) {
      final status = user['status'] > 0 ? true : false;
      var name = user['idPerson']['name'];
      var lastname = user['idPerson']['lastname'];
      var surname = user['idPerson']['surname'];
      var fullName = '$name $lastname $surname';
      UserCard card =
          UserCard(name: fullName, uid: user['idUser'], isActive: status);
      cardList.add(card);
    }
  }

  void filtrarUsuario(String query) {
    query = query.toLowerCase();
    setState(() {
      try {
        List<Map> usersTemp = [];
        List<Widget> cardTemp = [];
        for (var user in usersData) {
          var name = user['idPerson']['name'];
          var lastname = user['idPerson']['lastname'];
          var surname = user['idPerson']['surname'];
          var fullName = '$name $lastname $surname';
          if (fullName.toString().toLowerCase().contains(query)) {
            usersTemp.add(user);
          }
        }
        filteredUsersData = List.from(usersTemp);

        for (var user in filteredUsersData) {
          final status = user['status'] > 0 ? true : false;
          var name = user['idPerson']['name'];
          var lastname = user['idPerson']['lastname'];
          var surname = user['idPerson']['surname'];
          var fullName = '$name $lastname $surname';
          UserCard card =
              UserCard(name: fullName, uid: user['idUser'], isActive: status);
          cardTemp.add(card);
        }
        cardList = List.from(cardTemp);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Stack(
        children: [
          //Aqui van todas las cards
          Scaffold(
              body: Container(
            margin: const EdgeInsets.only(
              top: 120,
            ),
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              children: cardList,
            ),
          )),

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
                            onPressed: () {}, child: const Icon(Icons.add)),
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
                        labelText: 'Buscar',
                        hintText: 'Escribe aquí para buscar',
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

/**
  List usersData = [
    {'idUser':1,'status':1,'idPerson':{'name':'Alberto','lastname':'Quiñonez','surname':'Bahena'}},
  ];
  List filteredUsersData = [];
  List<Widget> cardList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   try {
  //     const path = 'http://192.168.1.73:8080';
  //     final dio = Dio();
  //     final response = await dio.get('$path/getUsers');
  //     if (response.data != null) {
  //       setState(() {
  //         usersData = response.data;
  //         filteredUsersData = usersData;
  //         for (var user in usersData) {
  //           final status = user['status'] > 0 ? true : false;
  //           var fullName =
  //               '$user["idPerson"]["name"] $user["idPerson"]["surname"] $user["idPerson"]["lastname"]';
  //           UserCard card =
  //               UserCard(name: fullName, uid: user['idUser'], isActive: status);
  //           cardList.add(card);
  //           print(cardList);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
class IsEmpty extends StatelessWidget {
  const IsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('No hay ningun usuario registrado Actualmente :)');
  }
}

 */