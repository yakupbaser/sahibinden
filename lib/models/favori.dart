

class Favori{
  int favoriID;
  String favoriMETIN;
  String favoriURL;
  
  Favori(this.favoriMETIN, this.favoriURL);
  Favori.withID(this.favoriID, this.favoriMETIN, this.favoriURL);

  Map<String, dynamic> toMap (){

    var map = Map<String, dynamic>();
    map['favoriID'] = favoriID;
    map['favoriMETIN'] = favoriMETIN;
    map['favoriURL'] = favoriURL;

    return map;

  }

  Favori.fromMap(Map<String, dynamic> map){
    this.favoriID = map['favoriID'];
    this.favoriMETIN = map['favoriMETIN'];
    this.favoriURL = map['favoriURL'];

  }
  @override
  String toString(){
    return 'Favori{favoriID: $favoriID, favoriMETIN: $favoriMETIN, favoriURL: $favoriURL}';
  }

}