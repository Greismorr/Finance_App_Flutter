import 'package:finacash/constants/database_constants.dart';

class User {
  int id;
  String nome;

  User({this.nome});

  User.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
