import 'package:chat_flutter/components/my_button.dart';
import 'package:chat_flutter/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget{
  //email and pw controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap
  });

  //login method
  void login(BuildContext context) async{
    final authService = AuthService();

    try{
      await authService.signInWithEmailPassword(
          emailController.text,
          passwordController.text
      );
    }catch(e){
      showDialog(
          context:  context,
          builder: (context)=> AlertDialog(
            title: Text(e.toString()),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            
            const SizedBox(height: 50),
            
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              )
            ),

            const SizedBox(height: 25),

            MyTextField(
              hintText: "Email",
              obSecureText: false,
              controller: emailController,
              focusNode: FocusNode(),
            ),

            const SizedBox(height: 10),

            MyTextField(
              hintText: "password",
              obSecureText: true,
              controller: passwordController,
              focusNode: FocusNode(),
            ),

            const SizedBox(height: 25),
            
            MyButton(
                text: "Login",
                onTap: ()=>login(context),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Register Now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}