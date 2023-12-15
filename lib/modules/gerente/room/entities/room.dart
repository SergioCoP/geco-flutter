import 'package:geco_mobile/modules/gerente/type_rooms/entities/type_room.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';

class Room {
  int idRoom;
  int roomNumber;
  String name;
  TypeRoom idTypeRoom;
  int status;
  // User? user1;
  // User? user2;
  List users;
  Hotel idHotel;

  Room(this.idRoom, this.roomNumber, this.name, this.idTypeRoom, this.status,
      this.users, this.idHotel);

  static Room fromJson(habitacion, List<User> users) {
    return Room(
      habitacion['idRoom'] ?? 0,
      habitacion['roomNumber'] ?? 0,
      habitacion['name'] ?? 'NC-${habitacion['idRoom']}',
      TypeRoom.fromJson(habitacion['idTypeRoom'] ?? {}),
      habitacion['status'] ?? 0,
      users,
      // habitacion['firstIdUser'] ?? 0,
      // habitacion['secondIdUser'] ?? 0,
      // User.fromJson(habitacion['firstIdUser'] ?? User.defaultUser()),
      // User.fromJson(habitacion['secondIdUser'] ?? User.defaultUser()),
      Hotel.fromJson(habitacion['idHotel'] ?? Hotel.defaulHotel()),
    );
  }
}
