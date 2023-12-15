import 'package:geco_mobile/modules/gerente/user/entities/person.dart';
import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';
import 'package:geco_mobile/modules/roles/entities/Rol.dart';

class User {
  int? idUser;
  String? email;
  String? password;
  String? username;
  int? turn;
  int? status;
  Person? idPerson;
  Rol? idRol;
  Hotel? idHotel;
  User(this.idUser, this.email, this.password, this.username, this.turn,
      this.status, this.idPerson, this.idRol, this.idHotel);

  static User fromJson(usuario) {
    return User(
      usuario['idUser'] ?? 0,
      usuario['email'] ?? '',
      usuario['password'] ?? '',
      usuario['username'] ?? '',
      usuario['turn'] ?? 0,
      usuario['status'] ?? 0,
      Person.fromJson(usuario['idPerson'] ?? {}),
      Rol.fromJson(usuario['idRol'] ?? {}),
      Hotel.fromJson(usuario['idHotel'] ?? {}),
    );
  }
  static User defaultUser() {
    return User(
      0,'','','',0,0,Person.defaulPerson(),Rol.defaultRol(),Hotel.defaulHotel()
    );
  }

  static List<User> fromListJson(habitacion) {
    List<User> users = [];
    if (habitacion != null) {
      for (var user in habitacion) {
        users.add(User.fromJson(user));
      }
    }
    return users;
  }
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
