import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class UserCard extends StatefulWidget {
  final String name;
  final int uid;
  final bool isActive;

  const UserCard(
      {super.key,
      required this.name,
      required this.uid,
      required this.isActive});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shadowColor: const Color.fromARGB(118, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: SizedBox(
        height: 300,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isActive
                      ? ColorsApp.buttonPrimaryColor
                      : ColorsApp.buttonCancelColor,
                ),
                child: Text(
                  '# ${widget.uid}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            //Aqui està el nombre de usuario
            Container(
              height: 90,
              padding: const EdgeInsets.all(5),
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              //Aqui estàn los botones
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/user/showUser',
                          arguments: {'data': widget.uid},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.infoColor,
                      ),
                      child: const Icon(Icons.edit_document),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          'user/changeStatusUser',
                          arguments: {'data': widget.uid},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isActive
                            ? ColorsApp.buttonCancelColor
                            : ColorsApp.buttonPrimaryColor,
                      ),
                      child: const Icon(Icons.swap_horizontal_circle),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/updateUser',
                          arguments: {'data': widget.uid},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.infoColor,
                      ),
                      child: const Icon(Icons.edit),
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
