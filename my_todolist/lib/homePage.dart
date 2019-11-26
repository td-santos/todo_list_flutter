import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_todolist/Animation/FadeAnimation.dart';
import 'package:my_todolist/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/MytodoListHelper.dart';
import 'listaContent.dart';
import 'model/Notas.dart';

class HomPage extends StatefulWidget {
  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  TextEditingController _listaAddController = TextEditingController();
  var _db = MyTodoListHelper();
  List<Notas> _notas = List<Notas>();
  String _nomeLogin;
  String _nomeCompleto;

  

  

  _verificaExclusaoLista(Notas nota) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            title: Text(
              "Deseja Excluir a lista?",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  nota.lista,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontFamily: "Confortaa"),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "Cancelar",
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _removerLista(nota.lista);

                            Navigator.pop(context);
                            _recuperarLista();
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  _verificaLogoutShared() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            title: Text(
              "Deseja Alterar o nome?",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  _nomeCompleto,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontFamily: "Confortaa"),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "Cancelar",
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "Alterar",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _logoutShared();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  _logoutShared() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");
    initState();
  }

  _recuperarNomeShared() async {
    final prefs = await SharedPreferences.getInstance();
    //setState(() {
    _nomeLogin = prefs.getString("nome"); // ?? "Sem Valor";
    //});
    print("(Recuperar): $_nomeLogin");

    _nomeCompleto = _nomeLogin;
    print("(RecuperarCOMPLETO): $_nomeCompleto");

    _formatarNome(_nomeLogin);
  }

  _formatarNome(String nomeRecuperado) {
    var nomesplit;

    if (nomeRecuperado.contains(" ")) {
      nomesplit = nomeRecuperado.split(" ");
    } else {
      nomesplit = nomeRecuperado.split(" ").removeLast();
    }
    //print("substring teste "+name.substring(0,1));

    //print("nomesplit teste =="+nomesplit.toString());
    var name1 = [];
    var name2 = [];
    name1.add(nomesplit[0]);
    //print("Name2 teste =="+name2.toString());
    name2.add(nomesplit[1]);
    //print("Name3 teste =="+name3.toString());

    var letra1 = name1.toString().substring(1, 2);
    var letra2 = name2.toString().substring(1, 2);

    var nomeFormatado = letra1.toUpperCase() + letra2.toUpperCase();
    print("Nome Formatado = " + nomeFormatado);

    setState(() {
      _nomeLogin = nomeFormatado;
    });

    //print("Teste Iniciais -> "+ letra1.toUpperCase() + letra2.toUpperCase());
  }

  _exibirTelaAdd({Notas listaEditar}) {
    var nomelistaAnterior;

    String textoSalvarEditar = "";
    String textoTitle = "";

    if (listaEditar == null) {
      //salvar
      _listaAddController.text = "";
      textoSalvarEditar = "Criar";
      textoTitle = "Nova";
    } else {
      //Editar
      nomelistaAnterior = listaEditar.lista;
      _listaAddController.text = listaEditar.lista;
      textoSalvarEditar = "Editar";
      textoTitle = "Editar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            title: Text(
              "$textoTitle Lista",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  maxLength: 26,
                  controller: _listaAddController,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: "$textoSalvarEditar lista",
                      hintText: "digite aqui..."),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            "Cancelar",
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 1),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.pink),
                            borderRadius: BorderRadius.circular(17)),
                        child: FlatButton(
                          child: Text(
                            textoSalvarEditar,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //Save
                            _criarEditarLista(
                                listaEditar: listaEditar,
                                nomelistaAnterior: nomelistaAnterior);

                            Navigator.pop(context);
                            _recuperarLista();
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  _criarEditarLista({Notas listaEditar, String nomelistaAnterior}) async {
    String nomeLista = _listaAddController.text;

    if (listaEditar == null) {
      Notas notas = Notas(nomeLista, DateTime.now().toString());
      int result = await _db.salvarLista(notas);
      print("CriarLista: " + result.toString());
    } else {
      listaEditar.lista = nomeLista;
      await _db.editarLista(listaEditar, nomelistaAnterior);
      print("----- else editar lista ------");
    }
    //print("data atual: "+ DateTime.now().toString());

    _listaAddController.clear();
  }

  _recuperarLista() async {
    List listaRecuperada = await _db.recuperarLista();
    List<Notas> notasTemporaria = List<Notas>();

    for (var item in listaRecuperada) {
      Notas nota = Notas.fromMap(item);
      notasTemporaria.add(nota);
    }
    setState(() {
      _notas = notasTemporaria;
    });
    notasTemporaria = null;

    print("lista recuprada: " + listaRecuperada.toString());
  }

  _removerLista(String listaSelecionada) async {
    await _db.removerLista(listaSelecionada);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarNomeShared();
    _recuperarLista();    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[900],
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  height: 400,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/imagens/background.png"),
                        fit: BoxFit.fill),
                  ),
                  //child: Text(""),
                ),
              ),
              Positioned(
                top: 50,
                right: 50,
                left: 50,
                child: Container(
                  child: Center(
                    child: Text(
                      "My Lists",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: "Confortaa",
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 20,
                  top: 50,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white38, width: 2)),
                      height: 45,
                      width: 45,
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          
                          _verificaLogoutShared();
                        },
                        child: Text(
                          _nomeLogin, //"TD",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Confortaa"),
                        ),
                      )))),
              Align(
                  alignment: Alignment.topCenter,
                  
                  child: Container(
                    padding: EdgeInsets.only(top: 150),
                    child: FadeAnimation(
                        1.3,
                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 1,
                          childAspectRatio: 1.1,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          
                          children: List.generate(_notas.length, (index) {
                            final nota = _notas[index];

                            return Container(
                              
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 15,
                                    right: 20,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaContent(
                                                    nomelista: nota.lista,
                                                  )));
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                //color: Colors.white,
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 2),
                                                offset: Offset.fromDirection(
                                                    -2, -3),
                                                //Offset.fromDirection(-2, -7),
                                                blurRadius: 6,
                                                //spreadRadius: 0.5
                                              )
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                nota.lista,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.pinkAccent,
                                                    //color: Colors.deepPurpleAccent,
                                                    //color: Color.fromRGBO(143, 148, 251, 1),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "_ _ _ _ _ _ _ _ _ _",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          143, 148, 251, 1)),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        _exibirTelaAdd(
                                                            listaEditar: nota);
                                                        print("GESTURE EDITAR");
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Color.fromRGBO(
                                                            143, 148, 251, 1),
                                                        size: 30,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _verificaExclusaoLista(
                                                            nota);
                                                        print(
                                                            "GESTURE DELETAR");
                                                      },
                                                      child: Icon(
                                                        Icons.delete_sweep,
                                                        color:
                                                            Colors.pinkAccent,
                                                        //color: Colors.red,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                  )),
                            );
                          }),
                        )),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 60, top: 10, bottom: 10),
                child: GestureDetector(
                  child: Icon(
                    Icons.dashboard,
                    size: 35,
                    color: Colors.transparent,
                    //color: Color.fromRGBO(143, 148, 251, 2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 60, top: 10, bottom: 10),
                child: GestureDetector(
                  
                  child: Icon(
                    Icons.list,
                    size: 35,
                    color: Colors.transparent,
                    //color: Color.fromRGBO(143, 148, 251, 2),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          _exibirTelaAdd();
        },
        backgroundColor: Colors.pinkAccent, //Color.fromRGBO(143, 148, 251, 2),
        child: Icon(Icons.add),
        
        
      ),
    );
  }
}
