import 'dart:async';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:music/controller/Database.dart';
import 'package:music/models/game_json.dart';
import 'package:music/views/authentification/Login.dart';

class Game_Json extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder<List<GameCategory>>(
        future: fetchcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? Question(category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Question extends StatefulWidget {
  List<GameCategory> category;
  Question({this.category});

  @override
  State<StatefulWidget> createState() {
    return Selections(this.category);
  }
}

var correct_answers=[];
var answers=[];

class Selections extends State<Question> {
  bool start=false;
  bool result_page=false;
  bool check_user=false;
  int score=0;
  String result;
  var count=1;

  check() async {
    bool a= await DatabaseHelper.internal().check_game(user_email);
    setState(() {
      check_user=a;
    });
    if(check_user==false){
      for(int i=0; i<category.length;i++){
        correct_answers.add(category[i].answer);
      }
    }
    else{

    }
  }
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
              child: Text(check_user==false ? "Let's start on Game": "You have played before",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(children: [
                Text(check_user==false ? "First place wins concert ticket.": "We will announce if you win",
                      style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                )),
                Text(check_user==false ? "": "Wait new games!",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                ],)
            ),
          ),
          check_user==false ?
           new Expanded(
            child: Center(
              child:Container(
                width: 100.0,
                height: 100.0,
                child:ClipOval(
                  child: RaisedButton(
                      child: Text('Start'),
                      color: Colors.pink[200],
                      onPressed: (){
                        setState(() {
                          start=true;
                          startTimeout();
                        });
                      }),
                ),
              ),
            ),
          ) : new  Container(),
        ]
    );
  }

  List<GameCategory> category;
  var idx=0;
  bool open=false;
  Selections(this.category);
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 90;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        if(timer.tick.toString()=="90"){
           setState(() {
             result_page=true;
           });
        }
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }
  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body: ((){
                if(result_page==true){
                  return third();
                }
               else if(start==true){
                 return second();
               }
               else{
                 return first();
               }
              }())
    );
  }

  Widget second(){
    return Column(
        children: <Widget>[
          SizedBox(height: 100),
          Expanded(
              flex: 4,
              child:Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(count.toString()+"/10",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),),
                        Text(timerText,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:Colors.white,),),
                      ],),
                    Text(category[idx].question+" ?",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),),
                    SizedBox(height: 10),
                    Row(children: [
                      RaisedButton(
                        child: Text("A"),
                        onPressed:() {
                          setState(() {
                            if(idx!=category.length-1) {
                              setState(() {
                                count=count+1;
                                idx = idx + 1;
                              });
                              answers.add("A");
                            }
                            else{
                              setState(() {
                                open=true;
                                if(answers.length==9) {
                                  answers.add( "A");
                                }
                              });
                            }
                          });
                        },
                        color: Colors.teal,
                      ),
                      SizedBox(width: 5,),
                      Text(category[idx].A,style: TextStyle(fontSize: 15, color: Colors.teal,fontWeight: FontWeight.bold),),
                    ],),
                    Row(children: [
                      RaisedButton(
                        child: Text("B"),
                        onPressed:() {
                          setState(() {
                            if(idx!=category.length-1) {
                              setState(() {
                                count=count+1;
                                idx = idx + 1;
                              });
                              answers.add("B");
                            }
                            else{
                              setState(() {
                                open=true;
                                if(answers.length==9) {
                                  answers.add( "B");
                                }
                              });
                            }
                          });
                        },
                        color: Colors.cyanAccent,
                      ),
                      SizedBox(width: 5,),
                      Text(category[idx].B,style: TextStyle(fontSize: 15,color: Colors.cyanAccent,fontWeight: FontWeight.bold),),
                    ],),
                    Row(children: [
                      RaisedButton(
                        child: Text("C"),
                        onPressed:() {
                          setState(() {
                            if(idx!=category.length-1) {
                              setState(() {
                                count=count+1;
                                idx = idx + 1;
                              });
                              answers.add("C");
                            }
                            else{
                              setState(() {
                                open=true;
                                if(answers.length==9) {
                                  answers.add( "C");
                                }
                              });
                            }
                          });
                        },
                        color: Colors.pink,
                      ),
                      SizedBox(width: 5,),
                      Text(category[idx].C,style: TextStyle(fontSize: 15,color: Colors.pink,fontWeight: FontWeight.bold),),
                    ],),
                    Row(children: [
                      RaisedButton(
                          child: Text("D"),
                          onPressed:() {
                            setState(() {
                              if(idx!=category.length-1) {
                                setState(() {
                                  count=count+1;
                                  idx = idx + 1;
                                });
                                answers.add("D");
                              }
                              else{
                                setState(() {
                                  open=true;
                                  if(answers.length==9) {
                                    answers.add( "D");
                                  }
                                });
                              }
                            });
                          },
                          color: Colors.brown
                      ),
                      SizedBox(width: 5,),
                      Text(category[idx].D,style: TextStyle(fontSize: 15,color: Colors.brown,fontWeight: FontWeight.bold),),
                    ],),
                    open==true ?
                    new RaisedButton(
                      child: Text("FINISH",style: TextStyle(color:Colors.white),),
                      onPressed:(){
                        setState(() {
                          calculate();
                          result_page=true;
                        });
                      },
                    ): new Container(),
                  ],),
              )
          )
        ]
    );
  }
  void calculate(){
    if(answers.length==10){
      setState(() {
        result="Thank you for playing";
      });
      for(int i=0; i<correct_answers.length;i++) {
        if (correct_answers[i].toString() == answers[i].toString()) {
          score=score+10;
        }
        else{
          continue;
        }
      }
    }
    else{
      setState(() {
        result="You did not complete game.";
      });
    }
  }
    Widget third(){
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
                child: Text(result,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ),
            Expanded(
              child: Center(
                  child: Column(children: [
                    Text(result=="Thank you for playing" ? "Your score: "+score.toString() +"%": "Sorry we can not calculate your score.",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    Text(result=="Thank you for playing" ? "If you win, we will announce to your email." : "Try again",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],)
              ),
            ),
            Expanded(
              child: Center(
                child:Container(
                  width: 100.0,
                  height: 100.0,
                  child:ClipOval(
                    child: RaisedButton(
                        child: Text('Exit'),
                        color: Colors.pink[200],
                        onPressed: () {
                          if(result=="Thank you for playing"){
                            DatabaseHelper.internal().save_result(user_email,score);
                          }
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ),
            ),
          ]
      );
    }
}