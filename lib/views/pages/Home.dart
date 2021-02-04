import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music/controller/control_json.dart';
import 'package:music/models/artist_json.dart';
import 'package:music/models/music_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:music/controller/Database.dart';
import '../authentification/Login.dart' ;
import 'navigator.dart';

class Home_json extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder(
        future:  Future.wait([fetchMusicCategory(http.Client()),fetchartistcategory(http.Client())]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
               return Home(category: snapshot.data[0],category_2:snapshot.data[1]);
        }
          else{
                return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  static final GlobalKey<Home_Page> globalKey = GlobalKey();
  List<ArtistCategory> category_2;
  List<MusicCategory> category;
  Home({this.category, this.category_2,Key key}): super(key: globalKey);

  @override
  Home_Page createState() => Home_Page( this.category,this.category_2);
}

class Home_Page extends State<Home> {
  SolidController _controller = SolidController();
  final List<ArtistCategory> category_2;
  final List<MusicCategory> category;
  List <String> song=null;
  String email;
  Home_Page( this.category,this.category_2);

  _setlogin(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("email", email) ;
    });
  }

  _loadlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
  }

  @override
  void initState() {
   if(user_email!=null ){
      _setlogin(user_email);
      setState(() {
        email=user_email;
      });
    }
    else{
      _loadlogin();
    }
    son();
  }

  Future<void> son() async {
    List<String> songs_selected= await DatabaseHelper.internal().selectPlayer(email);
    List<String> songs_last= await DatabaseHelper.internal().select_last(email);
    String a= await DatabaseHelper.internal().searched_items(email);
    var new_item=a.split(",");
    List<String> searching=new List<String>();
    for(var i=0; i<new_item.length;i++){
      searching.add(new_item[i]);
    }
    setState(() {
      song = searching+songs_last+songs_selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body:   Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                reverse: true,
                physics: ClampingScrollPhysics(),
                itemCount: category_2 == null ? 0 : category_2.length,
                itemBuilder: (BuildContext context,int index) {
                  if (song != null) {
                    if (song.contains(category_2[index].title)) {
                      return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                        onTap: () {
                          setState(() {
                            BuildContext dialogContext;
                            return showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                dialogContext = context;
                                return Dialog(
                                  child: Album(category_2[index].title),
                                );
                              },
                            );
                          });
                        },
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(category_2[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ClipRRect( // make sure we apply clip it properly
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey.withOpacity(0.05),
                                child: Text(
                                  category_2[index].title,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),));
                    }
                    else {
                      return Container();
                    }
                  }
                  else{
                  return Container();
                  }
                }
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: category == null ? 0 : category.length,
                itemBuilder: (BuildContext context, int index) {
                  if (song != null) {
                    if (!song.contains(category[index].artist.toString())) {
                      return Container();
                    }
                    if (song == null) {
                      return Container();
                    }
                    else {
                      return Padding(
                          padding: EdgeInsets.all(50.0), child: InkWell(
                        onTap: () {
                          setState(() {
                            song_value='';
                            song_title = category[index].title;
                            artist = category[index].category;
                            album = category[index].title;
                            song_name=category[index].album;
                            image = category[index].image;
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
                        ),));
                    }
                  }
                  else {
                    return Container();
                  }
                }

            ),
          ),
    ],),
        bottomSheet: (){

        if(song_title!=''){
          return SolidBottomSheet(
        controller: _controller,
        toggleVisibilityOnTap: true,
        showOnAppear: true,
        maxHeight: _panelMaxSize-100,
        headerBar: Container(
            color: Colors.black,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[CircleAvatar(
              radius: 25.0,
              backgroundImage:
              NetworkImage(image),
              backgroundColor: Colors.transparent,

            ),SizedBox(width: 70,),
              Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                Text(artist,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                Text(song_name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),],),
            ])),
        body: new Search(artist,song_title)
    );}
    else if(song_value!=''){
          return SolidBottomSheet(
              controller: _controller,
            toggleVisibilityOnTap: true,
              maxHeight: _panelMaxSize-100,
              headerBar: Container(
                  color: Colors.black,
                  height: 70,
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                          Text("The Results Of " +song_value,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                        ],),
                      ])
                      ),
              body: new MyHomePage4(song_value),
          );
        }
    else{
    };}(),
    );

  }
}



