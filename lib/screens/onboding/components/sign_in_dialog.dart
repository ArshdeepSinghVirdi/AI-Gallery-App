import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../service/auth.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

void showCustomDialog(BuildContext context,
    {required ValueChanged onValue, String dialogType = 'SignUp'}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: dialogType == 'SignIn' ? 700 : 760,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        dialogType == 'SignIn' ? "Sign In" : "Sign Up",
                        style: const TextStyle(
                          fontSize: 34,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          dialogType == 'SignIn'
                              ? "Explore unique art transformations and experience the future of photo editing and circle search with the power of AI."
                              : "Join us to experience AI-powered photo editing and circle search.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      if (dialogType == 'SignIn')
                        const SignInForm()
                      else
                        const SignUpForm(),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Sign up with Email, Apple or Google",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                "assets/icons/email_box.svg",
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthMethods().signInWithApple();
                            },
                            child: IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                "assets/icons/apple_box.svg",
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthMethods().signInWithGoogle(context);
                            },
                            child: IconButton(
                              onPressed: () {
                                AuthMethods().signInWithGoogle(context);
                              },
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                "assets/icons/google_box.svg",
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue);
}
