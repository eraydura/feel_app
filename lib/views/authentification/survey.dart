import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:music/controller/Database.dart';
import 'package:music/models/artist_json.dart';
import 'package:music/models/user.dart';
import 'package:music/views/pages/navigator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Login.dart';

class Artist_Json extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder<List<ArtistCategory>>(
        future: fetchartistcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? GetCheckValue(category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class GetCheckValue extends StatefulWidget {
  List<ArtistCategory> category;
  GetCheckValue( {this.category});

  @override
  State<StatefulWidget> createState() {
    return GetCheckValueState(this.category);
  }
}

class GetCheckValueState extends State<GetCheckValue> {
  List<ArtistCategory> category;
  GetCheckValueState(this.category);

  Widget first(){
    return Column(
      children: <Widget>[
      Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            child:
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://github.com/oliver-gomes/flutter-loginui/blob/master/assets/images/1.png?raw=true'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        Expanded(
          child: Center(
            child: Text("Let's learn more about you",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
        ),
        Expanded(
            child: Center(
            child:Container(
              width: 100.0,
              height: 100.0,
                child:ClipOval(
                child: RaisedButton(
                      child: Text('Start'),
                      color: Colors.pink[200],
                      onPressed: () async {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Energetic(this.category),
                            ));
                      }),
              ),
            ),
          ),
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body:  first()
    );
  }
}
List<String> energetic=new List<String>();
List<String> dream=new List<String>();
List<String> calm=new List<String>();
List<String> joyful=new List<String>();

class Energetic extends StatefulWidget {
  List<ArtistCategory> category;
  Energetic(this.category);

  @override
  State<StatefulWidget> createState() {
    return Energetic_Selection(this.category);
  }
}


class Energetic_Selection extends State<Energetic> {
  var a=[];
  List<String> selected=[];
  List<ArtistCategory> category;
  Energetic_Selection(this.category);

  @override
  Widget build(BuildContext context) {
    for(int i=0; i<category.length; i++){
      a.add(false);
    }
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
        Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[Center(
            child: Text("What artist do you listen when you are",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),Center(
            child: Text("ENERGETIC",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                )),
          ),]
        )),

        Expanded(
          flex: 4,
          child:ListView.builder(
            itemCount: category == null ? 0 : category.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
                 if (category[index].emotion == "Energetic" && !category[index].title.contains("Radios")) {
                  bool c = a[index];
                  return Container(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!selected.contains(category[index].title)) {
                                selected.add(category[index].title);
                                a[index] = true;
                              }
                              else {
                                selected.remove(category[index].title);
                                a[index] = false;
                              }
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Card(
                              color: Color(0xff21254A),
                              margin: EdgeInsets.all(20.0),
                              child: CircleAvatar(
                                backgroundColor: c ? Colors.green : Colors
                                    .red,
                                radius: 110.0,
                                child:CircleAvatar(
                                  child: ClipOval(
                                    child: Image.network(
                                      category[index].image,
                                      width: 500,
                                      height: 500,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  radius: 100.0,
                                ),
                              )
                          ),
                            Text(category[index].title.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15.0),)
                          ],)
                      )
                  );
                }}),
              ),
            SizedBox(height: 10),
        RaisedButton(   color: Colors.pink,onPressed: () {
          if(!selected.isEmpty) {
            energetic=selected;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calm(this.category),
                ));
          }
          else{
            Alert(
              context: context,
              type: AlertType.info,
              title: "ALERT",
              desc: "You should choose at least one artist",
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
        }, child: Text('Continue',style: TextStyle(color:Colors.black ))),
        SizedBox(height: 100,),
      ],
    )
    );
  }

}


class Calm extends StatefulWidget {
  List<ArtistCategory> category;
  Calm(this.category);

  @override
  Calm_Selection createState() {
    return new Calm_Selection(this.category);
  }
}

class Calm_Selection extends State<Calm> {
  var a=[];
  List<String> selected=[];
  List<ArtistCategory> category;
  Calm_Selection( this.category);

  @override
  Widget build(BuildContext context) {
    for(int i=0; i<category.length; i++){
      a.add(false);
    }
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Expanded(
                flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Center(
                  child: Text("What artist do you listen when you are",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),Center(
                  child: Text("CALM",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      )),
                ),]
                )),

              Expanded(
                flex: 4,
                    child:ListView.builder(
                      itemCount: category == null ? 0 : category.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                       if (category[index].emotion == "Calm"&& !category[index].title.contains("Radios")) {
                      bool c = a[index];
                      return Container(
                              child:
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (!selected.contains(category[index].title)) {
                                        selected.add(category[index].title);
                                        a[index] = true;
                                      }
                                      else {
                                        selected.remove(category[index].title);
                                        a[index] = false;
                                      }
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Card(
                                        color: Color(0xff21254A),
                                        margin: EdgeInsets.all(20.0),
                                        child: CircleAvatar(
                                          backgroundColor: c ? Colors.green : Colors
                                              .red,
                                          radius: 110.0,
                                          child:CircleAvatar(
                                            child: ClipOval(
                                              child: Image.network(
                                                category[index].image,
                                                width: 500,
                                                height: 500,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            radius: 100.0,
                                          ),
                                        )
                                    ),
                                    Text(category[index].title.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15.0),)
                                  ],)
                              )
                          );
                        }else{return new Container();}}),
                      ),
            SizedBox(height: 10),
            RaisedButton(
                color: Colors.pink,
                onPressed: () {
              if(!selected.isEmpty) {
                calm=selected;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dreamy(this.category),
                    ));
              }
              else{
                Alert(
                  context: context,
                  type: AlertType.info,
                  title: "ALERT",
                  desc: "You should choose at least one artist",
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
            }, child: Text('Continue',style: TextStyle(color:Colors.black ))),
            SizedBox(height: 100,),
          ],
        )
    );
  }

}

