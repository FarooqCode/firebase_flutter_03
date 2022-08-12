import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_03/constants/snackbar.dart';
import 'package:firebase_flutter_03/pages/profile.dart';
import 'package:firebase_flutter_03/theme/day_night_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_validator/form_validator.dart';
import '../constants/constants.dart';

/*

 ------------------Auth Screen----------------

*/

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  // Email Controller

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form Validator

  final _emailValidator = ValidationBuilder().email().build();
  final _passwordValidator = ValidationBuilder().minLength(6).build();

  bool _isLogin = true;
  bool _isForget = false;
  bool isLoading = false;

  loginForm(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              kSnackBar('Success', 'You Are Login', ContentType.success));
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(kSnackBar('Ops', e.code, ContentType.failure));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  signUpForm(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        setState(() {
          _isLogin = !_isLogin;
          isLoading =false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              kSnackBar('Success', 'Now You Login', ContentType.success));
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(kSnackBar('Ops', e.code, ContentType.failure));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  forget(
    String email,
  ) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        setState(() {
          _isLogin = !_isLogin;
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              kSnackBar('Success', 'Email Has Been Sent To you Email ID', ContentType.success));
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(kSnackBar('Ops', e.code, ContentType.failure));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const DayNightTheme(),
          Positioned(
            top: 50,
            child: Row(
              children: [
                const Text('Hi!', style: kHeadBottomTxtStyle),
                SvgPicture.asset(
                  'assets/profile.svg',
                  width: 175,
                  height: 150,
                ),
              ],
            ),
          ),
          Positioned(
            width: 300,
            top: 220,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: _emailController,
                      style: kFieldTxtStyle,
                      decoration: InputDecoration(
                        enabledBorder: kFieldBorderColor,
                        labelText: 'email'.toUpperCase(),
                        hintText: 'abc@gmail.com',
                        hintStyle: kFieldTxtStyle,
                        labelStyle: kFieldTxtStyle,
                        errorStyle: kFieldTxtStyle,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator),
                  if (!_isLogin)
                    const SizedBox(
                      height: 20.0,
                    ),
                  if (!_isLogin && !_isForget)
                    TextFormField(
                      style: kFieldTxtStyle,
                      decoration: InputDecoration(
                          labelText: 'username'.toUpperCase(),
                          enabledBorder: kFieldBorderColor,
                          labelStyle: kFieldTxtStyle,
                          hintText: 'Ali',
                          hintStyle: kFieldTxtStyle,
                          errorStyle: kFieldTxtStyle,
                          focusedBorder: kFieldBorderColor),
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (!_isForget)
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
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _isForget = !_isForget;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (_isLogin)
                                    const Text(
                                      'Forget?',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                ],
                              )),
                        ),
                        obscureText: true,
                        validator: _passwordValidator),
                  const SizedBox(
                    height: 35,
                  ),
                  if(isLoading) CircularProgressIndicator(),
                  if (!_isForget)
                    MaterialButton(
                      height: 57,
                      color: kBtnBgColor,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          _isLogin ? "Login" : "Sign up",
                          style: kBtnTxtStyle,
                        ),
                      ),
                      onPressed: () {
                        if (_isLogin) {
                          loginForm(_emailController.text.trim(),
                              _passwordController.text.trim());
                        } else {
                          signUpForm(_emailController.text.trim(),
                              _passwordController.text.trim());
                        }
                      },
                    ),
                  if (_isForget)
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
                        forget(_emailController.text.trim());
                      },
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (!_isForget)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Center(
                        child: Text(
                            _isLogin
                                ? "Create New Account"
                                : "I already have an account",
                            style: kHeadBottomTxtStyle.copyWith(fontSize: 22)),
                      ),
                    ),
                  if (_isForget)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isForget = !_isForget;
                        });
                      },
                      child: Center(
                        child: Text('I Remember It',
                            style: kHeadBottomTxtStyle.copyWith(fontSize: 22)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
