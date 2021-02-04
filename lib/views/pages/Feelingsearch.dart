import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music/controller/control_json.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String lastWords='';

class Feeling_Search extends StatefulWidget {

  @override
  Search_Page createState() => Search_Page();
}

class Search_Page extends State<Feeling_Search> {
  bool _hasSpeech = false;
  String usernameController='Energetic';
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  String p='';
  String a='';


  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: Column(children: [
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                  Positioned.fill(
                  top: height/3,
                  child: Align(
                  alignment: Alignment.topRight,
                  child:Container(
                      child:Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children:<Widget> [
                            InkWell(child:
                            Text(
                              "I feel like   ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            ),
                            InkWell(child:
                            lastWords.split(' ').length==1 ?
                            Text(
                                  lastWords,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,color: Colors.red,decoration: TextDecoration.underline,
                                  )):
                            Text(
                                  lastWords.split(' ')[0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,color: Colors.red,decoration: TextDecoration.underline,
                                )),

                              onTap: () {
                                var s=lastWords;
                                BuildContext dialogContext;
                                if(lastWords=="Happy"||lastWords=="Good"){
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      dialogContext = context;
                                      return Dialog(
                                        child: Artist("energetic"),
                                      );
                                    },
                                  );
                                }
                                else if(lastWords=="Tired"||lastWords=="Bad"){
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      dialogContext = context;
                                      return Dialog(
                                        child: Artist("calm"),
                                      );
                                    },
                                  );
                                }
                                else if(s=="Sad"){
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      dialogContext = context;
                                      return Dialog(
                                        child: Artist("dreamy"),
                                      );
                                    },
                                  );
                                }
                                else if(s=="Energetic"||s=="Dreamy"||s=="Calm"||s=="Joyful") {
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      dialogContext = context;
                                      return Dialog(
                                        child: Artist(s.toLowerCase()),
                                      );
                                    },
                                  );
                                }
                                else{
                                  _onAlertButtonPressed(context);
                                }
                              },
                            ),
                          ],),
                      ),)),
                    Positioned.fill(
                      bottom: 20,
                      left: 10,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(icon: Icon(Icons.adjust),onPressed: _hasSpeech ? null : initSpeechState,iconSize: 50,color: Colors.red,),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 20,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(icon: Icon(Icons.mic),onPressed: !_hasSpeech || speech.isListening
                              ? null
                              : startListening,iconSize: 50,),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 20,
                      right: 10,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(icon: Icon(Icons.cancel),onPressed: speech.isListening ? stopListening : null,iconSize: 50,color: Colors.red,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          bottom: 60,
            child: Align(
                alignment: Alignment.bottomRight,
                child:Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: speech.isListening
                        ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    )
                        : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                )
            )
        ),
      ]),
    );
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
      onResult: resultListener,
      localeId: _currentLocaleId,
      cancelOnError: true,
      partialResults: true,
    );
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "ALLOWED WORDS",
      desc: """
Happy
Sad
Energetic
Dreamy
Calm
Tired
Joyful
Good/Bad
      """,
      buttons: [
        DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