class Dreamy extends StatefulWidget {
  List<ArtistCategory> category;
  Dreamy(this.category);

  @override
  Dreamy_Selection createState() {
    return new Dreamy_Selection(this.category);
  }
}

class Dreamy_Selection extends State<Dreamy> {
  var a=[];
  List<String> selected=[];
  List<ArtistCategory> category;
  Dreamy_Selection( this.category);

  @override
  Widget build(BuildContext context) {
    for(int i=0; i<category.length; i++){
      a.add(false);
    }
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Expanded(
              flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Center(
                  child: Text("What artist do you listen when you are",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                 ),Center(
                  child: Text("DREAMY",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      )),
                ),]
                )),

                 Expanded(
                   flex: 4,
                    child:ListView.builder(
                       itemCount: category == null ? 0 : category.length,
                       scrollDirection: Axis.horizontal,
                       itemBuilder: (BuildContext context, int index) {
                      if (category[index].emotion == "Dreamy"&& !category[index].title.contains("Radios")) {
                       bool c = a[index];
                      return Container(
                              child:
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (!selected.contains(category[index].title)) {
                                        selected.add(category[index].title);
                                        a[index] = true;
                                      }
                                      else {
                                        selected.remove(category[index].title);
                                        a[index] = false;
                                      }
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Card(
                                        color: Color(0xff21254A),
                                        margin: EdgeInsets.all(20.0),
                                        child: CircleAvatar(
                                          backgroundColor: c ? Colors.green : Colors
                                              .red,
                                          radius: 110.0,
                                          child:CircleAvatar(
                                            child: ClipOval(
                                              child: Image.network(
                                                category[index].image,
                                                width: 500,
                                                height: 500,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            radius: 100.0,
                                          ),
                                        )
                                    ),
                                    Text(category[index].title.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15.0),)
                                  ],)
                              )
                          );
                        }else{return new Container();}})
                      ),
            SizedBox(height: 10),
            RaisedButton( color: Colors.pink, onPressed: () {
              if(!selected.isEmpty) {
                dream=selected;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Joyful(this.category),
                    ));
              }
              else{
                Alert(
                  context: context,
                  type: AlertType.info,
                  title: "ALERT",
                  desc: "You should choose at least one artist",
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
            }, child: Text('Continue',style: TextStyle(color:Colors.black ))),
            SizedBox(height: 100,),
          ],
        )
    );
  }

}

class Joyful extends StatefulWidget {
  List<ArtistCategory> category;
  Joyful(this.category);

  @override
  Joyful_select createState() {
    return new Joyful_select(this.category);
  }
}

class Joyful_select extends State<Joyful> {
  var a=[];
  List<String> selected=[];
  List<ArtistCategory> category;
  Joyful_select( this.category);

  @override
  Widget build(BuildContext context) {
    for(int i=0; i<category.length; i++){
      a.add(false);
    }
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Expanded(
                flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Center(
                  child: Text("What artist do you listen when you are",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),Center(
                  child: Text("JOYFUL",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      )),
                ),]
                )),

                Expanded(
                  flex: 4,
                      child:ListView.builder(
                        itemCount: category == null ? 0 : category.length,
                         scrollDirection: Axis.horizontal,
                         itemBuilder: (BuildContext context, int index) {
                         if (category[index].emotion == "Joyful"&& !category[index].title.contains("Radios")) {
                         bool c = a[index];
                         return Container(
                              child:
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (!selected.contains(category[index].title)) {
                                        selected.add(category[index].title);
                                        a[index] = true;
                                      }
                                      else {
                                        selected.remove(category[index].title);
                                        a[index] = false;
                                      }
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Card(
                                        color: Color(0xff21254A),
                                        margin: EdgeInsets.all(20.0),
                                        child: CircleAvatar(
                                          backgroundColor: c ? Colors.green : Colors
                                              .red,
                                          radius: 110.0,
                                          child:CircleAvatar(
                                            child: ClipOval(
                                              child: Image.network(
                                                category[index].image,
                                                width: 500,
                                                height: 500,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            radius: 100.0,
                                          ),
                                        )
                                    ),
                                    Text(category[index].title.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15.0),)
                                  ],)
                              )
                          );
                        }else{return new Container();}}),
                      ),
            SizedBox(height: 10),
            RaisedButton(   color: Colors.pink,onPressed: () {
              if(!selected.isEmpty) {
                joyful=selected;
                User user=new User(user_email,user_name,user_password,energetic.join(","), dream.join(","), joyful.join(","), calm.join(","),null,null);
                var now = new DateTime.now();
                var date= now.toString().split(" ")[0];
                DatabaseHelper.internal().saveUser(user,user_image,date);
                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Good",
                  desc: "We have learned so many things about you.",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "COOL",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () =>  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Navigate(),
                          )),
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                      radius: BorderRadius.circular(0.0),
                    ),
                  ],
                ).show();
              }
              else{
                Alert(
                  context: context,
                  type: AlertType.info,
                  title: "ALERT",
                  desc: "You should choose at least one artist",
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
            }, child: Text('Continue',style: TextStyle(color:Colors.black ))),
            SizedBox(height: 100,),
          ],
        )
    );
  }

}