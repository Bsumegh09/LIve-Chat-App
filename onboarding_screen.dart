import 'package:flutter/material.dart';
import 'package:talkme/login_screen.dart';
import 'package:talkme/reponsive.dart';
import 'package:talkme/signup_screen.dart';
import 'widgets/cust_button.dart';
class Onboarding extends StatelessWidget{
  static const routeName='/Onboarding';
  const Onboarding({Key? key}): super(key:key);
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Text('Welcome to\n Stremer ',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,

              ),
                 textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomButton(onTap:(){
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }, text: 'Log in',),
              ),
              CustomButton(onTap:(){
                Navigator.pushNamed(context, SignupScreen.routeName);
              }, text: 'Sign up',),

            ],
          ),
        ),
      ),
    );
  }

}