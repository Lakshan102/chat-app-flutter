import 'package:chat_flutter/components/my_drawer.dart';
import 'package:chat_flutter/services/auth/auth_service.dart';
import 'package:chat_flutter/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget{
  HomePage ({super.key});

  //chat & auth services
  final ChatService chatService=ChatService();
  final AuthService authService=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      appBar: AppBar(
        title: const Text("home"),
        backgroundColor: Colors.transparent ,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer:const  MyDrawer(),
      body: buildUserList(),
    );
  }

  //build list of users expect for the current logged in user
  Widget buildUserList(){
    return StreamBuilder(
        stream: chatService.getUsersStream(),
        builder: (context,snapshot){
          //error
          if(snapshot.hasError){
            return const Text("Error");
          }
          //loading
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text("Loading.....");
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData)=>buildUserListItem(userData,context))
                .toList(),
          );
        },
    );
  }
  //build individual list tile for user
  Widget buildUserListItem(
      Map<String,dynamic> userData,BuildContext context){
    //display all users except current user
    if(userData["email"] != authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(
            builder: (context) =>
                ChatPage(
                  receiverEmail: userData["email"],
                  receiverId: userData["uid"],
                ),
          ),
          );
        },
      );
    }else{
      return Container();
    }
  }
}