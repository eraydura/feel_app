import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music/models/music_json.dart';
import 'Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:music/controller/Database.dart';
import '../authentification/Login.dart' ;
import 'navigator.dart';

class Profile_json extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder(
        future:  Future.wait([fetchMusicCategory(http.Client())]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
            return Profile(category: snapshot.data[0]);
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Profile extends StatefulWidget {
  static final GlobalKey<Profile_Page> globalKey = GlobalKey();
  List<MusicCategory> category;
  Profile({this.category,Key key}): super(key: globalKey);

  @override
  Profile_Page createState() => Profile_Page( this.category );
}

class Profile_Page extends State<Profile> {
  SolidController _controller = SolidController();
  final List<MusicCategory> category;
  List <String> song=null;
  String email;
  String name;
  var deleted=[];
  Profile_Page( this.category);
  final Navigator_Page myController = Navigator_Page();
  _setlogin(email,name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("email", email) ;
      prefs.setString("name", name) ;
    });
  }

  _loadlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
      name = prefs.getString("name");
    });
  }

  @override
  void initState() {
    super.initState();
    if(user_email!=null && user_name!=null){
      _setlogin(user_email,user_name);
      setState(() {
        email=user_email;
        name=user_name;
      });
    }
    else{
      _loadlogin();
    }
    son();
  }

  Future<void> son() async {
    List<String> songs_selected= await DatabaseHelper.internal().select_liked(email);
    setState(() {
      song = songs_selected;
      for(int i=0; i<category.length; i++){
        deleted.add(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body:   Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 1,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ CircleAvatar(
                radius: 50.0,
                backgroundImage:
                NetworkImage(user_image),
                backgroundColor: Colors.transparent,
              ),
                ],),
            ),
            list(category,song),
          ],),
    );

  }
  void _toggle(index){
     if(deleted[index]==true){
       setState(() {
         deleted[index]=false;
       });
     }
   }
  list(category,song){
    return Expanded(
      flex: 3,
      child:ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: category == null ? 0 : category.length,
          itemBuilder: (BuildContext context, int index) {
            if (song != null) {
              if (!song.contains(category[index].artist+"-"+category[index].album)) {
                return Container();
              }
              else {
                  return Visibility(visible: deleted[index],
                      child:Column(
                      children: [
                        Container(
                            width: 300,
                            height: 300,
                            child: Padding(
                                padding: EdgeInsets.all(50.0), child: InkWell(
                              onTap: () {
                                setState(() {
                                  song_value = '';
                                  song_title = category[index].title;
                                  artist = category[index].artist;
                                  album = category[index].album;
                                  song_name = category[index].album;
                                  image = category[index].image;
                                  Home.globalKey.currentState.son();
                                });
                              },
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(category[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: ClipRRect( // make sure we apply clip it properly
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.5, sigmaY: 2.5),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.grey.withOpacity(0.05),
                                      child: Text(
                                        category[index].artist + '-' +
                                            category[index].album,
                                        style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              child: Text("Delete", style: TextStyle(
                                  color: Colors.white),),
                              color: Colors.red,
                              onPressed: () {
                                DatabaseHelper.internal().delete_liked(
                                    user_email, category[index].artist + "-" +
                                    category[index].album);
                                _toggle(index);
                              },
                            )
                          ],

                        )
                      ]
                  ));
                }
            }
            else{
              return Container();
            }
          }
      ),
    );
  }
}


