import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  //email and pw controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap
  });

  void register(BuildContext context) {
    final auth = AuthService();

    if(passwordController.text == confirmPasswordController.text){
      try{
        auth.signUpWithEmailPassword(
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
    else{
      showDialog(
          context:  context,
          builder: (context)=> AlertDialog(
            title: Text("Password do not match"),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimaryFixed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(height: 50),

            Text(
                "Let's Create an account for you",
                style: TextStyle(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
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

            const SizedBox(height: 10),

            MyTextField(
              hintText: "confirm password",
              obSecureText: true,
              controller: confirmPasswordController,
              focusNode: FocusNode(),
            ),

            const SizedBox(height: 25),

            MyButton(
              text: "Register",
              onTap: ()=>register(context),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Login Now",
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
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