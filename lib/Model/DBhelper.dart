import 'dart:io';
import 'dart:async';
import 'package:notepade/Model/Note.dart';
import 'package:notepade/Model/Photo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBhelper {
  static DBhelper _instance;

  static DBhelper getInstance() {
    if (_instance != null) {
      return _instance;
    }
    _instance = new DBhelper();
    return _instance;
  }

  Database _db;

  String tableNote = "Note";
  String tablePhoto = "Photo";
  String createNoteTable =
      'CREATE TABLE Note (noteId INTEGER  PRIMARY KEY AUTOINCREMENT , title TEXT NOt NULL,content TEXT NULL,time TEXT NOt NULL,date TEXT NOt NULL )';

  String createPhotoTable =
      '''CREATE TABLE Photo (photoId INTEGER PRIMARY KEY AUTOINCREMENT , photo TEXT NOt NULL, noteId INTEGER,
  FOREIGN KEY(noteId) REFERENCES Note(noteId) )''';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'NotePad.db');

    Database _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute(createNoteTable);
      db.execute(createPhotoTable);
    });
    return _database;
  }

  //insert to tables
  Future<int> insertNote(Note note) async {
    final Database database = await db;
    int id = await database.insert(tableNote, note.toMap());
    return id;
  }

  Future<int> insertPhoto(Photo photo) async {
    final Database database = await db;
    int id = await database.insert(tablePhoto, photo.toMap());
    return id;
  }

  //select all data from tables
  Future<List> selectAll() async {
    final Database database = await db;
    return database.query(tableNote);
  }

  //select single data from tables
  Future<List> selectPhoto(int noteId) async {
    final Database database = await db;
    return database.query(tablePhoto,
        where: "noteId = ?", whereArgs: [noteId], limit: 1);
  }

  Future<List> search(String search) async {
    final Database database = await db;
    return database.query(tableNote,
        where: "title LIKE  ?  OR content LIKE ?",
        whereArgs: ['%$search%','%$search%']);
  }

  //update data from tables

  updateNote(Note note) async {
    final Database database = await db;
    return database.update(tableNote, note.toMap(),
        where: "noteId = ?", whereArgs: [note.noteId]);
  }

  updatePhoto(Photo photo) async {
    final Database database = await db;
    return database.update(tablePhoto, photo.toMap(),
        where: "photoId = ?", whereArgs: [photo.photoId]);
  }
  //Delete data from tables
  Future<int> deleteNote(int noteId) async {
    final Database database = await db;
    return database.delete(tableNote, where: "noteId = ?", whereArgs: [noteId]);
  }

  Future<int> deletePhoto(int photoId) async {
    final Database database = await db;
    return database
        .delete(tablePhoto, where: "photoId = ?", whereArgs: [photoId]);
  }
}
