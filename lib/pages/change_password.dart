import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_03/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../constants/snackbar.dart';
import 'auth_screen.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  User? user = FirebaseAuth.instance.currentUser;
  final _passwordValidator = ValidationBuilder().minLength(6).build();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  changePassword(
    String password,
  ) async {
    if (_formKey.currentState!.validate()) {
      try {
        await user!.updatePassword(password);
        setState(() {
        
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(kSnackBar('Success',
              'Password Changed', ContentType.success));
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(kSnackBar('Ops', e.code, ContentType.failure));
      }
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _passwordController,
                  style: kFieldTxtStyle,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD'.toUpperCase(),
                    hintText: '..........',
                    enabledBorder: kFieldBorderColor,
                    hintStyle: kFieldTxtStyle,
                    labelStyle: kFieldTxtStyle,
                    errorStyle: kFieldTxtStyle,
                  ),
                  obscureText: true,
                  validator: _passwordValidator),
              MaterialButton(
                height: 57,
                color: kBtnBgColor,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    'Send Email',
                    style: kBtnTxtStyle,
                  ),
                ),
                onPressed: () {
                  changePassword(_passwordController.text.trim());
                },
              ),
            ],
          )),
    );
  }
}
