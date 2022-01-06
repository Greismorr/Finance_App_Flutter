import 'package:finacash/constants/database_constants.dart';
import 'package:finacash/model/Movimentacoes.dart';
import 'package:finacash/model/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovimentacoesRepository {
  static final MovimentacoesRepository _instance =
      MovimentacoesRepository.internal();
  factory MovimentacoesRepository() => _instance;
  MovimentacoesRepository.internal();
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "movimentacao.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $movimentacaoTABLE ("
              "$idColumn INTEGER PRIMARY KEY," +
          "$valorColumn FLOAT," +
          "$dataColumn TEXT," +
          "$tipoColumn TEXT," +
          "$descricaoColumn TEXT," +
          "$fkUserId INTEGER, "
              "FOREIGN KEY($fkUserId) REFERENCES $usersTABLE(idColumn)"
              ")");

      await db.execute("CREATE TABLE $usersTABLE(" +
          "$idColumn INTEGER PRIMARY KEY," +
          "$nomeColumn TEXT)");

      await db.insert(usersTABLE, User(nome: "FinaCash").toMap());
    });
  }

  Future<Movimentacoes> saveMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada save");
    Database dbMovimentacoes = await db;
    movimentacoes.id =
        await dbMovimentacoes.insert(movimentacaoTABLE, movimentacoes.toMap());
    return movimentacoes;
  }

  Future<User> saveUser(User user) async {
    print("chamada save");
    Database dbMovimentacoes = await db;
    user.id = await dbMovimentacoes.insert(usersTABLE, user.toMap());
    return user;
  }

  Future<Movimentacoes> getMovimentacoes(int id) async {
    Database dbMovimentacoes = await db;
    List<Map> maps = await dbMovimentacoes.query(movimentacaoTABLE,
        columns: [
          idColumn,
          valorColumn,
          dataColumn,
          tipoColumn,
          descricaoColumn
        ],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Movimentacoes.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User> getUser() async {
    Database dbMovimentacoes = await db;
    List<Map> maps = await dbMovimentacoes.query(usersTABLE,
        columns: [
          idColumn,
          nomeColumn,
        ],
        where: "$idColumn =?",
        whereArgs: [1]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovimentacao(Movimentacoes movimentacoes) async {
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.delete(movimentacaoTABLE,
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<int> updateMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada update");
    print(movimentacoes.toString());
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.update(
        movimentacaoTABLE, movimentacoes.toMap(),
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<int> updateUser(User user) async {
    print("chamada update");
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.update(usersTABLE, user.toMap(),
        where: "$idColumn =?", whereArgs: [user.id]);
  }

  Future<List> getAllMovimentacoes() async {
    Database dbMovimentacoes = await db;
    List listMap =
        await dbMovimentacoes.rawQuery("SELECT * FROM $movimentacaoTABLE");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorMes(String data) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%'");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorTipo(String tipo) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $tipoColumn ='$tipo' ");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<int> getNumber() async {
    Database dbMovimentacoes = await db;
    return Sqflite.firstIntValue(await dbMovimentacoes
        .rawQuery("SELECT COUNT(*) FROM $movimentacaoTABLE"));
  }

  Future close() async {
    Database dbMovimentacoes = await db;
    dbMovimentacoes.close();
  }
}
