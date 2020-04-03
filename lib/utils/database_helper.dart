import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent_example/models/favori.dart';
import 'package:receive_sharing_intent_example/models/ilan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //nesne oluşturmadan direk kullanılır
  static Database _database;

//factory return döndüren constructor için kullanılır
//altta _databaseHelper oluşturulmuş mu o kontrol ediliyor oluşturulmamışsa
//DatabaseHelper._internal(); isimlendirilmiş constructor ile oluşturuluyor
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }
  //isimlendirilmiş constructor tanımlanıyor
  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      //_database nesnesi oluşmamışsa oluşturuyoruz
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }
  //database nesnesi oluşturan fonksiyon

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      //_db nesnesi yoksa
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path =
              join(databasesPath, "appDB.db"); //bu uygulamanın gerçek dbsi
          debugPrint("OLUSACAK DBNIN PATHI : $path");
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            //oluşturduğumuz notlar.db den veriler uygulamanın db si olan appDB ye kopyalanır.
            ByteData data =
                await rootBundle.load(join("assets", "favoriler.db"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }

    return _db;
  }

  Future<List<Map<String, dynamic>>> favorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("SELECT * FROM favori ORDER BY favoriID DESC");
    return sonuc;
  }

  Future<List<Favori>> favoriListesiniGetir() async {
    var favorileriIcerenMapListesi = await favorileriGetir();
    var favoriListesi = List<Favori>();
    for (Map map in favorileriIcerenMapListesi) {
      favoriListesi.add(Favori.fromMap(map));
    }
    return favoriListesi;
  }

  Future<int> favoriEkle(Favori favori) async {
    var db = await _getDatabase();
    var sayi = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM favori WHERE favoriURL = ?", [favori.favoriURL]));
    //yeniyse
    if (sayi <= 0) {
      var sonuc = await db.insert("favori", favori.toMap());
      return sonuc;
    } else {
      //güncelle
      //var sonuc2 = await db.update("favori", favori.toMap(), where: "favoriID = ?", whereArgs: [favori.favoriID]);
      //return sonuc2;

      return 0;
    }
  }

  Future<int> favoriGuncelle(Favori favori) async {
    var db = await _getDatabase();
    var sonuc = await db.update("favori", favori.toMap(),
        where: 'favoriID = ?', whereArgs: [favori.favoriID]);
    return sonuc;
  }

  Future<int> favoriSil(int favoriID) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete("favori", where: 'favoriID = ?', whereArgs: [favoriID]);
    if (sonuc > 0){
      sonuc = await db.delete("ilan", where: 'favoriID = ?', whereArgs: [favoriID]);
     return sonuc; 
    }
  }

  Future<List<Map<String, dynamic>>> ilanlariGetir(int favoriID) async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        'select * from ilan WHERE favoriID = ?', [favoriID]);
    return sonuc;
  }

  Future<List<Ilan>> ilanListesiniGetir(int favoriID) async {
    var ilanlarMapListesi = await ilanlariGetir(favoriID);
    var ilanListesi = List<Ilan>();
    for (Map map in ilanlarMapListesi) {
      ilanListesi.add(Ilan.fromMap(map));
    }
    debugPrint(ilanListesi.toString());
    return ilanListesi;
  }

    Future<int> setIlanOkundu(int ilanID) async{
       var db = await _getDatabase();
      var _sahibindenilanID = Sqflite.firstIntValue(await db.rawQuery(
        "UPDATE ilan SET ilanOkundumu = 1 WHERE ilanID = ?",
        [ilanID]));   
        return _sahibindenilanID;       
    }

  Future<int> ilanEkle(Ilan ilan) async {
    var db = await _getDatabase();

    var _sahibindenilanID = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ilan WHERE ilanSahibindenID = ?",
        [ilan.ilanSahibindenID]));
    //daha önce kaydedilmemişse    
    if (_sahibindenilanID <= 0) {
      var sonuc = await db.insert("ilan", ilan.toMap());
      return sonuc;
    } else {
      //güncelle
      //var sonuc2 = await db.update("favori", favori.toMap(), where: "favoriID = ?", whereArgs: [favori.favoriID]);
      //return sonuc2;

      return 0;
    }
  }

    Future<int> ilanGuncelle(Ilan ilan) async {
      var db = await _getDatabase();
      var sonuc = db.update('ilan', ilan.toMap(),
          where: 'ilanID = ?', whereArgs: [ilan.ilanID]);
      return sonuc;
    }

    Future<int> ilanSil(int ilanID) async {
      var db = await _getDatabase();
      var sonuc =
          await db.delete("ilan", where: 'ilanID = ?', whereArgs: [ilanID]);
      return sonuc;
    }


  }

