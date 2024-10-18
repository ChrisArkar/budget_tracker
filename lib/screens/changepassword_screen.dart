import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('We will send a password reset link to your registered email.'),
            ElevatedButton(
              onPressed: () {
                _sendPasswordResetEmail();
              },
              child: Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendPasswordResetEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _auth.sendPasswordResetEmail(email: user.email!);
      print('Password reset email sent!');
    }
  }
}
