import 'package:chat_2024/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    final authServices = Provider.of<AuthServices>(context, listen: false);

    try {
      await authServices.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME PAGE"),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: SafeArea(
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return ListView(
              children: snapshots.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            );
          } else if (snapshots.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          } else if (snapshots.hasError) {
            return const Text("Error..");
          } else {
            return const Text("Request Timed out");
          }
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if(firebaseAuth.currentUser!.email != data["email"]){
      return ListTile(
        title: Text(data["email"]),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ChatPage(
              receiverEmail: data["email"],
              receiverId: data["uid"],
            );
          }));
        },
      );
    }
    else{
      return Container();
    }
  }
}
