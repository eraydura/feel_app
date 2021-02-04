import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/acrcloud_response.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:music/controller/control_json.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_api/youtube_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ACRCloudResponseMusicItem music;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  static String key = 'AIzaSyCZFhZ2QH6tDagEXluNhe6vMt0MUZqb0oA';
  YoutubeAPI ytApi = new YoutubeAPI(key);
  List<YT_API> ytResult = [];
  String url;

  @override
  void initState() {
    super.initState();
    ACRCloud.setUp(ACRCloudConfig('2859269f958069324318e00f2f08dc69', 'E5roEwqTP63o52XBgWEiU5UqlZk8RhfbSYqlj3d9', 'identify-eu-west-1.acrcloud.com'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(49, 39, 79, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                  builder: (context) =>
                      Container(
                      width: 200.0,
                      height: 200.0,
                          child:ClipOval(
                              child: RaisedButton(
                      color: Colors.pink[200],
                      onPressed: () async {
                        setState(() {
                          music = null;
                        });

                        final session = ACRCloud.startSession();
                        BuildContext dialogContext;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                            builder: (dialogContext) =>
                                AlertDialog(
                                  title: Text('Listening...'),
                                  actions: [
                                    FlatButton(
                                      child: Text('Close me!'),
                                      onPressed: () {
                                        session.cancel();
                                        Navigator.of( dialogContext).pop();
                                      },
                                    )
                                  ],
                                )
                        );

                        final result = await session.result;
                        Navigator.of(context, rootNavigator: true).pop();

                        String query = result.metadata.music.first.title;
                        ytResult = await ytApi.search(query);

                        setState((){

                          if (result == null) {
                            // Cancelled
                            return;
                          } else if (result.metadata == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('No result'),
                            ));
                            return;
                          }
                          music = result.metadata.music.first;
                          url=ytResult[0].url;
                        });
                      },
                      child: Text('Listen',style: TextStyle(
                        fontSize: 25.0, // insert your font size here
                      ),))))),
              SizedBox(height: 150),
              if (music != null) Text('${music.artists.first.name}\n',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15) ),
              if (music != null) Text('${music.title}\n', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15) ),
              if (music != null) Text('Album: ${music.album.name}\n',style: TextStyle(color: Colors.white,fontSize: 15) ),
              SizedBox(height: 20),
              if(url!=null) RaisedButton(child: Text("Show video",style: TextStyle(color: Colors.pink),),
                color: Colors.white70,
                onPressed: () {
                 var name=music.artists.first.name+"-"+music.title;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebView_Main(url,name)),
                  );
              },)
            ],
          ),
        ),
      ),
    );
  }
}