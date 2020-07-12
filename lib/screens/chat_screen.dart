import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedinuser;

class ChatScreen extends StatefulWidget {
  static const id = '/chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messagetextcontroller = TextEditingController();
  //getting current user from firebase,it's built in method in firebase currentUser()

  String messagetext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentuser();
  }

  void currentuser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  //it is able to show the whole document in the console only but we wanted to print it all on the screen so
  // we have to make changes . Streams dart search..
//  void getmessages()async
//  {
//    final msg= await _firestore.collection('messages').getDocuments();
//    for(var msgs in msg.documents)
//      {
//        print(msgs.data);
//      }
//  }
//  void messagestream() async {
//    await for (var snapshot in _firestore.collection('messages').snapshots()) {
//      for (var msgs in snapshot.documents) {
//        print(msgs.data);
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Messagestream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        //Do something with the user input.
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messagetextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedinuser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagestream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        final messagess = snapshot.data.documents.reversed;
        List<Messagestyle> msgbubble = [];
        for (var s in messagess) {
          final msgtext = s.data['text'];
          final msgdata = s.data['sender'];
          final curusert = loggedinuser.email;
          final msgwidge = Messagestyle(
              msgtext: msgtext, msgdata: msgdata, user: curusert == msgdata);
          msgbubble.add(msgwidge);
        }
        return Expanded(
          child: ListView(
            reverse:true,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: msgbubble,
          ),
        );
      },
    );
  }
}

class Messagestyle extends StatelessWidget {
  final String msgtext;
  final String msgdata;
  final bool user;
  Messagestyle({this.msgtext, this.msgdata, this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      // till now all the data is pushed in a single block now we have to provide padding to it so that it looks good
      //pADDING ^
      child: Column(
        crossAxisAlignment: (user==true)?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text('$msgdata',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12.0,
              )),
          SizedBox(
            width: 10.0,
          ),
          Material(
            borderRadius:(user==true)? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)):BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: (user==true)?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text('$msgtext ',
                  style: TextStyle(
                    color: (user==true)?Colors.white:Colors.black54,
                    fontSize: 15.0,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
