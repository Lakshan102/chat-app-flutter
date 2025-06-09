import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //instant of auth
  final FirebaseAuth auth=FirebaseAuth.instance;
  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, String password) async{
    try{
      UserCredential userCredential= await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      //save user info if it doesn't already exist
      firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          "uid":userCredential.user!.uid,
          "email":email,

        },
      );
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email,password) async{
    try{
      //create user
      UserCredential userCredential=
          await auth.createUserWithEmailAndPassword(
              email: email,
              password: password
          );
      //save user info
      firestore.collection("users").doc(userCredential.user!.uid).set(
      {
        "uid":userCredential.user!.uid,
        "email":email,

      },
      );
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async{
    return await auth.signOut();
  }
  //error
}