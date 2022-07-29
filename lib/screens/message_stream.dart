import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          final messages = snapshot.data?.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages!) {
            final String messageText = message.data()['text'];
            final String messageSender = message.data()['sender'];
            final currentUser = loggedInUser.email;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              children: messageBubbles,
            ),
          );
        });
  }
}
