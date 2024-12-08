import 'package:chat_2024/components/chat_bubble.dart';
import 'package:chat_2024/components/my_textfield.dart';
import 'package:chat_2024/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  final firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(widget.receiverId, messageController.text);
      //clear controller after sending messgage
      setState(() {
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(child: _buildMessageList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(stream: chatServices.getMessages(
        widget.receiverId, firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("Error ${snapshot.error}");
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading");
          }

          if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
            );
          }
          else{
            return Container();
          }
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == firebaseAuth.currentUser!.uid) ?
    Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == firebaseAuth.currentUser!.uid)?
        CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(data["senderEmail"]),
          const SizedBox(height: 5,),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(child: MyTextField(controller: messageController,
            hintText: "Enter Message",
            obsureText: false)),
        IconButton(
            onPressed: sendMessage, icon: const Icon(Icons.send, size: 40,))
      ],
    );
  }
}
