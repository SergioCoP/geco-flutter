import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';
import 'package:geco_mobile/modules/rubros/entities/rubro.dart';

class TypeRoom {
  int idTypeRoom;
  String name;
  Hotel idHotel;
  List<Rubro> rubros;
  TypeRoom(
      {required this.idTypeRoom,
      required this.name,
      required this.idHotel,
      required this.rubros});

  static TypeRoom fromJson(typeRoom) {
    return TypeRoom(
        idTypeRoom: typeRoom['idTypeRoom'],
        name: typeRoom['name'],
        idHotel: Hotel.fromJson(typeRoom['idHotel']),
        rubros: Rubro.fromListJson(typeRoom['evaluationItems']));
  }

  toJson() {
    return {
      'idTypeRoom': idTypeRoom,
      'name': name,
      'idHotel': idHotel.toJson(),
      'evaluationItems': Rubro.toListJson(rubros)
    };
  }
}
