import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/padd.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = '/welcomescreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationcontroller;
  Animation curveanimation;
  Animation coloranimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationcontroller = AnimationController(
      duration: Duration(seconds: 3),
      //vsync is required value but we can add many functionalities in it.
      // upperBound: 100.0,
      vsync: this,
    );

    animationcontroller.forward();
    coloranimation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(animationcontroller);
//    curveanimation =
//        CurvedAnimation(parent: animationcontroller, curve: Curves.bounceOut);

    //this property has many functions like reverse,loop
    //for ex:- animationcontroller.reverse(from:1.0);
    //it would make the  animation move from 1.0 to 0.0

    // it is added so that we can add loop to our animation i.e on completion of forward() fun reverse should work and vice versa
//    animationcontroller.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        animationcontroller.reverse(from: 1.0);
//      } else if (status == AnimationStatus.dismissed) {
//        animationcontroller.forward();
//      }
//    });

    animationcontroller.addListener(() {
      setState(() {});
      print(coloranimation.value);
    });
  }

  // this function is added because the animation would keep on consuming resouces even if the current screen is not welcome screen
  @override
  void dispose() {
    super.dispose();
    animationcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //opacity is used to change color contrast and we have used animationcontroller.value as it's value is  btw 0.0 to 1.0
      //which is required in withOpacity function so that it looks animated
      backgroundColor: coloranimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'image',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      //when the animation has to be done on the logo
                      //height: curveanimation.value * 100,
                      //else
                      height: 60.0,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  onTap: () {
                    print("Tap Event");
                  },
                  text: [
                    'Flash Chat'
                  ],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                    textAlign: TextAlign.start,
                    alignment: AlignmentDirectional.topStart
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            padd(
                onpressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                col: Colors.lightBlueAccent,
                text: 'Log in'),
            padd(
                onpressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                col: Colors.lightBlueAccent,
                text: 'Register'),
          ],
        ),
      ),
    );
  }
}
