import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:muyp_p1_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muyp_p1_flutter/conexion/variables_globales.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Pasajeros extends StatefulWidget {
  final String text;
  final String id_dv;

  const Pasajeros({Key? key, required this.text, required this.id_dv})
      : super(key: key);

  @override
  _PasajerosState createState() => _PasajerosState(text, id_dv);
}

class _PasajerosState extends State<Pasajeros> {
  late List data;
  String dtext;
  String did_dv;

  _PasajerosState(this.dtext, this.did_dv);

  Future<List> getPP() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    //print('Token: ' + value.toString());
    Map data = {'id_alm': dtext, 'id_v': did_dv};

    final response = await http.post(Uri.parse(global.url_datosp),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value'
        },
        body: data);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    this.getPP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text("Pasajero"),
            actions: <Widget>[]),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.black54),
          child: Column(
            children: [_perfil_p()],
          ),
        ));
  }

  Widget _perfil_p() {
    return Expanded(
        flex: 0,
        child: Container(
            height: 580,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FutureBuilder<List>(
              future: getPP(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? PerfilPas(
                        list: snapshot.data ?? [],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )));
  }
}

class PerfilPas extends StatelessWidget {
  final List list;

  PerfilPas({required this.list});


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
    Map data = {'id_alm': alm, 'id_dv': idv};
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
              height: 560,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 100,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://avatars.githubusercontent.com/u/109951?s=400&v=4'),
                              radius: 35,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 150,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[i]['nom_al'].toString(),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[i]['ap_al'].toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[i]['am_al'].toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                )
                              ]))
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Edad',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          list[i]['edad'].toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ))
                              ])
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 3,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    color: Colors.black54,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                              width: 155,
                              margin: EdgeInsets.fromLTRB(10, 10, 2, 5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(),
                              child: Column(children: [
                                Row(
                                  children: const [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(1, 10, 1, 10),
                                        child: Icon(
                                          Icons.school,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Text(
                                          'Matricula: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(1, 10, 1, 10),
                                        child: Icon(
                                          Icons.place_rounded,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Text(
                                          'Institucion: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(1, 10, 1, 10),
                                        child: Icon(
                                          Icons.announcement,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        child: Text(
                                          'Estatus: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ],
                                )
                              ]))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 155,
                              padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
                              margin: EdgeInsets.fromLTRB(0, 10, 5, 5),
                              decoration: BoxDecoration(),
                              child: Column(children: [
                                Column(children: [
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            list[i]['matricula'].toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            list[i]['institucion'].toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: list[i]['s_abordo'] == 1
                                            ? const Text(
                                                "Por abordar",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              )
                                            : list[i]['s_abordo'] == 2
                                                ? const Text(
                                                    "En espera",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blueAccent),
                                                  )
                                                : list[i]['s_abordo'] == 3
                                                    ? const Text(
                                                        "En Viaje",
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepOrangeAccent),
                                                      )
                                                    : const Text(
                                                        "Viaje finalizado",
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                      ),
                                    ],
                                  )
                                ])
                              ]))
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(),
                        child: list[i]['s_abordo'] == 1
                            ? TextButton(
                                child: const Text('Abordar',
                                    style: TextStyle(fontSize: 18)),
                                onPressed: () {
                                  abordar(list[i]['id_alm'].toString(),list[i]['id_dv'].toString());
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const HomePage()));
                                  },
                              )
                            : list[i]['s_abordo'] == 2
                                ? Text('', style: TextStyle(fontSize: 18))
                                : list[i]['s_abordo'] == 3
                                    ? TextButton(
                                        child: const Text('Concluir',
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () {
                                          finalizar(list[i]['id_alm'].toString(),list[i]['id_dv'].toString());
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder: (context) => const HomePage()));
                                        },
                                      )
                                    : Text("", style: TextStyle(fontSize: 18)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 350,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(),
                        child: list[i]['s_abordo'] == 1
                            ? TextButton(
                                child: Text('Seguir en Waze',
                                    style: TextStyle(fontSize: 18)),
                                onPressed: () async {
                                  var url = 'waze://?ll=${list[i]['latitud'].toString()},${list[i]['longitud'].toString()}';
                                  print("Hola intento de waze");
                                  var fallbackUrl =
                                      'https://waze.com/ul?ll=${list[i]['latitud'].toString()},${list[i]['longitud'].toString()}&navigate=yes';
                                  try {
                                    bool launched = await launch(url,
                                        forceSafariVC: false,
                                        forceWebView: false);
                                    if (!launched) {
                                      await launch(fallbackUrl,
                                          forceSafariVC: false,
                                          forceWebView: false);
                                    }
                                  } catch (e) {
                                    await launch(fallbackUrl,
                                        forceSafariVC: false,
                                        forceWebView: false);
                                  }
                                },
                              )
                            : list[i]['s_abordo'] == 2
                                ? Text("", style: TextStyle(fontSize: 18))
                                : list[i]['s_abordo'] == 3
                                    ? Text("", style: TextStyle(fontSize: 18))
                                    : Text("", style: TextStyle(fontSize: 18)),
                      )
                    ],
                  )
                ],
              ));
        });
  }
}
