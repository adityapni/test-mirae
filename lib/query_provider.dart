import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class QueryProvider with ChangeNotifier{
  QueryProvider({
    required this.query
});
  String query;

  Stream<Model> getUsers() async* {
    var url = Uri.parse('https://api.github.com/search/users?q=$query&per_page=10');
    print('url $url');
    var response = await http.get(url);
    // print('response $response');
    Model model;

    model = modelFromJson(response.body);
    print('model ${model.items}');
    notifyListeners();
    yield model;
  }
}