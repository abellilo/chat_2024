import 'package:chat_2024/model/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  //send message
  Future sendMessage(String receiverId, String message) async {
    //get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a message
    Message newMessage = Message(
        senderEmail: currentUserEmail,
        senderId: currentUserId,
        message: message,
        receiverid: receiverId,
        timeStamp: timestamp);

    //create chat room id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // this give the chat room id to the same users chatting in respectively of if its sender or receiver
    String chatRoomId = ids.join("_");

    //add the message
    await _firebaseFirestore
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    //lets get that chatroom id
    List<String> ids = [userId, otherUserId];
    ids.sort(); // this give the chat room id to the same users chatting in respectively of if its sender or receiver
    String chatRoomId = ids.join("_");

    return _firebaseFirestore.collection("chatroom").doc(chatRoomId)
        .collection("messages").orderBy("timestamp", descending: false)
        .snapshots();
  }
}
