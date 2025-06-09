import 'package:chat_flutter/components/chat_bubble.dart';
import 'package:chat_flutter/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget{
  final String receiverEmail;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController messageController=TextEditingController();

  //chat & auth service
  final ChatService chatService=ChatService();
  final AuthService authService=AuthService();

  //for textFiled forces
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        Future.delayed(
          const Duration(milliseconds: 500),
          ()=>scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      ()=>scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  final ScrollController scrollController =ScrollController();

  void scrollDown(){
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMessage() async{
    // if there is something inside the text field
    if(messageController.text.isNotEmpty){
      //send the message
      await chatService.sendMessage(widget.receiverId, messageController.text);
      //clear the text field
      messageController.clear();
    }
  scrollDown();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        appBar: AppBar(
          title: Text(widget.receiverEmail),
          backgroundColor: Colors.transparent ,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
      body: Column(
        children: [
          //message list
          Expanded(
            child: buildMessageList(),

          ),
          //user input
          buildUserInout(),
        ]
      )
    );
  }

  Widget buildMessageList() {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
          //error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        //return list view
        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs.map((doc) =>buildMessageItems(doc)).toList(),
        );
      },
    );
  }

  // build message items
  Widget buildMessageItems(DocumentSnapshot doc){
    Map<String,dynamic>data=doc.data() as Map<String,dynamic>;

    bool isCurrentUser = data['senderId'] == authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser?CrossAxisAlignment.end: CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
            ),
          ],
        )
    );
  }

  Widget buildUserInout(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                controller: messageController,
                hintText: "type a message",
                obSecureText: false,
                focusNode: myFocusNode,
              ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon:const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                )
            ),
          )
        ],
      ),
    );
  }
}