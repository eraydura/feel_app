import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/controller/Database.dart';
import 'package:music/controller/control_json.dart';
import 'package:music/models/player_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/models/music_json.dart';
import 'package:music/ui/player.dart';
import 'package:music/views/authentification/Login.dart';
import 'package:music/views/pages/Home.dart';
import 'package:music/views/pages/navigator.dart';

class Music_Page extends StatefulWidget {
  List<MusicCategory>music_2;
  String title;
  String album;
  String name;
  Music_Page( this.album,this.title,{Key key,  this.music_2});

  @override
  Music_State createState() => Music_State(this.music_2,this.album,this.title);
}

class Music_State extends State<Music_Page> {
  List<MusicCategory> music2=new List<MusicCategory>();
  List<MusicCategory>music;
  List<AudioSource> list = new List<AudioSource>();
  String title;
  String album;
  Music_State(this.music,this.album,this.title);
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    mainy();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _loadAudio();
  }

  _loadAudio() async {
    try {
      await _player.load( getTextWidgets(music2),);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }
  ConcatenatingAudioSource getTextWidgets(List<MusicCategory> strings)
  {
    for(var i=0; i<strings.length; i++) {
      list.add(AudioSource.uri(
        Uri.parse(
            music2[i].assetUrl),
        tag: AudioMetadata(
          album: music2[i].artist,
          title: music2[i].album,
          artwork:
          music2[i].image,
        ),
      ));
    }
    return ConcatenatingAudioSource(// gap between lines
        children: list);
  }
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xff21254A),
            key: _scaffoldKey,
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(

                    height: 2000,
                    child: StreamBuilder<SequenceState>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final sequence = state?.sequence ?? [];
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: sequence.length,
                          itemBuilder: (context, index) => Material(
                            color: index == state.currentIndex
                                ? Colors.black12
                                : null,
                            child: ListTile(
                              title:Column(
                                children: [
                                  Image.network(sequence[index].tag.artwork,width: 100,height: 100,),
                                  SizedBox(height: 15.0),
                                  Text('  '+sequence[index].tag.album+"-"+sequence[index].tag.title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 15.0),
                                ],),
                              onTap: () {
                                _player.seek(Duration.zero, index: index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),),
            body:Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StreamBuilder<SequenceState>(
                          stream: _player.sequenceStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final metadata = state.currentSource.tag as AudioMetadata;
                            if (state?.sequence?.isEmpty ?? true) {return SizedBox();} else{
                              _player.play();
                              DatabaseHelper.internal().uptade_last(user_email, metadata.album.toString());
                            };
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(metadata.artwork),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child:Column(

                                  children:

                                  ((){
                                    if(metadata.album=="Radios" ){
                                      return [

                                        Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover)),
                                        SizedBox(height: 16.0,),
                                        Text(metadata.title ?? '',
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black) ),
                                        RaisedButton(
                                          onPressed: (){
                                           return  showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  content: Builder(
                                                    builder: (context) {
                                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                      var height = MediaQuery.of(context).size.height;
                                                      var width = MediaQuery.of(context).size.width;

                                                      return Container(
                                                        height: height - 400,
                                                        width: width - 400,
                                                        child: MyWebView(metadata.title),
                                                      );
                                                    },
                                                  ),
                                                )
                                            );
                                          },
                                          color: Colors.black,
                                          child: new Text('Show the current song',style: TextStyle(color: Colors.white),),
                                        ),
                                        SizedBox(height: 16.0,),];
                                    }
                                    else{

                                      return  [

                                        Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover,)),
                                        SizedBox(height: 16.0,),
                                        Column(mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(metadata.album ?? '',
                                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white) ),
                                            Text(metadata.title+" "?? '',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                          ],),
                                            RaisedButton(
                                                child: Text("Like",style: TextStyle(color:  Colors.red,),),
                                                color:Colors.white,
                                                onPressed: () async {
                                                  bool a= await DatabaseHelper.internal().check_liked(user_email, metadata.album+"-"+metadata.title);
                                                  if(a!=true) {
                                                    DatabaseHelper.internal().uptade_liked(user_email, metadata.album + "-" + metadata.title);
                                                  }
                                                  else{
                                                    return showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Alert!'),
                                                            content: Text("You have liked this song before.",),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                  child: Text('OK')),
                                                              FlatButton(
                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                  child: Text('CANCEL')),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                }
                                            ),
                                        SizedBox(height: 16.0,),];
                                    }
                                  }()),


                                ));
                          },
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Column(children:[
                          ControlButtons(_player),
                          StreamBuilder<Duration>(
                            stream: _player.durationStream,
                            builder: (context, snapshot) {
                              final duration = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration>(
                                stream: _player.positionStream,
                                builder: (context, snapshot) {
                                  var position = snapshot.data ?? Duration.zero;
                                  if (position > duration) {
                                    position = duration;
                                  }
                                  return SeekBar(
                                    duration: duration,
                                    position: position,
                                    onChangeEnd: (newPosition) {
                                      _player.seek(newPosition);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            children: [
                              StreamBuilder<LoopMode>(
                                stream: _player.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data ?? LoopMode.off;
                                  const icons = [
                                    Icon(Icons.repeat, color: Colors.white),
                                    Icon(Icons.repeat, color: Colors.red),
                                    Icon(Icons.repeat_one, color: Colors.amberAccent),
                                  ];
                                  const cycleModes = [
                                    LoopMode.off,
                                    LoopMode.all,
                                    LoopMode.one,
                                  ];
                                  final index = cycleModes.indexOf(loopMode);
                                  return IconButton(
                                    icon: icons[index],
                                    onPressed: () {
                                      _player.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) %
                                          cycleModes.length]);
                                    },
                                  );
                                },
                              ),
                              Expanded(
                                child: IconButton(
                                    icon: Icon(Icons.queue_music ,color: Colors.red,),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    }),
                              ),
                              StreamBuilder<bool>(
                                stream: _player.shuffleModeEnabledStream,
                                builder: (context, snapshot) {
                                  final shuffleModeEnabled = snapshot.data ?? false;
                                  return IconButton(
                                    icon: shuffleModeEnabled
                                        ? Icon(Icons.shuffle, color: Colors.red)
                                        : Icon(Icons.shuffle, color: Colors.white),
                                    onPressed: () {
                                      _player.setShuffleModeEnabled(!shuffleModeEnabled);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                        ),
                      )])
            )));
  }
  mainy(){
    for(var i=0; i<music.length; i++){
      if(music[i].category==this.album && music[i].title==this.title){
        music2.add(music[i]);
      }
    }
  }


}

