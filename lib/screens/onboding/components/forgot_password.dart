import 'package:flutter/cupertino.dart';
import 'sign_up_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Password Reset Email has been sent!",
        style: TextStyle(fontSize: 20.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No user found for that email.",
          style: TextStyle(fontSize: 20.0),
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.message ?? "An error occurred",
          style: const TextStyle(fontSize: 20.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 70.0,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: const Text(
                "Password Recovery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Enter your mail",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          controller: mailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 18.0, color: Colors.white70),
                            prefixIcon: Icon(
                              CupertinoIcons.person_circle_fill,
                              color: Colors.white70,
                              size: 30.0,
                            ),
                            border: InputBorder.none,
                            fillColor: Colors
                                .transparent, // Ensure fillColor is transparent
                            filled: true,
                          ),
                          cursorColor:
                              Colors.white, // Set cursor color to white
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = mailController.text;
                            });
                            resetPassword();
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF77D8E),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              "Create",
                              style: TextStyle(
                                  color: Color(0xFFF77D8E),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
