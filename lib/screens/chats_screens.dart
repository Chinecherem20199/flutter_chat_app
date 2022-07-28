// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../constants.dart';
//
// class ChatScreen extends StatefulWidget {
//   static const String id = 'chats';
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Stream<QuerySnapshot> _usersStream =
//       FirebaseFirestore.instance.collection('messages').snapshots();
//   final _auth = FirebaseAuth.instance;
//   late User loggedInUser;
//   late String messageText;
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }
//
//   void getCurrentUser() async {
//     try {
//       final user = await _auth.currentUser;
//       if (user != null) {
//         loggedInUser = user;
//         print(loggedInUser);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 _auth.signOut();
//                 Navigator.pop(context);
//               }),
//         ],
//         title: Text('⚡️Chat'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             StreamBuilder<QuerySnapshot>(
//               stream: _usersStream,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Something went wrong');
//                 }
//
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Text("Loading");
//                 }
//
//                 return ListView(
//                   children:
//                       snapshot.data!.docs.map((DocumentSnapshot document) {
//                     Map<String, dynamic> data =
//                         document.data()! as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text(data['text']),
//                       subtitle: Text(data['sender']),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) {
//                         messageText = value;
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       //Implement send functionality.
//                       //messageText + loggedInUser.email
//                       _firestore.collection('messages').add({
//                         'text': messageText,
//                         'sender': loggedInUser.email,
//                       });
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
