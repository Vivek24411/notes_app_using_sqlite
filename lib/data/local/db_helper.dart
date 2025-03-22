import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper{

  DBhelper._();

  static final DBhelper getInstance = DBhelper._(); // static final DBhelper getInstance(){ return DBhelper._();}

  Database? myDB;

  Future<Database> getDB()async{
    if(myDB!= null){
      return myDB!;
    }
    else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB()async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");
    return await openDatabase(dbPath, onCreate: (db, version){
      db.execute("create table note ( s_no integer primary key autoincrement, title text, desc text)");
    },version: 1);
  }

  Future<bool> addNote({required String mTitle, required String mDesc})async{
    var db = await getDB();
    int rowsEffected = await db.insert("note", {
      "title" : mTitle,
      "desc"  : mDesc,
    });

    return rowsEffected>0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes()async{
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query("note");
    return mData;
  }

  Future<bool> updateNote({required String mTitle, required String mDesc, required int sno})async{
    var db = await getDB();
    int rowsEffected = await db.update("note", {
      "title" : mTitle,
      "desc"  : mDesc,
    }, where: "s_no = $sno");
    return rowsEffected>0;

  }

  Future<bool> deleteNote({required int sno})async{
    var db = await getDB();
    int rowsEffected = await db.delete("note", where: "s_no = $sno");
    return rowsEffected>0;

  }


}