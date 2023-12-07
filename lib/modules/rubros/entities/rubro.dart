import 'package:geco_mobile/modules/hotels/entities/Hotel.dart';

class Rubro {
  int idEvaluationItem;
  String name;
  int status;
  Hotel idHotel;

  Rubro(this.idEvaluationItem, this.name, this.status, this.idHotel);

  static Rubro fromJson(rubro){
    return Rubro(
      rubro['idEvaluationItem'],
      rubro['name'],
      rubro['status'],
      Hotel.fromJson(rubro['idHotel'])
    );
  }
}
