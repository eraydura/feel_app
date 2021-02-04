import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music/models/album_json.dart';
import 'package:music/models/artist_json.dart';
import 'package:music/models/music_json.dart';
import 'package:music/views/pages/Home.dart';
import 'package:music/views/pages/navigator.dart';
import 'package:music/views/pages/player.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class Artist extends StatelessWidget {

  String title;
  Artist( this.title, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder<List<ArtistCategory>>(
        future: fetchartistcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MyHomePage2(this.title,category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  String title;
  List<ArtistCategory> category;
  MyHomePage2(this.title, {this.category});

  @override
  State<StatefulWidget> createState() {
    return ArtistCategoryList(this.title,this.category);
  }
}
class ArtistCategoryList extends State<MyHomePage2> {

  final List<ArtistCategory> category;
  String title;
  ArtistCategoryList(this.title,this.category);
  SolidController _controller = SolidController();
  double level = 0.0;
  String p='';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xff21254A),
            body: ListView.builder(
                  itemCount: category == null ? 0 : category.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (category[index].emotion.toUpperCase() == this.title.toUpperCase()) {
                      return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                        onTap: () {
                          setState(() {
                            p = category[index].title;
                          });
                        },
                        child: Container(
                          height: 250,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(category[index].image),
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
                                  category[index].title,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),));
                    }
                    else {
                      return new Container();
                    }
                  }
              ),
            bottomSheet: (){if(p!=''){ return SolidBottomSheet(
              controller: _controller,
              draggableBody: true,
              maxHeight: height-180,
              headerBar: Container(
                color: Theme.of(context).primaryColor,
                height: 40,
                child: Center(
                  child: Text(p.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              ),
              body: Album(p)
            );} else{
            };}(),

        )
    );
  }

}

class Album extends StatelessWidget {

  String title;
  Album( this.title, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder<List<AlbumCategory>>(
        future: fetchcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MyHomePage(this.title,category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  String title;
  List<AlbumCategory> category;
  MyHomePage(this.title, {this.category});

  @override
  State<StatefulWidget> createState() {
    return CategoryList(this.title,this.category);
  }
}
class CategoryList extends State<MyHomePage> {
  final List<AlbumCategory> category;
  String title;
  CategoryList(this.title, this.category);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
      return new MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xff21254A),
          body:  ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: category == null ? 0 : category.length,
          itemBuilder: (BuildContext context, int index) {
            if (category[index].album.toUpperCase() == this.title.toUpperCase()) {
              return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                  onTap: () {
                    setState(() {
                        song_value='';
                        song_title = category[index].title;
                        artist = category[index].album;
                        album = category[index].title;
                        song_name = category[index].title;
                        image = category[index].image;
                        Home.globalKey.currentState.son();
                    });
                  },
                  child: Container(
                    height: 250,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(category[index].image),
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
                            category[index].title,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),));
            }
            else {
              return new Container();
            }
          }
          ),
        )

      );

  }
  }


class Search extends StatelessWidget {
  String album;
  String title;
  Search(this.album,this.title);

  Widget body(){
    return new FutureBuilder<List<MusicCategory>>(
      future: fetchMusicCategory(http.Client()),
      builder: (context, snapshot2) {
        if (snapshot2.hasError) print(snapshot2.error);

        return snapshot2.hasData
            ? new Music_Page(this.album,this.title,music_2: snapshot2.data)
            : Center(child: CircularProgressIndicator());

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: body(),
    );
  }
}


class MyWebView extends StatelessWidget {
  String a;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  MyWebView(this.a);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
                child:SizedBox(
                    height: 500,
                    width: 500,
                    child:WebView(
                      initialUrl: 'http://eraydura.xyz/music4.php?p='+a,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    ))));

  }

}



class WebView_Main extends StatefulWidget {
  String song;
  String name;
  WebView_Main(this.song,this.name);

  @override
  Webview  createState() => Webview(this.song,this.name);
}

class Webview extends State<WebView_Main> {
  String song;
  String name;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  Webview(this.song,this.name);

  @override
  Widget build(BuildContext context) {
    print(song);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(name, style: TextStyle(color: Colors.black,fontSize: 10),),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xff21254A),
        body: WebView(
          initialUrl: song,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));

  }
}
class MyHomePage4 extends StatelessWidget {
  String hk;

  MyHomePage4(this.hk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder<List<MusicCategory>>(
        future: fetchMusicCategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ?  Music_Page2(this.hk, music: snapshot.data)
              : Center(child: CircularProgressIndicator());

        },
      ),
    );
  }
}