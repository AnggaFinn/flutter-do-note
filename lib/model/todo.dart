class Todo{

  int _id;
  String _judul;
  String _deskripsi;
  String _tanggal;
  int _prioritas;

  //Construktor
  Todo(this._judul, this._tanggal, this._prioritas, [this._deskripsi]);
  Todo.withId(this._id, this._judul, this._tanggal, this._prioritas, [this._deskripsi]);

  //Getter
  int get id => _id;
  String get judul => _judul;
  String get deskripsi => _deskripsi;
  String get tanggal => _tanggal;
  int get prioritas => _prioritas;

  //Setter
  set judul(String newJudul){
    _judul = newJudul;
  }

  set deskripsi(String newDeskripsi){
    _deskripsi = newDeskripsi;
  }

  set tanggal(String newTanggal){
    _tanggal = newTanggal;
  }

  set prioritas(int newPrioritas){
    if (newPrioritas>=1 && newPrioritas<=2) {
      _prioritas = newPrioritas;
    }
  }

  // Todo object masukan ke dalam map
  Map <String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["judul"] = _judul;
    map["deskripsi"] = _deskripsi;
    map["prioritas"] = _prioritas;
    map["tanggal"] = _tanggal;
    if(_id != null){
      map["id"] = _id;
    }
    return map;
  }

  // Constraktor objek todo dari map object
  Todo.fromObject(Map<String, dynamic> map){
    this._id = map["id"];
    this._judul = map["judul"];
    this._deskripsi = map["deskripsi"];
    this._tanggal = map["tanggal"];
    this._prioritas = map["prioritas"];
  }

}