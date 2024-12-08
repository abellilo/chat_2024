import 'package:chat_2024/screens/login_page.dart';
import 'package:chat_2024/screens/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool page = true;

  void toggleButton(){
    setState(() {
      page = !page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(page){
      return LoginPage(onTap: toggleButton);
    }
    else{
      return RegisterPage(onTap: toggleButton);
    }

  }
}
