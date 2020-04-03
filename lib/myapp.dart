import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:receive_sharing_intent_example/models/favori.dart';
import 'package:receive_sharing_intent_example/models/ilan.dart';
import 'package:receive_sharing_intent_example/utils/database_helper.dart';
import 'package:receive_sharing_intent_example/utils/favoridialog.dart';
import 'package:receive_sharing_intent_example/utils/functions.dart';
import 'package:receive_sharing_intent_example/viewFavori.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  DatabaseHelper databaseHelper = DatabaseHelper();
  String _sharedText;
  String clearUrl;
  bool isFromMemory = false;
  List<Favori> tumFavoriler;
  var _newFutureBuilder;
  @override
  void initState() {
    super.initState();

    _newFutureBuilder = _futureBuilder();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      isFromMemory = true;
      clearUrl = Functions.processUrl(value, isFromMemory);
      bool onValue = await FavoriDialog.displayDialog(context, clearUrl);
      if (onValue = true) {
        setState(() {
          _newFutureBuilder = _futureBuilder();
          debugPrint('setstate2');
        });
      }

      debugPrint('setstate');
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) async {
      isFromMemory = false;
      clearUrl = Functions.processUrl(value, isFromMemory);
      bool onValue1 = await FavoriDialog.displayDialog(context, clearUrl);
      if (onValue1 = true) {
        setState(() {
          _newFutureBuilder = _futureBuilder();
          debugPrint('setstate2');
        });
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);

    int favoriID = 1;

    List<Ilan> guncelIlanlar;
    guncelIlanlar = List<Ilan>();

    List<DropdownMenuItem<int>> favoriItemleriOlustur() {
      return tumFavoriler
          .map((favori) => DropdownMenuItem<int>(
                value: favori.favoriID,
                child: Text("${favori.favoriMETIN} ve ${favori.favoriURL}"),
              ))
          .toList();
    }

    return Scaffold(
      key: FavoriDialog.scaffoldKey,
      appBar: AppBar(
        title: const Text('Favori Aramalar'),
      ),
      body: _newFutureBuilder,

      //guncel ilanları okuyor
      // FutureBuilder<List<Sahibinden>>(
      //   future: sahibindenYeniIlanVarmi(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       //Your downloaded page

      //       debugPrint('yuklendi'); //snapshot.data.toString()
      //       return Text('Finished');
      //     } else if (snapshot.hasError) return Text('ERROR');

      //     return Text('LOADING');
      //   },
      // ),

      // FloatingActionButton(
      //   onPressed: () async {
      //     databaseHelper.favorileriGetir().then((favoriIcerenMapListesi) {
      //       for (Map okunanMap in favoriIcerenMapListesi) {
      //         tumFavoriler.add(Favori.fromMap(okunanMap));
      //         debugPrint(tumFavoriler.toString());
      //         setState(() {});
      //       }
      //     });

      //     databaseHelper.ilanlariGetir().then((ilanIcerenMapListesi) {
      //       debugPrint('burda');
      //       for (Map okunanMap in ilanIcerenMapListesi) {
      //         debugPrint('burda1');
      //         guncelIlanlar.add(Ilan.fromMap(okunanMap));
      //         if (guncelIlanlar.isEmpty == true) {
      //           debugPrint('maalesef boş');
      //         }

      //         setState(() {});
      //       }

      //       for (var ilanItem in guncelIlanlar) {
      //         debugPrint(ilanItem.toString());
      //       }
      //     });

      // databaseHelper.ilanListesiniGetir().then((ilanIcerenMapListesi){

      //            debugPrint(ilanIcerenMapListesi.toString());

      //       });
      //           },
      //        ),
      // DropdownButton<int>(
      //     items: favoriItemleriOlustur(),
      //     value: favoriID,
      //     onChanged: (secilenFavoriId) {
      //       setState(() {
      //         favoriID = secilenFavoriId;
      //       });
      //     }),
      //        ],
      //      ),
    );
    //    );
  }

  _futureBuilder() {
    return FutureBuilder(
        future: databaseHelper.favoriListesiniGetir(),
        builder: (contex, AsyncSnapshot<List<Favori>> gelenFavoriModel) {
          if (gelenFavoriModel.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (gelenFavoriModel.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: gelenFavoriModel?.data?.length ?? 1,
                itemBuilder: (contex, index) =>
                    InkWell(child: cardOlustur(index, gelenFavoriModel)));
          }
        });
  }

  Card cardOlustur(int index, AsyncSnapshot<List<Favori>> gelenFavoriModel) {
    Text txt = Text(gelenFavoriModel.data[index].favoriMETIN);

    return Card(
      elevation: 4,
      child: ListTile(
        onTap: () {
          int _currentFavoriId = 0;
          _currentFavoriId = gelenFavoriModel.data[index].favoriID;
          debugPrint('currentid = ${gelenFavoriModel.data[index].favoriID}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => getFavories(_currentFavoriId)));
        },
        leading: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
            onTap: () {
              debugPrint('servis durduruluyor');
            },
            child: Icon(Icons.pause_circle_filled, color: Colors.red),
          ),
          InkWell(
            onTap: () {

              startAlarmManagerService().then((onValue){
                debugPrint('alarm manager servisi başladı');
              });
            },
            child: Icon(
              Icons.ondemand_video,
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                FavoriDialog.displayDeleteDialog(
                        context, gelenFavoriModel.data[index].favoriID)
                    .then((silindimi) {
                  this.setState(() {
                    debugPrint('favori silindi!');
                    _newFutureBuilder = _futureBuilder();
                  });
                });

                // databaseHelper
                //     .favoriSil()
                //     .then((onValue) {

                //   this.setState(() {
                //     debugPrint(
                //         '${gelenFavoriModel.data[index].favoriID} id li favori silindi!');
                //         _newFutureBuilder = _futureBuilder();
                //   });
                // });
              },
              child: Icon(Icons.delete)),
        ]),
        title: txt,
      ),
    );
  }

  Future<void> startAlarmManagerService() async {
       final int periodicID = 0;
     debugPrint('servis başlıyor');
     await AndroidAlarmManager.initialize();
     await AndroidAlarmManager.periodic(const Duration(seconds: 10),
         periodicID, Functions.servisBaslat(),
         wakeup: true);
  }

  void callBack(){
    debugPrint('ahahahaha timer!');
      }
}
