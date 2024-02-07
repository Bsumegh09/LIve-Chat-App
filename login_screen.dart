import 'package:flutter/material.dart';
import 'package:talkme/auth_method.dart';
import 'package:talkme/cust_text.dart';
import 'package:talkme/loding_indicator.dart';
import 'package:talkme/reponsive.dart';
import 'package:talkme/widgets/cust_button.dart';
import 'package:talkme/HomeScreen.dart';
class LoginScreen extends StatefulWidget{
  static const String routeName='/login';
  const LoginScreen({Key?key}):super(key: key);
  @override
  State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>
{     final TextEditingController _emailController = TextEditingController();
final TextEditingController _PasswordController=TextEditingController();
final Authmethods _authmethods=Authmethods();
bool _isLoding=false;
loginUser()async{
  setState(() {
    _isLoding=true;
  });
  bool res=await _authmethods.logInUser(context,
      _emailController.text,
      _PasswordController.text
  );
  setState(() {
    _isLoding=false;
  });
  if(res)
    { Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
}
@override
void dispose()
{
  _emailController.dispose();
  _PasswordController.dispose();
  super.dispose();
}
@override
  Widget build(BuildContext context)
{  final size=MediaQuery.of(context).size;
return Scaffold(
  appBar: AppBar(
    title: const Text('Log In'),
  ),
  body:  _isLoding
      ? const LodingIndicator()
      :Responsive(
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
            CustomButton(onTap: loginUser, text: 'LogIn'),
          ],
        ),
      ),
    ),
  ),
);
}
}
