import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_03/constants/snackbar.dart';
import 'package:firebase_flutter_03/pages/auth_screen.dart';
import 'package:firebase_flutter_03/pages/change_password.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(kSnackBar(
          'Success!',
          'A Verification Link has been Sent to \n $email',
          ContentType.success));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'User ID: $uid',
            style: const TextStyle(fontSize: 18.0),
          ),
          Row(
            children: [
              Text(
                'Email: $email',
                style: const TextStyle(fontSize: 18.0),
              ),
              user!.emailVerified
                  ? const Text(
                      'verified',
                      style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: const Text('Verify Email'))
            ],
          ),
          TextButton(
            child: const Text(
              'Logout',
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              });
            },
          ),
          TextButton(
            child: const Text(
              'Change Password',
            ),
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              });
            },
          ),
        ]),
      )),
    );
  }
}
