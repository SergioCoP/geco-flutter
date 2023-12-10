class Hotel {
  int idHotel;
  String name;
  String primaryColor;
  String secondaryColor;
  String imageUrl;
  Hotel(this.idHotel, this.name, this.primaryColor, this.secondaryColor,
      this.imageUrl);

  static Hotel fromJson(idHotel) {
    return Hotel(
      idHotel['idHotel'] ?? 0,
      idHotel['name'],
      idHotel['primaryColor'],
      idHotel['secondaryColor'],
      idHotel['imageUrl'],
    );
  }

  toJson() {
    return {
      'idHotel': idHotel,
      'name': name,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'imageUrl': imageUrl,
    };
  }
}
