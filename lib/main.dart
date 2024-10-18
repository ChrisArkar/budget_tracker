import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testbdgtt/firebase_options.dart';
import 'package:testbdgtt/screens/changepassword_screen.dart';
import 'package:testbdgtt/screens/changeusername_screen.dart';
import 'package:testbdgtt/widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker Demo',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), 
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        '/changeUsername': (context) => ChangeUsernameScreen(),  // Route for changing username
        '/changePassword': (context) => ChangePasswordScreen(), 
      },
    );
  }
}
