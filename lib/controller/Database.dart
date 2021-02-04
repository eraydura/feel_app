import 'package:encrypt/encrypt.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:music/models/user.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

forgot(email,password) async {

    String _username = 'feel_app@outlook.com';
    String _password = 'Feelapp1997';

  final smtpServer = new SmtpServer('smtp.live.com',
      username: _username,
      password: _password,
      ignoreBadCertificate: true,
      ssl: false,
      allowInsecure: true);

  final equivalentMessage = Message()
    ..from = Address(_username, 'FeelApp')
    ..recipients.add(Address(email))
    ..subject = 'Changing Password :: 😀'
    ..html = "<h4>\n<p>Your New Password is below. </p> We prefer to change after used this password. </h4>\n<p>New password=  <b>${password}</b></p>";

  try {
    final sendReport = await send(equivalentMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

}

create(email,name) async {

  String _username = 'feel_app@outlook.com';
  String _password = 'Feelapp1997';

  final smtpServer = new SmtpServer('smtp.live.com',
      username: _username,
      password: _password,
      ignoreBadCertificate: true,
      ssl: false,
      allowInsecure: true);

  final equivalentMessage = Message()
    ..from = Address(_username, 'FeelApp')
    ..recipients.add(Address(email))
    ..subject = 'Welcome to our world :: 😀'
    ..html = "<h4>\n<p>Welcome our world $name </p> We hope you enjoy the application. </h4>\n<p>There is some information about application.</p><img style='width:100%;height:100%' src='https://m.feelapp.website/images/mail.PNG' alt='mail'>";

  try {
    final sendReport = await send(equivalentMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

}

encrypted(password) {
  final plainText = password;
  final key = Key.fromLength(32);
  final iv = IV.fromLength(8);
  final encrypter = Encrypter(Salsa20(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

class DatabaseHelper {

  var settings = new ConnectionSettings(
      host: 'sql430.main-hosting.eu',
      port: 3306,
      user: 'u353011324_eraydura',
      password: 'Feelapp_1997',
      db: 'u353011324_eraydura'
  );


  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  //insertion
  Future<void> saveUser(User user,String image,String now) async {

    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('INSERT INTO Users (email,name,password,picture,esong,dsong,csong,jsong,liked,last,date) values (?,?,?,?,?,?,?,?,?,?,?)', [user.email, user.name, user.password, image, user.e_songs, user.d_songs,user.c_songs,user.j_songs,user.last_song,user.liked_song,now]);
    create(user.email,user.name);
  }

  Future<void> deleteUser(String email) async {
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('DELETE FROM Users WHERE email= ?', [email]);
  }

  Future<void> uptade_picture(String image,String email) async {
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET picture = ? WHERE email = ?', [image,email]);
  }

  Future <void> uptade_password(String email, String password, bool forgotten) async{

    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET password = ? WHERE email = ?', [password, email]);

    if(forgotten=true) {
      forgot(email, password);
    }
  }

  Future <void> uptade_name(String name, String email) async{
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET name = ? WHERE email = ?', [name, email]);
  }

  Future <void> updateEmail(String change_email, String email) async{
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET email = ? WHERE email = ?', [change_email, email]);
  }

  Future <void> uptade_liked(String email,String song) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT liked FROM Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var songs = row_2[0].toString();
      var song_liked;
      if(!songs.contains(song)) {
        if (songs != "") {
          song_liked = songs + "," + song;
        }
        else {
          song_liked = song;
        }
        var result = await conn.query(
            'UPDATE Users SET liked = ? WHERE email = ?', [song_liked, email]);
      }
      else{

      }
    };
  }

  Future <void> delete_liked(String email,String song) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT liked FROM Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var songs = row_2[0].toString();
      var song_liked;

        if (songs != "") {
          var delete = songs.split(song);
          song_liked=delete[0]+delete[1];
        }
        else {
          song_liked = song;
        }
        var result = await conn.query('UPDATE Users SET liked = ? WHERE email = ?', [song_liked, email]);

    };
  }

  Future <void> uptade_songs(String email,String energetic,String dream,String joyful,String calm ) async{
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET esong = ?,jsong = ?,dsong=?,csong=? WHERE email = ?', [energetic,joyful,dream,calm,email]);
  }

  Future <void> uptade_last(String email,String artist) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT last FROM Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var songs = row_2[0].toString();
      var song_last;
        if(!songs.contains(artist)) {
          if (songs != null) {
            song_last = songs + "," + artist;
          }
          else {
            song_last = artist;
          }
          var result = await conn.query(
              'UPDATE Users SET last = ? WHERE email = ?', [song_last, email]);
        }
        else{

        }
      }
  }

  Future<bool> selectUser(String email,String password) async{

    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT * FROM Users WHERE email = ? and password = ?', [email,password]);
    if (maps.length > 0) {
      return true;
    }else {
      return false;
    }
  }

  Future<String> select_Date(String email) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT date FROM Users WHERE email = ? ', [email]);
    return maps.first[0].toString();
  }

  Future<String> select_Image(String email) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT picture FROM Users WHERE email = ? ', [email]);
    return maps.first[0].toString();
  }

  Future<bool> check_liked(String email,String songname) async{

    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT liked FROM Users WHERE email = ?', [email]);
    if (maps.first[0]!=null) {
      var likedsong=maps.first[0].toString().split(",");
      if(likedsong.contains(songname)){
        return true;
      }
      else{
        return false;
      }
    }else {
      return false;
    }
  }

  Future<List<String>> selectPlayer(String email) async{
    List <String> song=new List <String> ();

    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT esong,dsong,jsong,csong from Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var resourcee = row_2[0].toString();
      var resourcej = row_2[1].toString();
      var  resourced = row_2[2].toString() ;
      var resourcec = row_2[3].toString();

      var a= resourcee.split(",");
      var b =resourcej.split(",");
      var c= resourced.split(",");
      var d= resourcec.split(",");

      a.forEach((element) => song.add(element));
      b.forEach((element) => song.add(element));
      c.forEach((element) => song.add(element));
      d.forEach((element) => song.add(element));
    };
    return song;
  }
  Future<List<String>> select_liked(String email) async{
    List <String> song=new List <String> ();

    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT liked FROM Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var resourcee = row_2[0].toString();
      var a= resourcee.split(",");

      a.forEach((element) => song.add(element));

    };

    return song;
  }

  Future<List<String>> select_last(String email) async{
    List <String> song=new List <String> ();

    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT last FROM Users WHERE email = ?', [email]);

    for (var row_2 in maps) {
      var resourcee = row_2[0].toString();
      var a= resourcee.split(",");
      a.forEach((element) => song.add(element));
    };

    return song;
  }

  Future<bool> selectEmail(String email) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT email FROM Users WHERE email = ? ', [email]);
    if (maps.length > 0) {
      return true;
    }else {
      return false;
    }
  }

  Future<String> selectName(String email) async{
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT name FROM Users WHERE email = ? ', [email]);
    if (maps.length > 0) {
      return maps.first.toString();
    }else {
      return "Anonymous";
    }
  }

  Future<void> save_result(String user_email, int score) async {
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('INSERT INTO Game (email,result) values (?,?)', [user_email,score]);
  }


  Future<bool> check_game(String user_email) async {
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT email FROM Game WHERE email = ? ', [user_email]);
    if (maps.length > 0) {
      return true;
    }else {
      return false;
    }
  }

  Future<void> delete_searched(email) async {
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query('UPDATE Users SET searched = ? WHERE email = ?', [null,email]);
  }

  Future<void> save_searching(String email, String song_value) async {
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT searched FROM Users WHERE email = ? ', [email]);
    if (maps.first.length!=null) {
      var item=maps.first.toString();
      var items=item.toString().split("{")[1].split(":")[1].split("}")[0].split(",");
      if(!items.contains(song_value)) {
        var new_item;
        for (var i = 0; i < items.length; i++) {
          new_item = items[i].toString() + "," + song_value;
        }
        await conn.query('UPDATE Users SET searched = ? WHERE email = ?', [new_item, email]);
      }
    }else {
       await conn.query('UPDATE Users SET searched = ? WHERE email = ?', [song_value+",",email]);
    }
  }

  Future<String> searched_items(String user_email) async {
    var conn = await MySqlConnection.connect(settings);
    var maps = await conn.query('SELECT searched FROM Users WHERE email = ? ', [user_email]);
    if (maps.first.length!=null) {
      var item=null;
      for(var rows in maps){
        item=rows[0].toString();
      }
      return item;
    }
    else{
      return null;
    }
  }



}