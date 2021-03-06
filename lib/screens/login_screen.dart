import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/padd.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class LoginScreen extends StatefulWidget {
  static const id='/loginscreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _auth=FirebaseAuth.instance;
String email,password;
bool showloading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall:showloading ,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:'image',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: boxed.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input
                  password=value;
                },
                decoration: boxed.copyWith(hintText: 'Enter your password(min 6 char.)'),
              ),
              SizedBox(
                height: 24.0,
              ),
              padd(onpressed: ()async {
                setState(() {
                  showloading=true;
                });
                try{
                  final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user!=null)
                    {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  setState(() {
                    showloading=false;
                  });
                }
                catch(e)
                {
                  Alert(
                    context: context,
                    title: 'Wrong password!',
                  ).show();
                  setState(() {
                    showloading=false;
                  });
                }

              },col:Colors.lightBlueAccent,text: 'Log In',),
            ],
          ),
        ),
      ),
    );
  }
}
