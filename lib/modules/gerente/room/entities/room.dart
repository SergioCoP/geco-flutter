import 'package:geco_mobile/modules/gerente/type_rooms/entities/type_room.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';

class Room {
  int idRoom;
  int roomNumber;
  String name;
  TypeRoom idTypeRoom;
  int status;
  List<User> users;
  Hotel idHotel;

  Room(this.idRoom, this.roomNumber, this.name, this.idTypeRoom, this.status,
      this.users, this.idHotel);

  static Room fromJson(habitacion) {
    return Room(
      habitacion['idRoom'],
      habitacion['roomNumber'] ?? '',
      habitacion['name'] ?? 'Habitación-${habitacion['idRoom']}',
      TypeRoom.fromJson(habitacion['idTypeRoom']??{}),
      habitacion['status'],
      User.fromListJson(habitacion['users'] ?? []),
      Hotel.fromJson(habitacion['idHotel'] ?? {}),
    );
  }
  

}
