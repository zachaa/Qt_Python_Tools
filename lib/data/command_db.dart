import 'dart:io' as io;
import 'package:flutter/foundation.dart' as foundation;
import 'package:path/path.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
// import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'commands_model.dart';

class QtCommandDatabase {
  ///global field
  static final QtCommandDatabase instance = QtCommandDatabase._init();

  static Database? _database;

  ///private constructor
  QtCommandDatabase._init();

  /// Gives the path to a location where the database should be located.
  /// It should be the same as SharedPreferences.json in C:\Users\NAME\AppData\Roaming
  Future<String?> _getDatabasePath() async{
    PathProviderWindows pathProvider = PathProviderWindows();
    final String? appDataPath = await pathProvider.getApplicationSupportPath();
    return appDataPath;
  }

  ///get database if it exists or open a new connection if it does not
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDB('qt_commands.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // This should be the same path as SharedPreferences
    String? dbPath;
    if (foundation.kDebugMode){
      dbPath = io.Directory.current.path; // USER\IdeaProjects\qt_python_tools
    } else {
      dbPath = await _getDatabasePath(); // AppData\Roaming\qtPythonTools\qt_pyt
    }

    dbPath ??= io.Directory.current.path; // If getDatabasePath failed
    final path = join(dbPath, filePath);
    print(path);
    // sqflite does not support desktop so we have to use sqflite_common
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbOptions = OpenDatabaseOptions(version: 1, onCreate: _dbOnCreate);
    return await databaseFactory.openDatabase(path, options: dbOptions);
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
 ${QtCmdFields.cmdOptions} $textType,
 ${QtCmdFields.cmdPyQtOptions} $textType,
 ${QtCmdFields.cmdPySideOptions} $textType)""");
    batch.execute("""
CREATE TABLE $tableRcc(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdOptions} $textType,
 ${QtCmdFields.cmdPyQtOptions} $textType,
 ${QtCmdFields.cmdPySideOptions} $textType)""");
    batch.execute("""
CREATE TABLE $tableLUpdate(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdOptions} $textType,
 ${QtCmdFields.cmdPyQtOptions} $textType,
 ${QtCmdFields.cmdPySideOptions} $textType)""");
    batch.execute("""
CREATE TABLE $tableLRelease(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdOptions} $textType,
 ${QtCmdFields.cmdPyQtOptions} $textType,
 ${QtCmdFields.cmdPySideOptions} $textType)""");
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

  /// Deletes and recreates a table (needs to reset the primary key)
  Future<void> clearTable(String table) async {
    final db = await instance.database;
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    db.execute("DROP TABLE IF EXISTS $table");
    db.execute("""
CREATE TABLE $table(
 ${QtCmdFields.id} $idType, 
 ${QtCmdFields.projectName} $textType,
 ${QtCmdFields.itemName} $textType,
 ${QtCmdFields.pathInput} $textType,
 ${QtCmdFields.pathOutput} $textType,
 ${QtCmdFields.cmdOptions} $textType,
 ${QtCmdFields.cmdPyQtOptions} $textType,
 ${QtCmdFields.cmdPySideOptions} $textType)""");
  }

  /// Closes the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}