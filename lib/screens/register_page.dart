import 'package:chat_2024/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:chat_2024/components/my_button.dart';
import 'package:chat_2024/components/my_textfield.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    final authService = Provider.of<AuthServices>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text.trim(), passwordController.text.trim());
    }
    catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    //logo
                    Icon(
                      Icons.message,
                      size: 80,
                      color: Colors.grey[800],
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    //welcome back message
                    Text(
                      "Let's create an account for you!",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    //email textfield
                    MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obsureText: false),

                    const SizedBox(
                      height: 10,
                    ),

                    //password textfield
                    MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obsureText: true),

                    const SizedBox(
                      height: 10,
                    ),

                    //confirm password textfield
                    MyTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        obsureText: true),

                    const SizedBox(
                      height: 25,
                    ),

                    //sign in button
                    MyButton(text: "Sign Up", onTap: signUp),

                    const SizedBox(
                      height: 50,
                    ),

                    //not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already a member?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text("Login now.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
