import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_03/firebase_options.dart';
import 'package:firebase_flutter_03/pages/auth_screen.dart';
import 'package:firebase_flutter_03/pages/profile.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebase Flutter 03 ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if ((userSnapshot.connectionState == ConnectionState.waiting)) {
              return const CircularProgressIndicator.adaptive();
            }
            if (userSnapshot.hasData) {
              return Profile();
            }
            return const AuthScreen();
          }),
    );
  }
}
