import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:music/controller/Database.dart';
import 'package:music/models/artist_json.dart';
import 'package:music/views/authentification/Login.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Home.dart';
import 'navigator.dart';


class Searching_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder(
        future:  Future.wait([fetchartistcategory(http.Client())]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
            return Searching(category_2:snapshot.data[0]);
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Searching extends StatefulWidget {
  List<ArtistCategory> category_2;
  Searching({ this.category_2,Key key});

  @override
  Searching_State createState() => Searching_State( this.category_2);
}

class Searching_State extends State<Searching> {
  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 35),
      backgroundColor: Color(0xFF801E48),
      foregroundColor: Colors.white,
      overlayColor: Colors.black87,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.assignment_return),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              Navigator.of(context).pop();
            },
            label: 'Exit',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),
        SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              DatabaseHelper.internal().delete_searched(user_email);
            },
            label: 'Clear History',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),
      ],
    );
  }

  final List<ArtistCategory> category_2;
  Searching_State( this.category_2);



  @override
  Widget build(BuildContext context) {
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body:   Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .26,
                        spreadRadius: 0.0 * 1.5,
                        color: Color(0xff21254A).withOpacity(.6))
                  ],
                  color: Colors.white30,
                  borderRadius:
                  BorderRadius.all(Radius.circular(20)),
                ),
                child:Container(
                    child: new Theme(
                      data: new ThemeData(
                          primaryColor: Colors.white,
                          accentColor: Colors.pink,
                          hintColor: Colors.black87
                      ),
                      isMaterialAppTheme: true,
                      child: TextField(
                        enabled: true,
                        style: TextStyle(
                            fontSize: 15.0,
                            height: 3.0,
                            color: Colors.white
                        ),
                        onSubmitted: (value) {
                          if(value.isNotEmpty && value !=" ") {
                            setState(() {
                              song_title='';
                              song_value = value;
                              Home.globalKey.currentState.son();
                              Navigator.pop(context);
                            });
                          }
                          else{
                            Alert(
                              context: context,
                              type: AlertType.info,
                              title: "ALERT",
                              desc: "You should write something",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "COOL",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                  radius: BorderRadius.circular(0.0),
                                ),
                              ],
                            ).show();
                          }
                        },
                        textInputAction: TextInputAction.search,
                        keyboardAppearance: Brightness.dark,
                        cursorColor: Colors.white,
                        decoration: new InputDecoration(
                          icon: new Icon(Icons.search,color:Colors.white,size: 40,),
                          fillColor: Colors.transparent,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                          contentPadding:
                          const EdgeInsets.only( bottom: 5.0),
                        ),
                      ),
                    )
                )
            ),
          ),
          Container(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                 Text("Search Suggestions",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ],
            ),
          ),

          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child:ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: category_2 == null ? 0 : category_2.length,
                itemBuilder: (BuildContext context,int index) {
                  if (Home.globalKey.currentState.song != null) {
                    if (Home.globalKey.currentState.song.contains(category_2[index].title)) {
                      return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                        onTap: () {
                          setState(() {
                            song_title='';
                            song_value = category_2[index].title;
                            Home.globalKey.currentState.son();
                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                              NetworkImage(category_2[index].image),
                              backgroundColor: Colors.transparent,
                            ),
                              Text(category_2[index].title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),)
                          ],),
                          SizedBox(height: 20,)
                        ],)

                        ),);
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
        ],),
     floatingActionButton: buildSpeedDial(),
    );

  }
}



