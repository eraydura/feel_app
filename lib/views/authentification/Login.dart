import 'dart:async';
import 'dart:convert' show JsonEncoder, json;
import 'dart:io';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:music/ui/animation.dart';
import 'package:music/views/pages/navigator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Forgot.dart';
import 'Create.dart';
import 'package:music/controller/Database.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
    home: new Splash_Screen(),
  ));
}

class Splash_Screen extends StatefulWidget {
  @override
  Splash createState() => new Splash();
}

class Splash extends State<Splash_Screen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new SignInDemo(" "),
      title: new Text(
        'FeelApp',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: Colors.red),
      ),
      image: Image.asset(
          "images/feelapp2.png"),
      backgroundColor: Color(0xff21254A),
      loaderColor: Colors.red,
    );
  }
}


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

String user_email;
String user_name;
String user_password;
String user_image;
String entry_date;

class SignInDemo extends StatefulWidget {
  String s;
  SignInDemo(this.s);

  @override
  State createState() => SignInDemoState(this.s);
}

class SignInDemoState extends State<SignInDemo> {
  static GoogleSignInAccount _currentUser;
  Map map = {1: false};
  String _contactText;
  Map<String, dynamic> _userData;
  AccessToken _accessToken;

  String login;
  bool _checking = true;
  bool val_email = false;
  bool val_password = false;

  var email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String loginout;
  SignInDemoState(this.loginout);


  @override
  void initState() {
    super.initState();

    _loadlogin();

    if(loginout=="close"){
      _logOut();
      _handleSignOut();
      _setlogin("false",null,null,null,null,null);
    }

    _checkIfIsLogged();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });

    _googleSignIn.signInSilently();
  }

  Widget _buildBody() {

    if (_currentUser != null) {
      setState(() {
        user_name=_currentUser.displayName;
        user_email=_currentUser.email;
        user_image=_currentUser.photoUrl;
        user_password=null;
      });
      return Navigate();
    }

    else if(login=="true"){
      return Navigate();
    }

    else if (_userData!=null){
      setState(() {
        if(Platform.isAndroid) {
          user_email = _userData.values.elementAt(1);
          user_name = _userData.values.elementAt(0);
          user_image = _userData.values.elementAt(2)['data']['url'];
          user_password = null;
        }
        if(Platform.isIOS) {
          user_name = _userData.values.elementAt(3);
          user_email = _userData.values.elementAt(0);
          user_image = _userData.values.elementAt(2)['data']['url'];
          user_password = null;
        }
      });
      return Navigate();
     }

    else{
      return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[

    SizedBox(
    height: 100,
    ),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
        children: <Widget>[
          FadeAnimation(
            1,
            Text(
              "Hello there, \nwelcome back",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),

            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      FadeAnimation(
                      1,Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: val_email ? Colors.red: Colors.grey[100] ),
                            borderRadius:  BorderRadius.circular(50),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                            controller:email,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.email,color:val_email ? Colors.red: Colors.grey[100]),
                                errorStyle: TextStyle(
                                    fontSize: 16.0,color: Colors.white
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                                hintText: "E-mail",
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                        )),
                      SizedBox(height: 20,),

              FadeAnimation(
                1,Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: val_password ? Colors.red: Colors.grey[100]),
                            borderRadius:  BorderRadius.circular(50),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                            controller:password,
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.vpn_key,color:val_password ? Colors.red: Colors.grey[100]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                                hintText:  "Password",
                                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        )
              )],
                    ),
                  ),
                        SizedBox(
                        height: 10.0,
                       ),

                  FadeAnimation(
                      1,Center(
                        child: InkWell(
                        onTap: () { Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotDemo()),
                        );},
                          child:Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                  ))),
                  SizedBox(
                    height: 10.0,
                  ),
                  FadeAnimation(
                    1,
                    Center(
                      child: InkWell(
                         onTap: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => Create()),
                           );},
                         child:  Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.pink[200],
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 10.0,
                  ),
                  FadeAnimation(
                    1,
                    Center(
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            email.text.isEmpty ? val_email = true : val_email= false;
                            password.text.isEmpty ? val_password = true : val_password = false;
                          });

                            if (!email.text.isEmpty && !password.text.isEmpty ) {
                              bool user= await DatabaseHelper.internal().selectUser(email.text,encrypted(password.text));
                              if(user==true) {
                                var a= await DatabaseHelper.internal().selectName(email.text);
                                var image=await DatabaseHelper.internal().select_Image(email.text);
                                var date=await DatabaseHelper.internal().select_Date(email.text);
                                setState(() {
                                  user_password=encrypted(password.text);
                                  user_email=email.text;
                                  user_image=image;
                                  entry_date=date;
                                  a= a.split(": ").last;
                                  user_name=a.substring(0, a.length - 1).toUpperCase();
                                  _setlogin("true",user_image,email.text,user_name,encrypted(password.text),date);
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Navigate()),
                                );
                              }
                              else{
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  title: "ALERT",
                                  desc: "There is a error when you login. TRY AGAIN",
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
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 90.0,right: 90.0,top:10.0,bottom: 10.0),
                          child:
                          const Text('Login', style: TextStyle(fontSize: 15,color: Colors.white)),
                        ),
                        color: Color(0xff21254A).withOpacity(1),
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                      ],
                    ),
                  ),
            FadeAnimation(
            1,
            Center(
            child:SignInButton(
            Buttons.Google,
            onPressed: _handleSignIn,
          ))),
          SizedBox(height: 10,),
        FadeAnimation(
         1,
        Center(
          child:
          SignInButton(
            Buttons.FacebookNew,
            onPressed: _login,
          ))),
        ],
      )),]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }

  _setlogin(logged,image,email,name,password,date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("login", logged);
      prefs.setString("name", name);
      prefs.setString("image", image);
      prefs.setString("email", email);
      prefs.setString("password",password);
      prefs.setString("date",date);
    });
  }

  _loadlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getString('login');
      user_image=prefs.getString('image');
      user_name=prefs.getString('name');
      user_email=prefs.getString('email');
      user_password=prefs.getString('password');
      entry_date=prefs.getString('date');
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  Future<void>  _login() async {
    try {
      setState(() {
        _checking = true;
      });
      _accessToken = await FacebookAuth.instance.login(); // by the fault we request the email and the public profile
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } on FacebookAuthException catch (e) {
      print(e.message); // print the error message in console
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    } catch (e, s) {
      // print in the logs the unknown errors
      print(e);
      print(s);
    } finally {
      // update the view
      setState(() {
        _checking = false;
      });
    }
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {

    });
  }

  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      // if the user is logged
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    super.dispose();
  }
}

