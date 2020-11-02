import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Person {
  int id;

  Person(this.id);

  Map<String, dynamic> toMap() => {
        'id': id
      };
}

class PeopleModel with ChangeNotifier {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'people.db'),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE people (
          id INTEGER
        )
        ''');
    }, version: 1);
  }

  Future<List> getAllPeople() async {
    final db = await database;
    var res = await db.query("people");

    if (res.length == 0)
      return null;
    else {
      return res;
    }
  }

  insertPeople(Person person) async {
    final db = await database;
    await db.insert("people", person.toMap());

    notifyListeners();
  }

  deletePeopleId(int id) async {
    final db = await database;
    await db.delete(
      "people",
      where: 'id = ?',
      whereArgs: [id],
    );

    notifyListeners();
  }
}
