import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'message_stream.dart';

final _firestore = FirebaseFirestore.instance;
// late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Text editing controller for reset text after send
  //initializing the TextEditingController
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Group Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      //assign in the controller
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // clear the text after send
                      messageTextController.clear();
                      //messageText + loggedInUser.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: const Text(
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

// class MessageBubble extends StatelessWidget {
//   final String text;
//   final String sender;
//   final bool isMe;
//
//   MessageBubble({
//     required this.text,
//     required this.sender,
//     required this.isMe,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: const TextStyle(
//               fontSize: 12.0,
//               color: Colors.black54,
//             ),
//           ),
//           Material(
//             elevation: 5.0,
//             borderRadius: isMe
//                 ? const BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0),
//                   )
//                 : const BorderRadius.only(
//                     topRight: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0),
//                   ),
//             color: isMe ? Colors.lightBlueAccent : Colors.white,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 text,
//                 style: isMe
//                     ? const TextStyle(fontSize: 15.0, color: Colors.white)
//                     : const TextStyle(fontSize: 15.0, color: Colors.black54),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: _firestore.collection('messages').snapshots(),
//         builder: (context, snapshot) {
//           final messages = snapshot.data?.docs.reversed;
//           List<MessageBubble> messageBubbles = [];
//           for (var message in messages!) {
//             final String messageText = message.data()['text'];
//             final String messageSender = message.data()['sender'];
//             final currentUser = loggedInUser.email;
//             final messageBubble = MessageBubble(
//               text: messageText,
//               sender: messageSender,
//               isMe: currentUser == messageSender,
//             );
//             messageBubbles.add(messageBubble);
//           }
//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding:
//                   const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
//               children: messageBubbles,
//             ),
//           );
//         });
//   }
// }
