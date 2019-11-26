import 'package:flutter/material.dart';
import 'package:my_todolist/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerNome = TextEditingController();

  _validaLogin(){
    print("VALIDA LOGIN");
    print("ControlerNome= " + _controllerNome.text);

    if(_controllerNome.text == null || _controllerNome.text == "" || _controllerNome.text == " "){
      _dialogDadosInvalidos();
    }else{
      _salvarNomeShared();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => HomPage()));
    }

  }

  _dialogDadosInvalidos(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            title: Text("Dados Inválidos",textAlign: TextAlign.center,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10,),
                Text("Favor Inserir um Nome válido para cadastrar no App! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontFamily: "Confortaa"
                ),),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                )
              ],
            ),
          );
        });
  }


  _verificarShared() async {
    final prefs = await SharedPreferences.getInstance();

    if (!(prefs.getString("nome") == null || prefs.getString("nome") == " "|| prefs.getString("nome") == "")) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomPage()
              
              ));
    } 
  }

  _salvarNomeShared() async {
    String valorDigitado = _controllerNome.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", valorDigitado);

    print("(Salvar): $valorDigitado");
    //initState();
  }

  _CadastrarUser() {
    _controllerNome.text;
  }
  @override
  void initState() {
    //_verificarShared();
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/imagens/background.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 150,
                        right: 50,
                        left: 50,
                        child: Container(
                          child: Center(
                            child: Text(
                              "Bem Vindo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: "Confortaa",
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, 2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                  spreadRadius: -5)
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.white))),
                              child: TextField(
                                controller: _controllerNome,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Digite seu nome!",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _validaLogin();
                          //_salvarNomeShared();
                          //Navigator.push(
                          //    context,
                          //    MaterialPageRoute(builder: (context) => HomPage()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Confortaa"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
