
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_example/Table/database.dart';

class DatabaseHelper{
  String dbName = 'User.db';
  String table = 'User';
  String id = 'id';
  String name = 'name';
  String description = 'description';
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper databaseHelper = DatabaseHelper.privateConstructor();

  Database _database;

  Future<Database> get _createDatabase async{
  String path = join(await getDatabasesPath(), dbName);
  _database = await openDatabase( path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
      });
  return _database;
  }

  Future<int> insert(User user)async{
    Database db = await databaseHelper._createDatabase;
    var res =db.insert(table, user.toMap());
    return res;
  }

  Future<List<Map<String,dynamic>>> getallrecord() async
  {
    Database db = await databaseHelper._createDatabase;
    var res=db.query(table);
    return res;
  }

  Future<int> delete(int ids)async{
    Database db = await databaseHelper._createDatabase;
    var res=db.delete(table,where: '$id=?',whereArgs: [ids]);
    return res;
  }

  Future<int>update(User u)async{
    Database db = await databaseHelper._createDatabase;
    int id=u.toMap()['id'];
    var res=db.update(table, u.toMap(),where:'id=?',whereArgs:[id]);
    return res;
  }

}