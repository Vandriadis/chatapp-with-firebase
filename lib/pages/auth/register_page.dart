import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 80,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                          "Create your account to chat and explore!",
                          style: TextStyle(
                            color: Color(0xFFEF5350),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Image.asset(
                          "assets/register.png",
                          height: 300,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color(0xFFEF5350),
                          decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            floatingLabelStyle: TextStyle(
                              color: Color(0xFFEF5350),
                              fontWeight: FontWeight.w600,
                            ),
                            prefixIcon: Icon(
                              Icons.account_box_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },

                          //check the validation
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name connot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color(0xFFEF5350),
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            floatingLabelStyle: TextStyle(
                              color: Color(0xFFEF5350),
                              fontWeight: FontWeight.w600,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
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
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              floatingLabelStyle: const TextStyle(
                                color: Color(0xFFEF5350),
                                fontWeight: FontWeight.w600,
                              ),
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
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
                                primary: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Login now!",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w900),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const LoginPage());
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
            if(value == true){
              // saving the shared preferences state
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(email);
              await HelperFunctions.saveUserNameSF(fullName);
              nextScreenReplace(context, const HomePage());
            }else{
              showSnackBar(context, Color(0xFFEF5350), value);
              setState(() {
                _isLoading = false;
              });
            }
          });
    }
  }
}
