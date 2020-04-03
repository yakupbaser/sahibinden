import 'package:flutter/material.dart';
import 'package:receive_sharing_intent_example/models/favori.dart';
import 'package:receive_sharing_intent_example/models/ilan.dart';
import 'package:receive_sharing_intent_example/utils/database_helper.dart';
import 'package:http/http.dart' as http;

class Functions {
  static String processUrl(String value, bool isFromMemory) {
    final regexp = RegExp(r'https[^^>]+$');
    if (value.contains('arama') && value.contains('sahi.io')) {
      //  isFromMemory  == true ?
      //  print('http yakaladı app bellekte $value'):
      //  print('http yakaladı app kapalı $value');

      final Match = regexp.firstMatch(value);
      debugPrint('clearUrl = ' + Match.group(0));
      return Match.group(0);
    }
  }

  static Future<int> sahibindenYeniIlanVarmi(
      String sahibindenURL, int favoriID) async {
    List<Ilan> tumYeniIlanlar = [];
    String _htmlVeri = '';
    DatabaseHelper databaseHelper = DatabaseHelper();
    int _ilanID;
    String _ilanURL;
    String _ilanAD;
    String _ilanFIYAT;
    String _ilanTARIH;
    String _iLILCE;
    int _ilanSahibindenID;
    String _ilanResimUrl;
    int _ilanOkundumu;
    int result1 = 0;
    int result2 = 0;

    debugPrint('sahibindenurl = $sahibindenURL');
    var response = await http.get(sahibindenURL);
    _htmlVeri = '';
    _htmlVeri = response.body.replaceAll("\n", "");
    _htmlVeri = _htmlVeri.replaceAll("\t", "");
    _htmlVeri = _htmlVeri.replaceAll("  ", "");

    //debugPrint('response body = ${response.body}');
    //debugPrint('htmlveri = ${_htmlVeri}');
    RegExp desenIlanlar = RegExp(
        r'data-id="(?<ilanID>\d+?)"class="searchResultsItem([^^]*?)"><td class="searchResultsLargeThumbnail"><a href="(?<ilanUrl>[^^]*?)"><([^^]*?)src="(?<ilanResimUrl>[^^]*?)" alt="([^^]*?)" title="([^^]*?)"\>([^^]*?)data-classified-id="(\d+?)"><div([^^]*?)" href="([^^]*?)">(?<ilanTitle>[^^]*?)<\/a><([^^]*?)><div>(?<ilanFiyat>[^^]*?)<\/div><\/td><td class="searchResultsDateValue"><span>(?<tarihAy>[^^]*?)<\/span><br\/><span>(?<tarihYil>[^^]*?)<\/span><\/td><td class="searchResultsLocationValue">(?<ilanIl>[^^]*?)<([^^]*?)>(?<ilanIlce>[^^]*?)<');

    Iterable<Match> matchIlanlar = desenIlanlar.allMatches(_htmlVeri);

    for (Match eslesenIlan in matchIlanlar) {
      _ilanID = 0;
      _ilanURL = '';
      _ilanResimUrl = '';
      _ilanAD = '';
      _ilanFIYAT = '';
      _ilanTARIH = '';
      _iLILCE = '';
      _ilanSahibindenID = 0;
      _ilanOkundumu = 0;

      _ilanSahibindenID = int.parse(eslesenIlan.group(1));
      _ilanURL = eslesenIlan.group(3);
      _ilanResimUrl = eslesenIlan.group(5);
      _ilanAD = eslesenIlan.group(12);
      _ilanFIYAT = eslesenIlan.group(14);
      _ilanTARIH = eslesenIlan.group(15) + '-' + eslesenIlan.group(16);
      _iLILCE = eslesenIlan.group(17) + '-' + eslesenIlan.group(19);

      //ilanları db ye kaydediyoruz
      result1 = await databaseHelper.ilanEkle(Ilan(
          favoriID,
          _ilanURL,
          _ilanAD,
          _ilanFIYAT,
          _ilanTARIH,
          _iLILCE,
          _ilanSahibindenID,
          _ilanResimUrl,
          _ilanOkundumu));
      // debugPrint('favoriID = ' +
      //     favoriID.toString() +
      //     '\n' +
      //     'ilanURL = ' +
      //     _ilanURL +
      //     '\n' +
      //     'ilanAD = ' +
      //     _ilanAD +
      //     '\n' +
      //     'ilanFIYAT = ' +
      //     _ilanFIYAT +
      //     '\n' +
      //     'ilanTARIH = ' +
      //     _ilanTARIH +
      //     '\n' +
      //     'iLILCE = ' +
      //     _iLILCE +
      //     '\n' +
      //     'ilanSahibindenID = ' +
      //     _ilanSahibindenID.toString() +
      //     '\n' +
      //     'ilanResimUrl = ' +
      //     _ilanResimUrl +
      //     '\n' +
      //     'ilanID = ' +
      //     _ilanID.toString() +
      //     '\n' +
      //     'ilanOkundumu = ' +
      //     _ilanOkundumu.toString() +
      //     '\n' +
      //     '----------------------------------\n');

      debugPrint('ilan eklendi. Oluşan ilan_db_ID = $result1');
      result1 > 0 ? result2 = result1 : result2 = result2;
    }
    return result2; //for

    //http get
  }

  static Future<void> guncelIlanCek() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Favori> tumFavoriler;
    int yeniIlanGirildimi = 0;

    tumFavoriler = await databaseHelper.favoriListesiniGetir();

    debugPrint(tumFavoriler[0].favoriURL);

   // databaseHelper.ilanSil(585);

    yeniIlanGirildimi = await sahibindenYeniIlanVarmi(
        tumFavoriler[0].favoriURL, tumFavoriler[0].favoriID);
    //yeni ilan gelmişse
    if (yeniIlanGirildimi > 0) {
      debugPrint('yeni ilan geldi ilanID = ${yeniIlanGirildimi.toString()}');
    } else {
      debugPrint('henüz yeni ilan yok!');
    }
  }

  static servisBaslat(){
    guncelIlanCek().then((onValue){
      debugPrint('backend servis başladı');
    });
  }
}
