// class User {
//   int idUser;
//   int status;
//   String userName;
//   String? lastname;
//   String? surname;
//   String? name;
//   String email;
//   String password;
//   String turn;
//   String rolName;
//   int idRol;
//   int idHotel;

//   User(this.idUser,this.status,this.userName,this.email,this.password,this.turn,this.rolName,this.idRol,this.idHotel);
// }
import 'package:geco_mobile/modules/cleaning_staff/entities/person.dart';
import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';
import 'package:geco_mobile/modules/roles/entities/Rol.dart';

class User {
  int idUser;
  String email;
  String password;
  String username;
  int turn;
  int status;
  Person idPerson;
  Rol idRol;
  Hotel idHotel;
  User(this.idUser, this.email, this.password, this.username, this.turn,
      this.status, this.idPerson, this.idRol, this.idHotel);

  static User fromJson(usuario) {
    return User(
      usuario['idUser'] ?? 0,
      usuario['email'],
      usuario['password'],
      usuario['username'],
      usuario['turn'] ?? 0,
      usuario['status'] ?? 0,
      Person.fromJson(usuario['idPerson']),
      Rol.fromJson(usuario['idRol']),
      Hotel.fromJson(usuario['idHotel']),
    );
  }
}