class Music_Page2 extends StatefulWidget {
  List<MusicCategory>music;
  String name;
  Music_Page2( this.name,{Key key,  this.music});

  @override
  Music2 createState() => Music2(this.name,this.music);
}

class Music2 extends State<Music_Page2> {
  List<MusicCategory> music2=new List<MusicCategory>();
  List<MusicCategory>music;
  List<AudioSource> list = new List<AudioSource>();
  String name;

  String artist;
  Music2(this.name,this.music);
  bool liked;
  AudioPlayer _player;

  @override
  void initState() {
    mainy();
    mainx();
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _loadAudio();
    _player.play();
  }

  _loadAudio() async {
    try {
      await _player.load( getTextWidgets(music2),);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }
  ConcatenatingAudioSource getTextWidgets(List<MusicCategory> strings)
  {
    for(var i=0; i<strings.length; i++) {
      list.add(AudioSource.uri(
        Uri.parse(
            music2[i].assetUrl),
        tag: AudioMetadata(
          album: music2[i].artist,
          title: music2[i].album,
          artwork:
          music2[i].image,
        ),

      ));
    }
    return ConcatenatingAudioSource(// gap between lines
        children: list);
  }
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xff21254A),
            key: _scaffoldKey,
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(

                    height: 2000,
                    child: StreamBuilder<SequenceState>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final sequence = state?.sequence ?? [];
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: sequence.length,
                          itemBuilder: (context, index) => Material(
                            color: index == state.currentIndex
                                ? Colors.black12
                                : null,
                            child: ListTile(
                              title:Column(
                                children: [
                                  Image.network(sequence[index].tag.artwork,width: 100,height: 100,),
                                  SizedBox(height: 15.0),
                                  Text('  '+sequence[index].tag.album+"-"+sequence[index].tag.title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 15.0),
                                ],),
                              onTap: () {
                                _player.seek(Duration.zero, index: index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),),
            body:Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StreamBuilder<SequenceState>(
                          stream: _player.sequenceStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final metadata = state.currentSource.tag as AudioMetadata;
                            if (state?.sequence?.isEmpty ?? true) {return SizedBox();} else{
                              _player.pause();
                              _player.play();
                              DatabaseHelper.internal().uptade_last(user_email, metadata.album.toString());
                            };
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(metadata.artwork),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child:Column(

                                  children:

                                  ((){
                                    if(metadata.album=="Radios" ){
                                      return [

                                        Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover)),
                                        SizedBox(height: 16.0,),
                                        Text(metadata.title ?? '',
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black) ),
                                        RaisedButton(
                                          onPressed: (){
                                            return showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  content: Builder(
                                                    builder: (context) {
                                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                      var height = MediaQuery.of(context).size.height;
                                                      var width = MediaQuery.of(context).size.width;

                                                      return Container(
                                                        height: height - 400,
                                                        width: width - 400,
                                                        child: MyWebView(metadata.title),
                                                      );
                                                    },
                                                  ),
                                                )
                                            );
                                          },
                                          color: Colors.black,
                                          child: new Text('Show the current song',style: TextStyle(color: Colors.white),),
                                        ),
                                        SizedBox(height: 16.0,),];
                                    }
                                    else{

                                      return  [

                                        Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover,)),
                                        SizedBox(height: 16.0,),
                                        Column(mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(metadata.album ?? '',
                                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white) ),
                                            Text(metadata.title+" "?? '',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                          ],),
                                        RaisedButton(
                                            child: Text("Like",style: TextStyle(color:  Colors.red,),),
                                            color:Colors.white,
                                            onPressed: () async {
                                              bool a= await DatabaseHelper.internal().check_liked(user_email, metadata.album+"-"+metadata.title);
                                              if(a!=true) {
                                                DatabaseHelper.internal().uptade_liked(user_email, metadata.album + "-" + metadata.title);
                                              }
                                              else{
                                                return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Alert!'),
                                                        content: Text("You have liked this song before.",),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () => Navigator.of(context).pop(),
                                                              child: Text('OK')),
                                                          FlatButton(
                                                              onPressed: () => Navigator.of(context).pop(),
                                                              child: Text('CANCEL')),
                                                        ],
                                                      );
                                                    });
                                              }
                                            }
                                        ),
                                        SizedBox(height: 16.0,),];
                                    }
                                  }()),


                                ));
                          },
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Column(children:[
                          ControlButtons(_player),
                          StreamBuilder<Duration>(
                            stream: _player.durationStream,
                            builder: (context, snapshot) {
                              final duration = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration>(
                                stream: _player.positionStream,
                                builder: (context, snapshot) {
                                  var position = snapshot.data ?? Duration.zero;
                                  if (position > duration) {
                                    position = duration;
                                  }
                                  return SeekBar(
                                    duration: duration,
                                    position: position,
                                    onChangeEnd: (newPosition) {
                                      _player.seek(newPosition);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            children: [
                              StreamBuilder<LoopMode>(
                                stream: _player.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data ?? LoopMode.off;
                                  const icons = [
                                    Icon(Icons.repeat, color: Colors.white),
                                    Icon(Icons.repeat, color: Colors.red),
                                    Icon(Icons.repeat_one, color: Colors.amberAccent),
                                  ];
                                  const cycleModes = [
                                    LoopMode.off,
                                    LoopMode.all,
                                    LoopMode.one,
                                  ];
                                  final index = cycleModes.indexOf(loopMode);
                                  return IconButton(
                                    icon: icons[index],
                                    onPressed: () {
                                      _player.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) %
                                          cycleModes.length]);
                                    },
                                  );
                                },
                              ),
                              Expanded(
                                child: IconButton(
                                    icon: Icon(Icons.queue_music ,color: Colors.red,),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    }),
                              ),
                              StreamBuilder<bool>(
                                stream: _player.shuffleModeEnabledStream,
                                builder: (context, snapshot) {
                                  final shuffleModeEnabled = snapshot.data ?? false;
                                  return IconButton(
                                    icon: shuffleModeEnabled
                                        ? Icon(Icons.shuffle, color: Colors.red)
                                        : Icon(Icons.shuffle, color: Colors.white),
                                    onPressed: () {
                                      _player.setShuffleModeEnabled(!shuffleModeEnabled);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                        ),
                      )])
            )));
  }
  mainy() {
    for(var i=0; i<music.length; i++){
      if(music[i].category.toUpperCase().contains(this.name.toUpperCase()) || music[i].category.toUpperCase().contains(this.name.toUpperCase()) || music[i].title.toUpperCase().contains(this.name.toUpperCase())  ){
        music2.add(music[i]);
        DatabaseHelper.internal().save_searching(user_email,music[i].artist);
      }
    }
  }

  mainx() {
    if(music2.isEmpty){
      setState(() {
        song_value="";
        Home.globalKey.currentState.son();
      });
    }
  }


}





