import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final RiveAnimationController _btnAnimationController =
      OneShotAnimation("active", autoplay: false);

  bool isShowSignInDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          child: Image.asset("assets/Backgrounds/Spline.png"),
          // height: 100,
          width: MediaQuery.of(context).size.width * 1.7,
          bottom: 200,
          left: 100,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(),
          ),
        ),
        const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          ),
        ),
        AnimatedPositioned(
          top: isShowSignInDialog ? -50 : 0,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 260),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  const SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Text(
                          "AI Gallery App",
                          style: TextStyle(
                              fontSize: 60, fontFamily: "Poppins", height: 1.2),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Transform your photos into stunning art with AI-powered search and editing features in AI Gallery App.",
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  AnimatedBtn(
                    btnAnimationController: _btnAnimationController,
                    press: () {
                      _btnAnimationController.isActive = true;

                      Future.delayed(
                        const Duration(milliseconds: 800),
                        () {
                          setState(() {
                            isShowSignInDialog = true;
                          });
                          showCustomDialog(
                            context,
                            onValue: (_) {},
                          );
                        },
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 26)),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
