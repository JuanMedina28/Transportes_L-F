import 'dart:async';
import 'dart:convert';
import 'package:muyp_p1_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muyp_p1_flutter/conexion/variables_globales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPasajeros extends StatefulWidget {
  const ListPasajeros({Key? key}) : super(key: key);
  @override
  _ListPasajerosState createState() => _ListPasajerosState();
}

class _ListPasajerosState extends State<ListPasajeros> {

  late List data;
  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token' ) ?? 0;
    print('Token: '+ value.toString());

    final response = await http.get(Uri.parse(global.url_lpasajeros),
        headers: {
      'Accept':'application/json',
      'Authorization' : 'Bearer $value'
    });
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Pasajeros") ,
          actions: <Widget>[
            TextButton(
              onPressed: (

                  ) {
                },
              child: Text("Concluir", style: TextStyle(color: Colors.white)),
            ),
          ]
      ),
      body: Text("")/*FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? ItemList(
            list: snapshot.data??[],
          )
              : Center(
                  child: CircularProgressIndicator(),
          );
        },
      ),*/
    );
  }
}

