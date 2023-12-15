import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/adapters/screens/type_rooms_update.dart';
import 'package:geco_mobile/modules/gerente/type_rooms/entities/type_room.dart';

// ignore: must_be_immutable
class TypeRoomCard extends StatefulWidget {
  TypeRoom typeRoom;
  TypeRoomCard(
    this.typeRoom, {
    super.key,
  });

  @override
  State<TypeRoomCard> createState() => _TypeRoomCardState();
}

class _TypeRoomCardState extends State<TypeRoomCard> {
  bool switchStatus = false;

  @override
  Widget build(BuildContext context) {
    // switchStatus = widget.typeRoom.status == 1 ? true : false;
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: Text(
                widget.typeRoom.name,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            Ink(
              decoration: ShapeDecoration(
                color: Colors.lightBlue,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TypeRoomUpdate(),
                      settings: RouteSettings(
                        arguments: {'idTypeRoom': widget.typeRoom.idTypeRoom},
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Ink(
              decoration: ShapeDecoration(
                color: Colors.lightBlue,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: () {
                  showInfo(context, widget.typeRoom);
                },
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}

void showInfo(BuildContext context, TypeRoom typeRoom) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Información'),
        actions: [
          ElevatedButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nombre:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              typeRoom.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Rubros seleccionados:',
              style: TextStyle(fontSize: 20.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(typeRoom.rubros.length, (index) {
                return Text(
                  typeRoom.rubros[index].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}
