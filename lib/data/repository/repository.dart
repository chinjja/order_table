import 'package:order_table/data/models/located_image_path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Repository {
  static const String table = 'located_image_path';
  Database? _db;
  final String? _databasePath;

  Repository([this._databasePath]);

  Future<void> open() async {
    _db = await databaseFactoryFfi
        .openDatabase(_databasePath ?? inMemoryDatabasePath);
    await _db!.transaction((txn) async {
      await txn.execute(
        '''create table if not exists $table (
          id integer primary key,
          path text not null,
          width real not null,
          height real not null,
          x real not null,
          y real not null,
          sx real not null,
          sy real not null
          )''',
      );
    });
  }

  Future<void> close() async {
    await _db?.close();
  }

  Future<LocatedImagePath> save(LocatedImagePath obj) async {
    return _db!.transaction((txn) async {
      int id = await txn.insert(
        table,
        obj.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return obj.copyWith(id: id);
    });
  }

  Future<LocatedImagePath?> get(int id) async {
    final list = await _db!.query(table, where: 'id = ?', whereArgs: [id]);
    if (list.isEmpty) return null;
    return LocatedImagePath.fromMap(list.first);
  }

  Future<List<LocatedImagePath>> all() async {
    final list = await _db!.query(table);
    return list.map((e) => LocatedImagePath.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    _db!.transaction((txn) async {
      txn.delete(table, where: 'id = ?', whereArgs: [id]);
    });
  }
}
