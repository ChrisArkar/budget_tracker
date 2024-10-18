import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testbdgtt/screens/dashboard.dart';
import 'package:testbdgtt/services/db.dart';

class AuthService {
  var db = Db();

  Future<void> createUser(data, context) async {
    try {
      // Creating the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      print("User created successfully with UID: ${userCredential.user?.uid}");

      // Adding user data to the database
      await db.addUser(data, context);

      // Navigate to the Dashboard upon successful signup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      print("Error during sign-up: $e");

      // Show an alert dialog with the error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign Up Failed"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> login(data, context) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      print("Login successful with UID: ${userCredential.user?.uid}");

      // Navigate to the Dashboard upon successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      print("Error during login: $e");

      // Show an alert dialog with the error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }
}
