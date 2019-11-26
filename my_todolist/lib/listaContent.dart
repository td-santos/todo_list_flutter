import 'package:flutter/material.dart';

import 'helper/MytodoListHelper.dart';
import 'model/Notas.dart';

class ListaContent extends StatefulWidget {
  final nomelista;

  const ListaContent({this.nomelista});

  @override
  _ListaContentState createState() => _ListaContentState(nomelista);
}

class _ListaContentState extends State<ListaContent> {
  final nomelista;

  TextEditingController _addItemController = TextEditingController();
  var _db = MyTodoListHelper();
  List<Notas> _notas = List<Notas>();
  _ListaContentState(this.nomelista);

  _confirmarExclusao(Notas nota) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              title: Text(
                "Deseja excluir o item abaixo?",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    nota.nota,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 35,
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
                              //Save

                              _removerItem(nota.id);

                              Navigator.pop(context);
                              _recuperarItens();
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  _exibirTelaAdd({Notas notaEditar}) {
    String textoSalvarEditar = "";

    if (notaEditar == null) {
      //salvar
      _addItemController.text = "";
      textoSalvarEditar = "Add";
    } else {
      //Editar
      _addItemController.text = notaEditar.nota;
      textoSalvarEditar = "Editar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              title: Text(
                "${textoSalvarEditar} Item",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _addItemController,
                    autofocus: false,
                    decoration: InputDecoration(
                        labelText: "${textoSalvarEditar} Item",
                        hintText: "digite aqui..."),
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
                              textoSalvarEditar,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //Save

                              _criarEditarItem(notaEditar: notaEditar);

                              Navigator.pop(context);
                              _recuperarItens();
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  _criarEditarItem({Notas notaEditar}) async {
    String nomeItem = _addItemController.text;

    if (notaEditar == null) {
      //add item
      print("metodo criar no ADD" + nomeItem);
      Notas notas = Notas(nomelista, DateTime.now().toString(), nota: nomeItem);
      int result = await _db.salvarNota(notas);
      print("AddItem: " + result.toString());
    } else {
      //editar

      notaEditar.nota = nomeItem;
      await _db.editarNota(notaEditar);
      print("----- else editar ------");
    }

    _addItemController.clear();
  }

  _recuperarItens() async {
    List listaRecuperada = await _db.recuperarItens(nomelista);
    List<Notas> notasTemporaria = List<Notas>();

    for (var item in listaRecuperada) {
      Notas nota = Notas.fromMap2(item);
      notasTemporaria.add(nota);
    }
    setState(() {
      _notas = notasTemporaria;
    });
    notasTemporaria = null;

    print("lista recuprada: " + listaRecuperada.toString());
  }

  _removerItem(int id) async {
    await _db.removerItem(id);
    //_recuperarItens();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarItens();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                      nomelista,
                      textAlign: TextAlign.center,
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
                      padding: EdgeInsets.only(right: 20),
                      height: 45,
                      width: 45,
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ))))),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 120),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _notas.length,
                    itemBuilder: (context, index) {
                      final nota = _notas[index];

                      if (nota.nota == null) {
                        return Text("");
                      } else {
                        return
                            /*Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, top: 10, right: 15),
                            child: GestureDetector(
                              onTap: () {
                                _exibirTelaAdd(notaEditar: nota);
                              },
                              child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.pink[200],width: 2),
                                      //color: Colors.pink[300],
                                      gradient: LinearGradient(colors: [
                                Colors.pink[300],
                                //Colors.pink[300],
                                Colors.pink[400],
                              ]),
                                      boxShadow: [BoxShadow(
                                        color: Colors.grey[800],
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                        spreadRadius: -11

                                      )],
                                      //color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: GestureDetector(
                                        onTap: () {
                                          _exibirTelaAdd(notaEditar: nota);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                nota.nota,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    //color: Colors.pink[200],
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    onTap: () {
                                                      _exibirTelaAdd(
                                                          notaEditar: nota);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 1),
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.white,
                                                    ),
                                                    onTap: () {
                                                      _confirmarExclusao(nota);
                                                    },
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))),
                            ),
                          ),
                        );*/
                            Container(
                              padding: EdgeInsets.only(left: 15,right: 15,top: 10),
                              child: Container(
                              
                          decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.pink[200],width: 2),
                                      //color: Colors.pink[300],
                                      gradient: LinearGradient(colors: [
                                Colors.pink[300],
                                //Colors.pink[300],
                                Colors.pink[400],
                              ]),
                                      boxShadow: [BoxShadow(
                                        color: Colors.grey[800],
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                        spreadRadius: -11

                                      )],
                                      //color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(25)),
                          
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Text(nota.nota,
                                style: TextStyle(
                                    fontSize: 25,
                                    //color: Colors.pink[200],
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    _exibirTelaAdd(notaEditar: nota);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(Icons.edit,color: Colors.white),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    _confirmarExclusao(nota);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(Icons.delete_outline,color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                            );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaAdd();
        },
      ),
    );
  }
}
