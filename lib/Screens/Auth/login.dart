import 'dart:math';

import 'package:mentorai/Screens/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentorai/Assets/image.dart';
import 'package:mentorai/Screens/Auth/Signup.dart';
import 'package:mentorai/Screens/components/buttons.dart' as components;

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Center(
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Center(
                child: Text(
                  'Sign in to unlock exclusive features and personalized content',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              AuthField(controller: _emailController, hintText: 'Enter Email'),
              const SizedBox(height: 30),
              AuthField(
                controller: _passwordController,
                hintText: 'Enter Password',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpView()),
                        );
                      },
                      text: 'Create an Accounts?',
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextButton(
                      onPressed: () {},
                      text: 'Forget Password?',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ShakeWidget(
                key: _shakeKey,
                shakeOffset: 10.0,
                shakeDuration: const Duration(milliseconds: 500),
                child: components.PrimaryButton(
                  onTap: () {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                    } else {
                      _shakeKey.currentState?.shake();
                    }
                  },
                  text: 'Login',
                ),
              ),
              const SizedBox(height: 20),
              const DividerWithText(),
              const SizedBox(height: 20),
              CustomSocialButton(
                onTap: () {},
                icon: AppImages.kFaceBook,
                text: 'Join using Facebook',
                margin: 0,
              ),
              const SizedBox(height: 20),
              CustomSocialButton(
                onTap: () {},
                icon: AppImages.kGoogle,
                text: 'Join using Google',
                margin: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider()),
          SizedBox(width: 15),
          Text(
            'or',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 15),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}

abstract class ShakeAnimation<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  ShakeAnimation(this.animationDuration);
  final Duration animationDuration;
  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    required this.child,
    required this.shakeOffset,
    Key? key,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  // ignore: no_logic_in_create_state
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends ShakeAnimation<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue = sin(
          widget.shakeCount * 2 * pi * animationController.value,
        );
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? const Color(0xFF329494),
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  const AuthField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  const PrimaryContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF329494).withOpacity(0.2),
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
