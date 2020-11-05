import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  DocumentReference reference;
  int id; //this will probably be deleted but I'm leaving it for now
  String image;
  String firstName;
  String lastName;
  DateTime missingSince;

  Person(this.id);

  Map<String, dynamic> toMap() => {
        'id': id,
        'image': image,
        'firstName': firstName,
        'lastName': lastName,
        'missingSince': missingSince
      };

  Person.fromMap(Map<String, dynamic> map, {this.reference}) {
    id = map['id'];
    image = map['image'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    Timestamp time = map['missingSince'];
    missingSince = time.toDate();
  }
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
          id INTEGER UNIQUE
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
    try { 
      await db.insert("people", person.toMap());
    } catch (error) {
      return error;
    }

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
