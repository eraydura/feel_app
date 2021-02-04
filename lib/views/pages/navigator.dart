import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:music/controller/Database.dart';
import 'package:music/views/authentification/Login.dart';
import 'package:music/views/authentification/Profile_change.dart';
import 'package:music/views/authentification/survey.dart';
import 'package:music/ui/info.data.dart';
import 'Feelingsearch.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Searching.dart';
import 'find_song.dart';
import 'music_game.php.dart';

class Navigate extends StatefulWidget {
  @override
  Navigator_Page createState() => Navigator_Page ();
}
String song_title ='';
String song_value ='';
String artist='';
String album='';
String image='';
String song_name ='';

class Navigator_Page extends State<Navigate> {

  check(context) async {
    bool check= await DatabaseHelper.internal().selectEmail(user_email);

    if(check) {
      entry_date=await DatabaseHelper.internal().select_Date(user_email);
    }
    else{
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Artist_Json()),
                (Route<dynamic> route) => false);
      });
    }
  }
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
            child: Icon(Icons.exit_to_app),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInDemo("close")),
              );
            },
            label: 'Exit',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),

        SpeedDialChild(
            child: Icon(Icons.info),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: InfoPage(),
                  );
                },
              );
            },
            label: 'Credit',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),

        SpeedDialChild(
            child: Icon(Icons.account_circle),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: Profile_json(),
                  );
                },
              );
            },
            label: 'Profile',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),

        SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: Profile_Change(),
                  );
                },
              );
            },
            label: 'Customize',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),

        SpeedDialChild(
            child: Icon(Icons.face),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: Feeling_Search(),
                  );
                },
              );
            },
            label: 'Mood',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),


        SpeedDialChild(
            child: Icon(Icons.find_replace),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: MyApp(),
                  );
                },
              );
            },
            label: 'Recognize',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),


        SpeedDialChild(
            child: Icon(Icons.search),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => Searching_Page(),
                ),
              );
            },
            label: 'Search',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),

        SpeedDialChild(
            child: Icon(Icons.videogame_asset),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              BuildContext dialogContext;
              return showDialog(
                context: context,
                useRootNavigator: false,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    child: Game_Json(),
                  );
                },
              );
            },
            label: 'Game',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final double _panelMaxSize = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: buildSpeedDial(),
      body: Home_json(),
    );
  }
  @override
  void initState() {
    super.initState();
    check(context);
  }
}
