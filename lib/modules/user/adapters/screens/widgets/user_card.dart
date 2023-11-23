import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_management.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserCard extends StatefulWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: const Color.fromARGB(118, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: SizedBox(
        child: Column(
          children: <Widget>[
            //Qui está el idUser del usuario
            Container(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: 
                  // widget.user.status == 1
                  //     ? 
                      ColorsApp.buttonPrimaryColor
                      // : ColorsApp.buttonCancelColor,
                ),
                child: Text(
                  '# ${widget.user.idUser}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            //Aqui està el nombre de usuario
            Container(
              height: 80,
              padding: const EdgeInsets.all(7),
              child: Text(
                widget.user.userName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              //Aqui estàn los botones
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container( //Bton de info
                    margin: const EdgeInsets.all(1),
                    child: MaterialButton(
                      onPressed: () {
                         Navigator.of(context).pushNamed('/manager/users/update',arguments: {'idUser':widget.user.idUser});
                      },
                      minWidth: 50.0,
                      color: ColorsApp.infoColor,
                      child: const Icon(Icons.edit_document),
                    ),
                  ),
                  Container( //Bton de cambiar estado
                    margin: const EdgeInsets.all(1),
                    child: MaterialButton(
                      onPressed: () {
                        cambiarEstadoUser(context, widget.user);
                      },
                      minWidth: 50.0,
                      color:
                      //  widget.user.status > 0
                          // ? ColorsApp.buttonCancelColor
                          // :
                           ColorsApp.buttonPrimaryColor,
                      child: const Icon(Icons.swap_horizontal_circle),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}