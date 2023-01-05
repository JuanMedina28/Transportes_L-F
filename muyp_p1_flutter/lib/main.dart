import 'package:flutter/material.dart';
import 'package:muyp_p1_flutter/servicios/push_notification.dart';
import 'package:muyp_p1_flutter/vistas/home.dart';
import 'package:muyp_p1_flutter/vistas/login.dart';
import 'package:muyp_p1_flutter/vistas/ruta_curso.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muyp_p1_flutter/conexion/variables_globales.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeAPP();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MUYP",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences sharedPreferences;

  Future<List> getDCon() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    //print('Token: ' + value.toString());

    final response = await http.get(Uri.parse(global.url_dconductor), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }
  Future<List> getLDV() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('token') ?? 0;
    //print('Token: ' + value.toString());

    final response = await http.get(Uri.parse(global.url_ldv), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    PushNotificationService.messgeStream.listen((message) {
      print('MUYP $message');
    });
    checkLoginStatus();
    this.getDCon();
    this.getLDV();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // print("Este es el token de usuario"+sharedPreferences.getString("token"));
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: const Text("Muy", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: const Text("Salir", style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold )),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _unidad(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                decoration: const BoxDecoration(color: Colors.black54),
                height: 30.0,width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 2, 10, 2),
                child: const Text("Proximos Viajes",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)
                ),
              ),
              _dviajes()
            ],
          ),
        ),
        drawer: NavigationDrawer());
  }

  Widget _dviajes() {
    return Expanded(
        child: FutureBuilder<List>(
          future: getLDV(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ItemLDV(
              list: snapshot.data ?? [],
            )
                : Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _unidad() {
    return Expanded(
        flex: 0,
        child: Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              //color: Colors.white24
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, 1.0),
                // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  Color(0xff262525),
                  Color(0x61050505),
                ],
                // red to yellow
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FutureBuilder<List>(
              future: getDCon(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ItemDCon(
                        list: snapshot.data ?? [],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.black54),
            accountName: Text('JMedina'),
            accountEmail: Text('Transportes SA'),
            currentAccountPicture:
                CircleAvatar(foregroundImage: NetworkImage('https://avatars.githubusercontent.com/u/109951?s=400&v=4')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  MainPage())),
          ),
          ListTile(
            leading: Icon(Icons.bus_alert),
            title: Text("En Curso"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage())),
          ),
          ListTile(
            leading: Icon(Icons.call_split_rounded),
            title: Text("Rutas"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage())),
          ),
          ListTile(
            leading: Icon(Icons.car_repair),
            title: Text("Unidad"),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ListPasajeros())),
          ),
        ],
      ),
    );
  }
}

class ItemLDV extends StatelessWidget {
  final List list;

  ItemLDV({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: list[i]['status'] == 1
                          ? const Icon(
                        Icons.call_split_rounded,
                        size: 60,
                        color: Colors.green,
                      )
                          : list[i]['status'] == 2
                          ? const Icon(
                        Icons.call_split_rounded,
                        size: 40,
                        color: Colors.blueAccent,
                      )
                          :  const Icon(
                        Icons.call_split_rounded,
                        size: 40,
                      ),
                      title: Text(
                        list[i]['nom_ruta'].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("Capacidad: " + list[i]['capacidad'].toString()+" pasajeros"
                         + "\n" "Fecha: " + list[i]['fecha'].toString()+
                          "\n" + "Hora: " + list[i]['hora_inicio'].toString(),
                        style: TextStyle(fontSize: 18),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: list[i]['status'] == 1
                              ? const Text("En Curso", style: TextStyle(fontSize: 18,
                              color: Colors.green))
                              : list[i]['status'] == 2
                              ? const Text("Proximo", style: TextStyle(fontSize: 18,
                              color: Colors.blueAccent))
                              : const Text("Concluido", style: TextStyle(fontSize: 18,
                              color: Colors.black54)),
                        ),
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

class ItemDCon extends StatelessWidget {
  final List list;

  ItemDCon({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Container(
                width: 360,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(40, 2, 40, 2),
                            child: Text("¡Bienvenido "+list[i]['name'].toString() +"!",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w900)
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 10, 1),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/109951?s=400&v=4'),
                                radius: 35,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              margin: EdgeInsets.fromLTRB(10, 1, 1, 1),
                              padding: EdgeInsets.all(3),
                              child: Column(
                                children: [
                                  Text('No. Licencia',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text(list[i]['no_licencia'].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),

                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              padding: EdgeInsets.fromLTRB(18,0, 3, 3),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(18,0, 3, 10),
                                          child:Text(
                                            'Unidad',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900)
                                        ),)
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
                            )
                          ],

                        ),
                        Container(
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5)
                          )
                          ),
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
                        ),
                      ],
                    ),
                    Row()
                  ],
                ),

              )
            ],

          );
        });
  }
}
