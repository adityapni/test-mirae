import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:technical_test/query_provider.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  void initState()  {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: (){
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
            icon: Icon(Icons.search))
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(

        )
      ),

    );
  }


}

class UserTile extends StatelessWidget {

  UserTile({
    this.user,
});

  String? user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            child: Text('${this.user}',style: TextStyle(fontSize: 20),),
          ),
        ],
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate{

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => QueryProvider(query: query),
        child: UserListView());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

}

class UserListView extends StatefulWidget {
  const UserListView({
    Key? key,
  }) : super(key: key);


  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {



  var response;
  String? userQuery;
  var status;
  var body;
  Map<String, dynamic>? responseJson;
  List<dynamic> items = [];
  Model? model;

  @override
  void initState()  {
    userQuery = context.read<QueryProvider>().query;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Model>(
      stream: context.read<QueryProvider>().getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return ListView(
            children: snapshot.data!.items!.map((e) {
              print('login ${e.login}');
              return UserTile(user:e.login);
            }).toList(),
          );
        }
        return CircularProgressIndicator();

      }
    );
  }
}
