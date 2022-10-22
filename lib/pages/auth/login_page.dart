import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  String email = "";
  String password = "";
  String _messageShow = "Show";
  String _messageHide = "Hide";
  String? _buffer;
  bool _isLoading = false;
  bool _passwordVisability = true;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.1,
                0.2,
                0.8,
                0.9
              ],
              colors: [
                Color.fromARGB(189, 49, 46, 46),
                Colors.grey.shade900,
                Color.fromARGB(162, 97, 97, 97),
                Color.fromARGB(188, 90, 84, 84),
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 80,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Groupie",
                            style: TextStyle(
                              color: Color(0xFFEF5350),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Login now to see what they are talking!",
                            style: TextStyle(
                              color: Color(0xFFEF5350),
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Image.asset(
                            "assets/login.png",
                            height: 300,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: const Color(0xFFEF5350),
                            decoration: textInputDecoration.copyWith(
                                
                                labelText: "Email",
                                floatingLabelStyle: const TextStyle(
                                  color: Color(0xFFEF5350),
                                  fontWeight: FontWeight.w600,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suffixIcon: Tooltip(
                                  message: "Clear",
                                  child: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Color(0xFFEF5350),
                                    onPressed: () => _emailController.clear(),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4)),
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },

                            //check the validation
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            cursorColor: const Color(0xFFEF5350),
                            obscureText: _passwordVisability,
                            decoration: textInputDecoration.copyWith(
                                suffixIcon: Tooltip(
                                  message: _messageShow,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4)),
                                  child: GestureDetector(
                                    onTap: () => _toogle(),
                                    child: Icon(
                                      _passwordVisability
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                floatingLabelStyle: const TextStyle(
                                  color: Color(0xFFEF5350),
                                  fontWeight: FontWeight.w600,
                                ),
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Theme.of(context).primaryColor,
                                )),
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              onPressed: () {
                                login();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage());
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );

  void _toogle() {
    setState(() {
      _buffer = _messageShow;
      _messageShow = _messageHide;
      _messageHide = _buffer!;
      _passwordVisability = !_passwordVisability;
    });
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUsernameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, const Color(0xFFEF5350), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
