import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sahibindenn/screens/favoritespage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Menu extends StatelessWidget {
  Menu(this._controller, this._favorites);
  //final Future<WebViewController> _webViewControllerFuture;
  Completer<WebViewController> _controller;
  final Set<String> _favorites;

  // TODO(efortuna): Come up with a more elegant solution for an accessor to this than a callback.
 // final Function favoritesAccessor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (!controller.hasData) return Container();
        return PopupMenuButton<String>(
          onSelected: (String value) async {
            if (value == 'Email link') {
              var url = await controller.data.currentUrl();
          
            } else {
              var newUrl = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return FavoritesPage(_favorites);
              }));
              Scaffold.of(context).removeCurrentSnackBar();
              if (newUrl != null) controller.data.loadUrl(newUrl);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Favori ilanlarım',
                  child: Text('Favori ilanlarım'),
                ),
              ],
        );
      },
    );
  }
}