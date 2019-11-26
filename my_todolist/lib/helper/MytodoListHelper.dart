import 'package:my_todolist/model/Notas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyTodoListHelper {
  static final String nomeTabela = "notas";
  static final MyTodoListHelper _myTodoListHelper = MyTodoListHelper._internal();

  Database _db;

  factory MyTodoListHelper() {
    return _myTodoListHelper;
  }

  MyTodoListHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_myTodoList.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "lista TEXT," +
            "anotacao TEXT, " +
            "data DATETIME)";

    await db.execute(sql);
  }

  Future<int> salvarLista(Notas notas) async {
    var bancoDados = await db;

    int result = await bancoDados.insert(nomeTabela, notas.toMap());
    return result;
  }

  Future<int> salvarNota(Notas notas) async {
    var bancoDados = await db;
    int result = await bancoDados.insert(nomeTabela, notas.toMap());
    return result;
  }

  recuperarLista() async {
    var bancoDados = await db;
    String sql = "SELECT DISTINCT lista FROM $nomeTabela ORDER BY data ASC";
    List lista = await bancoDados.rawQuery(sql);

    return lista;
  }

  recuperarItens(String nomeLista) async {
    var bancoDados = await db;
    String sql =
        "SELECT id,anotacao FROM $nomeTabela where lista = '$nomeLista' and anotacao not in('null') ORDER BY data ASC";
    List lista = await bancoDados.rawQuery(sql);

    return lista;
  }

  //Usar depois
  recuperarAllItens() async {
    var bancoDados = await db;
    String sql =
        "SELECT * FROM $nomeTabela where anotacao not in('null') ORDER BY data ASC";
    List lista = await bancoDados.rawQuery(sql);

    return lista;
  }

  removerLista(String nomeLista) async {
    var bancoDados = await db;
    String sql = "DELETE FROM $nomeTabela where lista = '$nomeLista' ;";
    return await bancoDados.rawQuery(sql);
  }

  editarNota(Notas nota) async {
    print("****** Editar SQL *****");
    print("${nota.id}");
    var bancoDados = await db;
    String sql =
        "UPDATE $nomeTabela SET anotacao = '${nota.nota}' WHERE id = ${nota.id} ;";
    return await bancoDados.rawQuery(sql);
  }

  editarLista(Notas nota, String nomeListaAnterior) async {
    var bancoDados = await db;
    String sql =
        "UPDATE $nomeTabela SET lista = '${nota.lista}' where lista = '$nomeListaAnterior';";
    return await bancoDados.rawQuery(sql);
  }

  Future<int> removerItem(int id) async {
    var bancoDados = await db;
    return await bancoDados
        .delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }
}
