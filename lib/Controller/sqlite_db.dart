import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB{
  static const String _dbName = "bitp3453_bmi";
  static const String _tblName= "bmi";
  static const String _colUsername = "username";
  static const String _colWeight = "weight";
  static const String _colHeight = "height";
  static const String _colGender = "gender";
  static const String _colStatus = "bmi_status";

  Database? _db;

  // Constructor
  SQLiteDB._();
  static final SQLiteDB _instance = SQLiteDB._();

  factory SQLiteDB(){
    return _instance;
  }

  Future<Database> get database async {
    if(_db != null){
      return _db!;
    }

    String path = join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
        path,
        version: 1,
        onCreate: (createdDb, version) async {
          for(String tableSql in SQLiteDB.createTableSQL){
            await createdDb.execute(tableSql);
          }
        }
    );
    return _db!;
  }

  static List<String> createTableSQL = [
    '''
      CREATE TABLE IF NOT EXISTS $_tblName (
        $_colUsername VARCHAR(65) NOT NULL,
        $_colWeight DOUBLE(8,2) NOT NULL,
        $_colHeight DOUBLE(8,2) NOT NULL,
        $_colGender VARCHAR(65) NOT NULL,
        $_colStatus VARCHAR(255) NOT NULL
      )
      ''',
  ];

  // save bmi
  Future<int> insert(String tableName, Map<String, dynamic> rowValue) async {
    try{
      Database db = await _instance.database;
      return await db.insert(tableName, rowValue);
    }
    catch(e){
      print("Error inserting data: $e");
      throw e;
    }
  }

  // get previous added bmi
  Future<Map<String, dynamic>> getLast(String tableName) async {
    try{
      Database db = await _instance.database;
      List<Map<String, dynamic>> results =  await db.query(tableName);
      return results.last;
    }
    catch(e){
      print("Error querying data: $e");
      throw e;
    }
  }
}