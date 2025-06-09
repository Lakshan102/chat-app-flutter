import 'package:chat_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../pages/register_page.dart';


class LoginOrRegister extends StatefulWidget{
  const LoginOrRegister ({super.key});

  @override
  State<LoginOrRegister> createState()=> LoginOrRegisterState();

}

class LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
        onTap: togglePage,
      );
    }else{
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}