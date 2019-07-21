import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

Future<String> getHtmlFromUrl(String newUrl) async{
  String htmlSource = '';
  var response = await http.get(newUrl);
  htmlSource = response.body;
          // .replaceAll("\n", "")
          // .replaceAll("\t", "")
          // .replaceAll("  ", "");
  //debugPrint(htmlSource);
  return htmlSource;        

}