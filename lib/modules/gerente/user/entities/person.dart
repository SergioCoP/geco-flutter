class Person {
  int idPerson;
  String name;
  String? surname;
  String lastname;

  Person(this.idPerson, this.name, this.surname, this.lastname);

  static Person fromJson(person) {
    return Person(
      person['idPerson'] ?? 0,
      person['name'] ?? '',
      person['surname'] ?? '',
      person['lastname'] ?? '',
    );
  }

  static Person? defaulPerson() {
    return Person(0, '', '', '');
  }
}
