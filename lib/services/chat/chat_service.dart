import 'package:chat_flutter/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatService{
  //get instance of firebase & auth
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>>getUsersStream(){
    return firestore.collection("users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user=doc.data();
        return user;
      }).toList();
    });
  }
  //send message

Future<void>sendMessage(String receiverId,String message) async{
  //get current user info
  final String currentUserId=auth.currentUser!.uid;
  final String currentUserEmail=auth.currentUser!.email!;
  final Timestamp timestamp= Timestamp.now();

  //create new message
  Message newMessage=Message(
    senderId: currentUserId,
    senderEmail: currentUserEmail,
    receiverId: receiverId,
    message: message,
    timestamp: timestamp,
  );
  //construct chat room ID for the two users
  List<String>ids=[currentUserId,receiverId];
  ids.sort();
  String chatRoomId=ids.join('_');

  //add new message to database
  await firestore
      .collection("chat_Rooms")
      .doc(chatRoomId)
      .collection("messages")
      .add(newMessage.toMap());

}
  //get message
  Stream<QuerySnapshot> getMessages(String userId,String otherId){
    List<String> ids=[userId,otherId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firestore
        .collection("chat_Rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }

}