import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muyp_p1_flutter/conexion/variables_globales.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor:
        Colors.transparent));
    return Scaffold(
      body: logout()
    );
  }

Container logout(){
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('images/fg.jpg'),
                fit: BoxFit.cover)
        ),
        child: conten()
    );
  }

  Widget conten(){
    return Container(
      decoration: const BoxDecoration(color: Colors.black54),
      child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              nombre(),
              us(),
              ps(),
              const SizedBox(height: 15,),
              //acceder(),
              buAcceder2(),
              const SizedBox(height: 20,),
              olps(),
              const SizedBox(height: 100,),
              poli()
            ],
          )
      ),
    );
  }

  Widget nombre(){
    return Container(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: const Text("Bienvenido",
            style: TextStyle(color: Colors.white,
                fontSize: 45.0,fontWeight: FontWeight.bold)
        ));
  }

  Widget us(){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: "transporte@gmail.com",
            fillColor: Colors.white,
            filled: true,
          ),
        )
    );
  }

  Widget ps(){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "contraseña",
            fillColor: Colors.white,
            filled: true,
          ),
        )
    );
  }

  Widget olps(){
    return TextButton(
      onPressed: (){},
      child: const Text('¿Olvidaste tu contraseña?',
          style: TextStyle(color: Colors.white,
              fontSize: 20.0,fontWeight: FontWeight.bold)),

    );
  }

  Widget poli(){
    return TextButton(
      onPressed: (){},
      child: const Text('Aviso de Privacidad',
          style: TextStyle(color: Colors.lightBlueAccent,
              fontSize: 22.0,fontWeight: FontWeight.bold)),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass
    };
    var jsonResponse = null;

    var response = await http.post(Uri.parse(global.url_loginn), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        print(jsonResponse['tipo']);
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
            (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Widget buAcceder2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        onPressed: emailController.text == "" || passwordController.text ==
            "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),)
        ),

        child: const Text("Sign In", style: TextStyle(color: Colors.white70,
            fontSize: 20.0,fontWeight: FontWeight.bold)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

}