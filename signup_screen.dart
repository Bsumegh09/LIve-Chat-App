import 'package:flutter/material.dart';
import 'package:talkme/auth_method.dart';
import 'package:talkme/cust_text.dart';
import 'package:talkme/reponsive.dart';
import 'package:talkme/widgets/cust_button.dart';
import 'package:talkme/HomeScreen.dart';
import 'loding_indicator.dart';
class SignupScreen extends StatefulWidget{
  static const String routeName='/Signup';
  const SignupScreen({Key?key}):super(key: key);

  @override
  State<SignupScreen> createState()=>_SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen>
{     final TextEditingController _emailController = TextEditingController();
     final TextEditingController _UserNameController = TextEditingController();
     final TextEditingController _PasswordController=TextEditingController();
     final Authmethods _authmethods=Authmethods();
bool _isLoding=false;
     void SignUpUser() async{
       setState(() {
         _isLoding=true;
       });
       bool res =await _authmethods.signupUser(
           context, _emailController.text,
           _UserNameController.text,
           _PasswordController.text);
       setState(() {
         _isLoding=false;
       });
       if(res)
         {
           Navigator.pushReplacementNamed(context, HomeScreen.routeName);
         }
}
  @override
  void dispose()
  {
    _emailController.dispose();
    _PasswordController.dispose();
    _UserNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {  final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body:   _isLoding
          ? const LodingIndicator()
          : Responsive(
            child: SingleChildScrollView(
                    child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   SizedBox(height: size.height*0.1,),
                 const Text('Email',
                style: TextStyle(fontWeight: FontWeight.bold
                ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextField(
                    controller:_emailController,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('User Name',
                  style: TextStyle(fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextField(
                    controller:_UserNameController,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Password',
                  style: TextStyle(fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextField(
                    controller:_PasswordController,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(onTap: SignUpUser, text: 'Sign up'),
              ],
            ),
                    ),
                  ),
          ),
    );
  }
}
