class Ilan{

  int ilanID;
  int favoriID;
  String ilanURL;
  String ilanAD;
  String ilanFIYAT;
  String ilanTARIH;
  String iLILCE;
  int ilanSahibindenID;
  String ilanResimUrl;
  int ilanOkundumu;
  String favoriMETIN;

  Ilan(this.favoriID, this.ilanURL, this.ilanAD, this.ilanFIYAT, this.ilanTARIH, this.iLILCE, this.ilanSahibindenID, this.ilanResimUrl, this.ilanOkundumu);
  Ilan.withID(this.ilanID, this.favoriID, this.ilanURL, this.ilanAD, this.ilanFIYAT, this.ilanTARIH, this.iLILCE, this.ilanSahibindenID, this.ilanResimUrl, this.ilanOkundumu);
  Ilan.withoutID(this.ilanURL, this.ilanAD, this.ilanFIYAT, this.ilanTARIH, this.iLILCE, this.ilanSahibindenID, this.ilanResimUrl, this.ilanOkundumu);
  Ilan.withFavoriMETIN(this.favoriID, this.ilanURL, this.ilanAD, this.ilanFIYAT, this.ilanTARIH, this.iLILCE, this.ilanSahibindenID, this.ilanResimUrl, this.ilanOkundumu, this.favoriMETIN);

    Map<String, dynamic> toMap (){
    var map = Map<String, dynamic>();
    map['ilanID'] = ilanID;
    map['favoriID'] = favoriID;
    map['ilanURL'] = ilanURL;
    map['ilanAD'] = ilanAD;
    map['ilanFIYAT'] = ilanFIYAT;
    map['ilanTARIH'] = ilanTARIH;
    map['ilanILILCE'] = iLILCE;
    map['ilanSahibindenID'] = ilanSahibindenID;
    map['ilanResimUrl'] = ilanResimUrl;
    map['ilanOkundumu'] = ilanOkundumu;


    return map;
  }

  Ilan.fromMap(Map<String, dynamic> map){
    this.ilanID = map['ilanID'];
    this.favoriID = map['favoriID'];
    this.ilanURL = map['ilanURL'];
    this.ilanAD = map['ilanAD'];
    this.ilanFIYAT = map['ilanFIYAT'];
    this.ilanTARIH = map['ilanTARIH'];
    this.iLILCE = map['ilanILILCE'];
    this.ilanSahibindenID = map['ilanSahibindenID'];
    this.ilanResimUrl = map['ilanResimUrl'];
    this.ilanOkundumu = map['ilanOkundumu'];
    this.favoriMETIN = map['favoriMETIN'];
  }  
  @override
  String toString(){
    return 'Favori{ilanID: $ilanID, favoriID: $favoriID, ilanURL: $ilanURL, ilanAD: $ilanAD, ilanFIYAT: $ilanFIYAT, ilanTARIH: $ilanTARIH, iLILCE: $iLILCE, ilanSahibindenID: $ilanSahibindenID, ilanResimUrl: $ilanResimUrl, ilanOkundumu: $ilanOkundumu, favoriMETIN: $favoriMETIN}';
  }

  


}