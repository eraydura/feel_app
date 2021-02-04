class User {
  String email;
  String name;
  String password;
  String j_songs;
  String e_songs;
  String d_songs;
  String c_songs;
  String liked_song;
  String last_song;


  User(this.email, this.name, this.password,this.e_songs,this.j_songs,this.d_songs,this.c_songs,this.liked_song,this.last_song);

  User.map(dynamic obj) {
    this.email = obj['email'];
    this.name = obj['name'];
    this.password = obj['password'];
    this.j_songs = obj['j_songs'];
    this.c_songs = obj['c_songs'];
    this.last_song= obj['last_song'];
    this.e_songs = obj['e_songs'];
    this.d_songs = obj['d_songs'];
    this.liked_song = obj['liked_song'];
  }



  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map['j_songs']= j_songs ;
    map['c_songs']= c_songs ;
    map['e_songs']= e_songs;
    map['d_songs']=d_songs ;
    map['liked_song']=liked_song ;
    map['last_song']=last_song ;
    return map;
  }
}