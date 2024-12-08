import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderEmail;
  final String senderId;
  final String message;
  final String receiverid;
  final Timestamp timeStamp;

  Message(
      {required this.senderEmail,
      required this.senderId,
      required this.message,
      required this.receiverid,
      required this.timeStamp});

  Map<String, dynamic> toMap(){
    return {
      'senderId' : senderId,
      'senderEmail': senderEmail,
      'receiverId' : receiverid,
      'message' : message,
      'timestamp' :timeStamp
    };
  }
}
