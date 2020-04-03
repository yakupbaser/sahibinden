import 'package:flutter/material.dart';
import 'package:receive_sharing_intent_example/models/favori.dart';
import 'package:receive_sharing_intent_example/utils/database_helper.dart';
import 'package:receive_sharing_intent_example/utils/functions.dart';


class FavoriDialog {
  static TextEditingController _textFieldController = TextEditingController();
  static String enteredFavoriName;
  static var scaffoldKey = GlobalKey<ScaffoldState>();

  static Future<bool> displayDialog(
      BuildContext context, String linkText) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Favori Aramayı Kaydet'),
            content: TextField(
              autofocus: true,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Favori arama adı"),
              onChanged: (value) {
                enteredFavoriName = value;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('VAZGEÇ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('KAYDET'),
                onPressed: () {
                  //ALINAN FAVORİ DB YE EKLENİYOR
                  debugPrint(
                      'favoriname = $enteredFavoriName, aramaurl = $linkText');
                  databaseHelper
                      .favoriEkle(Favori(enteredFavoriName, linkText))
                      .then((favoriID) async {
                    //favori linki daha önce girilmemişse
                    if (favoriID > 0) {
                      debugPrint('favori eklendi favoriID = $favoriID');

                      Functions.sahibindenYeniIlanVarmi(linkText, favoriID)
                          .then((onValue) {
                        // if (onValue > 0){
                        //   debugPrint('ilanlar başarıyla kaydedildi. son ilanid = ${onValue.toString()}');
                        // } else{
                        //   debugPrint('ilanlar kaydedilemedi ${onValue.toString()}');
                        // }
                      });

                      // debugPrint('guncelilanlar = ${guncelIlanlar.toString()}');

                      //ilanları çek
                      //db ye kaydet
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Favrori Arama Eklendi!'),
                        duration: Duration(seconds: 2),
                      ));

                      Navigator.of(context).pop();
                      return true;
                    } else {
                      debugPrint('Bu arama zaten kayıtlı');
                      return false;
                    }
                  });
                },
              )
            ],
          );
        });
  }

  static Future<bool> displayDeleteDialog(
      BuildContext context, int silinecekFavoriID) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Favori Aramayı Sil'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('VAZGEÇ'),
                onPressed: () {
                  Navigator.of(context).pop();
                  return false;
                },
              ),
              new FlatButton(
                child: new Text('SİL'),
                onPressed: () {
                  //VERİ SİLİNİYOR
                  debugPrint('Silme İşlemi Başladı');
                  databaseHelper.favoriSil(silinecekFavoriID).then((onValue) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Favori Silindi!'),
                      duration: Duration(seconds: 2),
                    ));
                    debugPrint('sildi ama');

                    return true;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
