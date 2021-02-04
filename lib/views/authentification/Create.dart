import 'package:flutter/material.dart';
import 'package:music/ui/animation.dart';
import 'package:music/views/authentification/survey.dart';
import 'Login.dart';
import 'package:music/controller/Database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Create extends StatefulWidget {
  @override
  State createState() => CreateState();
}

class CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final password_2 = TextEditingController();
  final picture= TextEditingController();
  bool val_username = false;
  bool val_email = false;
  bool val_password = false;
  bool val_password_2 = false;
  bool val_picture = false;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      SizedBox(height: 20),

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
                                  SizedBox(height: 10,),
                                  FadeAnimation(
                                      1,Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: val_username ? Colors.red: Colors.grey[100]),
                                      borderRadius:  BorderRadius.circular(50),
                                    ),
                                    child: TextFormField(
                                      controller: username,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.assignment_ind,color:val_username ? Colors.red: Colors.grey[100]),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                          hintText:  "Username",
                                          hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  )
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                      1,Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: val_email ? Colors.red: Colors.grey[100]),
                                      borderRadius:  BorderRadius.circular(50),
                                    ),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                      controller:email,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.email,color:val_email ? Colors.red: Colors.grey[100]),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                          hintText:  "Email",
                                          hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  )
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                      1,Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: val_password ? Colors.red: Colors.grey[100]),
                                      borderRadius:  BorderRadius.circular(50),
                                    ),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                      1,Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: val_password_2 ? Colors.red: Colors.grey[100]),
                                      borderRadius:  BorderRadius.circular(50),
                                    ),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                                      controller:password_2,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.vpn_key,color:val_password_2 ? Colors.red: Colors.grey[100]),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                          hintText:  "Confirm Password",
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
                                      username.text.isEmpty ? val_username = true : val_username= false;
                                      email.text.isEmpty ? val_email = true : val_email= false;
                                      password.text.isEmpty ? val_password = true : val_password= false;
                                      if( password_2.text.isEmpty || password_2.text != password.text){
                                        val_password_2 = true;
                                      }
                                      else{
                                        val_password_2= false;
                                      }
                                    });
                                    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);

                                    if (!username.text.isEmpty && !email.text.isEmpty && !password.text.isEmpty && password_2.text==password.text && emailValid && password.text.length >= 8 ) {
                                      bool user= await DatabaseHelper.internal().selectEmail(email.text);
                                      if(user==false) {

                                        setState(() {
                                          user_email= email.text;
                                          user_name= username.text.toUpperCase();
                                          user_password=encrypted(password.text);
                                          user_image="https://groovesharks.org/assets/images/default_avatar.jpg";
                                        });
                                        Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: "Success",
                                          desc: "You created an account",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "COOL",
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: () =>  Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Artist_Json()),
                                              ),
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
                                          desc: "You have already an account."
                                                "Did you forgot your password?",
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
                                    else{
                                      Alert(
                                        context: context,
                                        type: AlertType.info,
                                        title: "WRONG",
                                        desc: "You should check your data you entered.",
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
                                    const Text('Register', style: TextStyle(fontSize: 15,color: Colors.white)),
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
