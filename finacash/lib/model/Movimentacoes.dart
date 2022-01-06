import 'package:finacash/constants/database_constants.dart';

class Movimentacoes {
  int id;
  String data;
  double valor;
  String tipo;
  String descricao;

  Movimentacoes();

  Movimentacoes.fromMap(Map map) {
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      valorColumn: valor,
      dataColumn: data,
      tipoColumn: tipo,
      descricaoColumn: descricao,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  String toString() {
    return "Movimentações(id: $id, valor: $valor, data: $data, tipo: $tipo, desc: $descricao, )";
  }
}
