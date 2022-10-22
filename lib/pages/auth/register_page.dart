import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _passwordVisability = true;
  bool _isLoading = false;
  String _messageShow = "Show";
  String _messageHide = "Hide";
  String? _buffer;
  String email = "";
  String password = "";
  String fullName = "";
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
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color(0xFFEF5350),
                              decoration: textInputDecoration.copyWith(
                                counterStyle: TextStyle(color: Colors.white),
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
                                ),
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
                                if (val!.isNotEmpty && val.length < 128) {
                                  return null;
                                } else {
                                  return "Name connot be empty or length more then 128";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 50,
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color(0xFFEF5350),
                              decoration: textInputDecoration.copyWith(
                                counterStyle: TextStyle(color: Colors.white),
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
                                ),
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
                                          nextScreen(
                                              context, const LoginPage());
                                        }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
      );
  void _toogle() {
    setState(() {
      _buffer = _messageShow;
      _messageShow = _messageHide;
      _messageHide = _buffer!;
      _passwordVisability = !_passwordVisability;
    });
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preferences state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Color(0xFFEF5350), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
