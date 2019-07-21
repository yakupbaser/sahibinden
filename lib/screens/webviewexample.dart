import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sahibindenn/screens/menu.dart';
import 'package:sahibindenn/works/gethtmlsource.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Set<String> _favorites = Set<String>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _visible = false;    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahibinden Favori İlanlar'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          //NavigationControls(_controller.future),
          Menu(_controller, _favorites),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://www.sahibinden.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),

          onPageFinished: (String url) async{
            print('Page finished loading: $url');

            
            
             _manageFavoriteButtonTheme(url); 
            
          },
        );
      }),
      floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return Visibility(
                visible: _visible,
                child: FloatingActionButton(
                  onPressed: () async {
                    final String url = await controller.data.currentUrl();
                    _favorites.add(url);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Favorilere eklendi $url')),
                    );
                  },
                  child: const Icon(Icons.favorite),
                ));
          }
          ;

          return Container();
        });
  }

  _manageFavoriteButtonTheme(String url) async {
    String htmlSource = '';
    bool newVisible = false;
    htmlSource = await getHtmlFromUrl(url);
    if (htmlSource.contains('Aramayı Favorilere Kaydet') == true && url.endsWith('#/') == true) {
      debugPrint('Buton var');
      newVisible = true;
    } else {
      debugPrint('Buton yok');
      newVisible = false;
    }
    setState(() {
      _visible = newVisible;
    });
  }
}
