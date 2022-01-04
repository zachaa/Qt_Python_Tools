import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '/commands_model.dart';

class QtCommandDatabase {
  ///global field
  static final QtCommandDatabase instance = QtCommandDatabase._init();

  static Database? _database;

  ///private constructor
  QtCommandDatabase._init();

  ///get database if it exists or open a new connection if it does not
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDB('qt_commands.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _dbOnCreate);
  }

  /// Create the database tables, runs first time only.
  Future _dbOnCreate(Database db, version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    Batch batch = db.batch();
    batch.execute("""
CREATE TABLE $tableUic(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdExtraArgs} $textType)""");
    batch.execute("""
CREATE TABLE $tableRcc(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdExtraArgs} $textType)""");
    batch.execute("""
CREATE TABLE $tableLUpdate(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdExtraArgs} $textType)""");
    batch.execute("""
CREATE TABLE $tableLRelease(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdExtraArgs} $textType)""");
    await batch.commit();
  }

  /// Function that inserts QtCommands into the database.
  Future<void> insertQtCommand(QtCommand qtCommand, String table,) async {
    final db = await instance.database;
    // Insert the QtCommand into the correct table. Replace any previous data.
    await db.insert(
      table,
      qtCommand.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves 1 QtCommand from the desired table.
  Future<QtCommand> readCommand(int id, String table) async {
    final db = await instance.database;

    final maps = await db.query(
      table,
      columns: QtCmdFields.values,
      where: '${QtCmdFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return QtCommand.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Retrieves all the QtCommands from the desired table.
  Future<List<QtCommand>> readAllCommands(String table) async {
    final db = await instance.database;

    final result = await db.query(table);
    return result.map((mapping) => QtCommand.fromMap(mapping)).toList();
  }

  /// Updates a QtCommand in the desired table.
  Future<int> updateQtCommand(QtCommand qtCommand, String table) async {
    final db = await instance.database;

    return db.update(
      table,
      qtCommand.toMap(),
      // Ensure that the command has a matching id.
      where: '${QtCmdFields.id} = ?',
      // Pass the QtCommand's id as a whereArg to prevent SQL injection.
      whereArgs: [qtCommand.id],
    );
  }

  /// Delete a QtCommand from the desired table.
  Future<int> deleteQtCommand(int id, String table) async {
    final db = await instance.database;

    return await db.delete(
      table,
      where: '${QtCmdFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}