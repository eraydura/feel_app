import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:music/controller/Database.dart';
import 'package:music/ui/animation.dart';
import 'package:music/views/authentification/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile_Change extends StatefulWidget {
  @override
  Change_Form createState() => Change_Form();
}

class Change_Form extends State<Profile_Change> {

  final password = TextEditingController();
  final password_2 = TextEditingController();
  final name = TextEditingController();
  final picture = TextEditingController();
  final o_password = TextEditingController();
  final email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String body;
  bool val_password_2 = false;
  bool val_email = false;
  bool val_name = false;
  bool val_password = false;
  bool val_picture = false;
  bool val_o_password = false;

  @override
  void dispose() {
    super.dispose();
  }

  Widget change_password(){
   return  Center(child:Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
                1,Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: val_o_password ? Colors.red: Colors.grey[100]),
                borderRadius:  BorderRadius.circular(50),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller:o_password,
                obscureText: true,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.vpn_key,color:val_o_password ? Colors.red: Colors.grey[100]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText:  "Old Password",
                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            )
            ),
            SizedBox(height: 20,),
            FadeAnimation(
                1,Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: val_password ? Colors.red: Colors.grey[100]),
                borderRadius:  BorderRadius.circular(50),
              ),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.vpn_key,color:val_password ? Colors.red: Colors.grey[100]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText:  "New Password",
                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            )
            ),
            SizedBox(height: 20,),
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
                      password.text.isEmpty ? val_password = true : val_password= false;
                      o_password.text.isEmpty ? val_o_password = true : val_o_password= false;

                      if( password_2.text.isEmpty || password_2.text != password.text){
                        val_password_2 = true;
                      }
                      else{
                        val_password_2= false;
                      }
                    });

                    if ( !password_2.text.isEmpty && !password.text.isEmpty && !o_password.text.isEmpty && password_2.text == password.text ) {
                      if(encrypted(o_password.text)==user_password && o_password!=password.text) {
                        DatabaseHelper.internal().uptade_password(user_email, encrypted(password.text), false);
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Success",
                          desc: "You changed information. You have to login.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "COOL",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => SignInDemo("close")),
                                        (Route<dynamic> route) => false);
                              },
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
                          title: "WRONG",
                          desc: "You entered wrong password or same password",
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
                    const Text('Done', style: TextStyle(fontSize: 15,color: Colors.white)),
                  ),
                  color: Color(0xff21254A).withOpacity(1),
                ),
              ),
            ),],
        ),
      ));
  }
  Widget change_picture(){
    return Center(child:Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
              1,Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: val_picture ? Colors.red: Colors.grey[100] ),
              borderRadius:  BorderRadius.circular(50),
            ),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              controller:picture,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.image,color:val_picture ? Colors.red: Colors.grey[100]),
                  errorStyle: TextStyle(
                      fontSize: 16.0,color: Colors.white
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Picture URL",
                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          )),
          SizedBox(height: 20,),
          SizedBox(
            height: 20.0,
          ),
          FadeAnimation(
            1,
            Center(
              child: RaisedButton(
                onPressed: () async {
                  picture.text.isEmpty ? val_picture = true : val_picture= false;
                  bool check_picture = RegExp(r"^(http(s?):/)(/[^/]+)+" + "\.(?:jpg|gif|png)").hasMatch(picture.text);
                  if ( picture.text.isNotEmpty  && check_picture) {
                    DatabaseHelper.internal().uptade_picture(picture.text, user_email);
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Success",
                      desc: "You changed information. You have to login.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => SignInDemo("close")),
                                    (Route<dynamic> route) => false);
                          },
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
                  const Text('Done', style: TextStyle(fontSize: 15,color: Colors.white)),
                ),
                color: Color(0xff21254A).withOpacity(1),
              ),
            ),
          ),],
      ),
    ));
  }
  Widget username(){
    return Center(child:Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
              1,Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: val_name ? Colors.red: Colors.grey[100] ),
              borderRadius:  BorderRadius.circular(50),
            ),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              controller:name,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.account_circle,color:val_name ? Colors.red: Colors.grey[100]),
                  errorStyle: TextStyle(
                      fontSize: 16.0,color: Colors.white
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          )),
          SizedBox(height: 20,),
          FadeAnimation(
            1,
            Center(
              child: RaisedButton(
                onPressed: () async {
                  name.text.isEmpty ? val_name = true : val_name= false;
                  if ( name.text.isNotEmpty   ) {
                    DatabaseHelper.internal().uptade_name(name.text,user_email);
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Success",
                      desc: "You changed information. You have to login.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => SignInDemo("close")),
                                    (Route<dynamic> route) => false);
                          },
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
                  const Text('Done', style: TextStyle(fontSize: 15,color: Colors.white)),
                ),
                color: Color(0xff21254A).withOpacity(1),
              ),
            ),
          ),],
      ),
    ));
  }

  Widget edit_page(){

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
              1,Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                  NetworkImage(user_image),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 10,),
                Text("Name: "+user_name,style:TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10,),
                Text("Email: "+user_email,style:TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10,),
                Text("Entry Date: " +entry_date,style:TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold) ,),
              ],
            )
          ),
          SizedBox(height: 20,),
          FadeAnimation(
            1,
            Center(
              child: RaisedButton(
                onPressed: () async {
                    DatabaseHelper.internal().deleteUser(user_email);
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Success",
                      desc: "You deleted your account.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInDemo("close")),
                            );
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                          radius: BorderRadius.circular(0.0),
                        ),
                      ],
                    ).show();

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
                  const Text('Delete User', style: TextStyle(fontSize: 15,color: Colors.white)),
                ),
                color: Color(0xff21254A).withOpacity(1),
              ),
            ),
          ),],
      ),
    );
  }

  Widget change_email(){
    return Center(child:Form(
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
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                controller:email,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email,color:val_email ? Colors.red: Colors.grey[100]),
                    errorStyle: TextStyle(
                        fontSize: 16.0,color: Colors.white
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText: " Change Email",
                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            )),
            SizedBox(height: 20,),
            SizedBox(
              height: 20.0,
            ),
            FadeAnimation(
              1,
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    email.text.isEmpty ? val_email = true : val_email= false;
                    bool email_check = await DatabaseHelper.internal().selectEmail(email.text);
                    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);
                    if ( email.text.isNotEmpty && !email_check && emailValid ) {
                      DatabaseHelper.internal().updateEmail(email.text,user_email);
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Success",
                        desc: "You changed information. You have to login.",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "COOL",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => SignInDemo("close")),
                                      (Route<dynamic> route) => false);
                            },
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
                    const Text('Change Email', style: TextStyle(fontSize: 15,color: Colors.white)),
                  ),
                  color: Color(0xff21254A).withOpacity(1),
                ),
              ),
            ),],
        ),
      ));
  }
  @override
  Widget build(BuildContext context) {
    SpeedDial buildSpeedDial() {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 35),
        backgroundColor: Color(0xFF801E48),
        foregroundColor: Colors.white,
        overlayColor: Colors.black26,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.supervised_user_circle),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                setState(() {
                  body="name";
                });
                return Profile_Change();
              },
              label: 'Change Name',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),
          SpeedDialChild(
              child: Icon(Icons.email),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                setState(() {
                  body="email";
                });
                return Profile_Change();
              },
              label: 'Change Email',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),

          SpeedDialChild(
              child: Icon(Icons.image),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                setState(() {
                  body="image";
                });
                return Profile_Change();
              },
              label: 'Change Picture',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),
          SpeedDialChild(
              child: Icon(Icons.account_circle),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                setState(() {
                  body="info";
                });
                return Profile_Change();
              },
              label: 'Show information',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),
          user_password!=null? SpeedDialChild(
            child: Icon(Icons.vpn_key),
            backgroundColor: Color(0xFF801E48),
            onTap: () {
              setState(() {
                body="password";
              });
              return Profile_Change();
            },
            label: 'Change Password',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xFF801E48)): new SpeedDialChild(backgroundColor: Colors.transparent,),

        ],
      );

    }
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: ((){
       if(body=="name"){
        return username();
      }
      else if(body=="password"){
          return change_password();
      }
      else if(body=="email"){
         return change_email();
       }
       else if(body=="image"){
         return change_picture();
       }
      else if( body=="info"){
        return edit_page();
       }
      else{
         return edit_page();
       };
      }()),
      floatingActionButton: buildSpeedDial(),
    );
  }
}