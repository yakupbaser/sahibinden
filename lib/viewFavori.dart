import 'package:flutter/material.dart';
import 'package:receive_sharing_intent_example/models/ilan.dart';
import 'package:receive_sharing_intent_example/utils/database_helper.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class getFavories extends StatefulWidget {
  int _currentFavoriId;

  getFavories(this._currentFavoriId) {
    debugPrint('database_helper alınan favoriID = $_currentFavoriId');
  }
  @override
  _getFavoriesState createState() => _getFavoriesState();
}

class _getFavoriesState extends State<getFavories> {
  List<Ilan> ilanModel;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favori İlanlarım'),
        ),
        body: Container(
          child: FutureBuilder(
              future:
                  databaseHelper.ilanListesiniGetir(widget._currentFavoriId),
              builder: (contex, AsyncSnapshot<List<Ilan>> gelenIlanModel) {
                if (gelenIlanModel.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (gelenIlanModel.connectionState == ConnectionState.none) {
                  debugPrint('malesef veriler gelmedi');
                } else if (gelenIlanModel.connectionState ==
                    ConnectionState.done) {
                  return ListView.builder(
                      itemCount: gelenIlanModel?.data?.length ?? 1,
                      itemBuilder: (contex, index) => InkWell(
                          child: cardOlustur(
                              index, widget._currentFavoriId, gelenIlanModel)));
                }
              }),
        ));
  }

  Card cardOlustur(int index, int _currentFavoriId,
      AsyncSnapshot<List<Ilan>> gelenIlanModel) {
    // if (gelenIlanModel.data[index].favoriMETIN == widget._favoriMETIN) {
    var unescape = new HtmlUnescape();
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () {
          _launchURL(gelenIlanModel.data[index].ilanURL).then((acildimi) {
            if (acildimi = true) {
              databaseHelper
                  .setIlanOkundu(gelenIlanModel.data[index].ilanID)
                  .then((onValue) {
                setState(() {
                  debugPrint('ilan Okundu');
                });
              });
            } else {
              setState(() {
                debugPrint('ilanokunamadı');
              });
            }
          });
        },
        leading: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image: gelenIlanModel.data[index].ilanResimUrl),
        //trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[]),
        title: Align(
          alignment: Alignment(-1.2, 0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    unescape.convert(gelenIlanModel.data[index].ilanAD),
                    style: gelenIlanModel.data[index].ilanOkundumu == 0
                        ? TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)
                        : TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      unescape.convert(
                        gelenIlanModel.data[index].iLILCE,
                      ),
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                  Text(gelenIlanModel.data[index].ilanFIYAT,
                      style:
                          TextStyle(color: Colors.blue.shade900, fontSize: 10))
                ],
              )
            ],
          ),
        ),
      ),
    );

    // ListTile(

    //   leading: FadeInImage.assetNetwork(placeholder: 'assets/loading.gif', image: gelenIlanModel.data[index].ilanResimUrl),
    //   trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
    //     InkWell(child: Icon(Icons.delete)),
    //   ]),
    //   title: Text(unescape.convert(gelenIlanModel.data[index].ilanAD) ),
    // ),

    //}
  }

  Future<bool> _launchURL(String url) async {
    var sahibindenurl = 'https://www.sahibinden.com' + url;
    debugPrint('açılacak ilan = $sahibindenurl');
    if (await canLaunch(sahibindenurl)) {
      await launch(sahibindenurl);

      return true;
    } else {
      return false;
    }
  }
}
