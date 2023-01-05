import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muyp_p1_flutter/main.dart';
import 'package:muyp_p1_flutter/vistas/estudiante.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:muyp_p1_flutter/conexion/variables_globales.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    //print('Token: ' + value.toString());

    final response = await http.get(Uri.parse(global.url_lpasajeros), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  Future<List> getCon() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    //print('Token: ' + value.toString());

    final response = await http.get(Uri.parse(global.url_conductor), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    this.getCon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Ruta en Curso'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _conductor(),
            Container(
              color: Colors.grey.withOpacity(0.15),
              height: 20.0,
            ),
            _lista(),
          ],
        ),
      ),
    );
  }

  Widget _conductor() {
    return Expanded(
        flex: 0,
        child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white24),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FutureBuilder<List>(
              future: getCon(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ItemCon(
                        list: snapshot.data ?? [],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )));
  }

  Widget _lista() {
    return Expanded(
        child: FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ItemList(
                list: snapshot.data ?? [],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ));
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({required this.list});

  abordar(String alm, idv) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    Map data = {'id_alm': alm, 'id_dv': idv};
    var jsonResponse = null;
    var response = await http.post(Uri.parse(global.url_abordo),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value'
        },
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        print(jsonResponse['tipo']);
      }
    } else {
      print(response.body);
    }
  }

  finalizar(String alm, idv) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    Map data = {
      'id_alm': alm,'id_dv': idv,
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse(global.url_finalizar),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value'
        },
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        print(jsonResponse['tipo']);
      }
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Pasajeros(
                        text: list[i]['id_alm'].toString(),
                        id_dv: list[i]['id_dv'].toString())));
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: list[i]['s_abordo'] == 1
                          ? const Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.green,
                      )
                          : list[i]['s_abordo'] == 2
                          ? const Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.blueAccent,
                      )
                          : list[i]['s_abordo'] == 3
                          ? const Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.deepOrangeAccent,
                      )
                          : const Icon(
                        Icons.school,
                        size: 40,
                      ),
                      title: Text(
                        list[i]['nom_al'].toString() +
                            " " +
                            list[i]['ap_al'].toString() +
                            " " +
                            list[i]['am_al'].toString() +
                            " (" +
                            list[i]['edad'].toString() +
                            ")",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: list[i]['s_abordo'] == 1
                          ? Text(
                        list[i]['institucion'].toString(),
                        style: TextStyle(fontSize: 18),
                      )
                          : list[i]['s_abordo'] == 2
                          ? Text(
                        list[i]['institucion'].toString() ,
                        style: TextStyle(fontSize: 18),
                      )
                          : list[i]['s_abordo'] == 3
                          ? Text(
                        list[i]['institucion'].toString(),
                        style: TextStyle(fontSize: 18),
                      )
                          : Text(
                        list[i]['institucion'].toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        list[i]['s_abordo'] == 1
                            ? /*TextButton(
                          child: Text('Abordo',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            abordar(list[i]['id_alm'].toString(),list[i]['id_dv'].toString());

                          },
                        )*/Text("Por abordar",
                          style: TextStyle(fontSize: 18),
                        )
                            : list[i]['s_abordo'] == 2
                            ? Text("En espera", style: TextStyle(fontSize: 18))
                            : list[i]['s_abordo'] == 3
                            ? /*TextButton(
                          child: Text('Concluir',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            print("Estamos en concluir");

                            finalizar(list[i]['id_alm'].toString(),list[i]['id_dv'].toString());
                          },
                        )*/Text(
                          "En camino",
                          style: TextStyle(fontSize: 18),
                        )
                            : Text("Finalizado", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ItemCon extends StatelessWidget {
  final List list;

  ItemCon({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(40, 2, 40, 2),
                      color: Colors.white38,
                      child: Text(list[i]['nom_ruta'].toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w900)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 90,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(3, 10, 3, 3),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_car_rounded,
                            size: 60,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 170,
                      height: 90,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(3, 10, 3, 3),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      'Destino: ' +
                                          list[i]['destino'].toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(list[i]['modelo'].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(list[i]['color'].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ],
                        ),
                      )),
                  SizedBox(
                      width: 90,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        child: Column(
                          children: [
                            Text('Placas',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                            Text(list[i]['placas'].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900))
                          ],
                        ),
                      )),
                ],
              ),
              Container(
                  color: Colors.blueAccent,
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Capacidad',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(list[i]['capacidad'].toString(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Ocupado',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(list[i]['capacidad'].toString(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.person_pin_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text('Licencia',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text(list[i]['no_licencia'].toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          );
        });
  }
}
