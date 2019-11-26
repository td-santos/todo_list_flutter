class Notas{

  int id;
  String lista;
  String nota;
  String data;

  Notas(this.lista,  this.data, {this.nota});

  Notas.fromMap(Map map){
    this.id = map["id"];
    this.lista = map["lista"];
    //this.nota = map["anotacao"];
    this.data = map["data"];
  }
  Notas.fromMap2(Map map){
    this.id = map["id"];
    this.lista = map["lista"];
    this.nota = map["anotacao"];
    this.data = map["data"];
  }

  Map toMap(){
    Map<String,dynamic> map ={
      "lista" : this.lista,
      "anotacao" : this.nota,
      "data" : this.data
    };
    

    if(id != null){
      map["id"] = this.id;
    }

    return map;
  }

  
}