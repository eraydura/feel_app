import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music/controller/Database.dart';
import 'package:music/ui/animation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Login.dart';

class ForgotDemo extends StatefulWidget {
  @override
  State createState() => ForgetState();
}


class ForgetState extends State<ForgotDemo> {
  bool val_email_2 = false;
  final _formKey_2 = GlobalKey<FormState>();
  final email_2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.pop(context);},
          child: Icon(Icons.close),
          backgroundColor: Color(0xff21254A),
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,),
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
                          children: <Widget>[
                            Form(
                              key: _formKey_2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  FadeAnimation(
                                      1,Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: val_email_2 ? Colors.red: Colors.grey[100]),
                                      borderRadius:  BorderRadius.circular(50),
                                    ),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                                      controller:email_2,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.email,color:val_email_2 ? Colors.red: Colors.grey[100]),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                          hintText:  "Email",
                                          hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  )
                                  )],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            FadeAnimation(
                              1,
                              Center(
                                child: RaisedButton(
                                  onPressed: () async {
                                    setState(() {
                                      email_2.text.isEmpty ? val_email_2 = true : val_email_2= false;
                                    });
                                    if (!email_2.text.isEmpty ) {
                                      bool user= await DatabaseHelper.internal().selectEmail(email_2.text);
                                      final Random _random = Random.secure();
                                      var values = List<int>.generate(10, (i) => _random.nextInt(256));
                                      String pass= base64Url.encode(values);

                                      if(user==true) {
                                        DatabaseHelper.internal().uptade_password(email_2.text,pass,true);
                                        Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: "Success",
                                          desc: "Your new password sent your email.",
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
                                      else{
                                        Alert(
                                          context: context,
                                          type: AlertType.info,
                                          title: "ALERT",
                                          desc: "There is no account registered with this email.",
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
                                    const Text('Send', style: TextStyle(fontSize: 15,color: Colors.white)),
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
                    ],
                  )),]));
  }
}