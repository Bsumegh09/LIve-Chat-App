
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkme/auth_method.dart';
import 'package:talkme/login_screen.dart';
import 'package:talkme/signup_screen.dart';
import 'package:talkme/user_provider.dart';
import 'onboarding_screen.dart';
import 'utils/colours.dart';
import 'package:talkme/HomeScreen.dart';
import 'user_model.dart' as model;
import 'loding_indicator.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
        await Firebase.initializeApp(
        options: const FirebaseOptions(
        apiKey: "AIzaSyBWg5kNHRxangY_SEfKZhUB0CDAqOOEaIw",
        appId: "1:625435038811:android:71d6078ed0f8cc995e9b7e",
        messagingSenderId: "625435038811",
        projectId: "talk-me-app-4791f"
   ),
  );}
  else{
    await Firebase.initializeApp();
  }
  runApp(
         MultiProvider(
          providers:
          [
             ChangeNotifierProvider(create: (_)=>UserProvider(),) //_will return Context
           ],
         child:const MyApp()
      )
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streaming',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColour,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColour,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: primaryColour,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: primaryColour),
        )
      ),
      routes:{
        Onboarding.routeName:(context)=> const Onboarding(),
        LoginScreen.routeName:(context)=>const LoginScreen(),
        SignupScreen.routeName:(context)=> const SignupScreen(),
        HomeScreen.routeName:(context)=>const HomeScreen(),
      },
      home: FutureBuilder(
        future: Authmethods().getCurrentUser(FirebaseAuth.instance.currentUser!=null ?FirebaseAuth.instance.currentUser!.uid:null).then((value) {if(value!=null)
            {
              Provider.of<UserProvider>(context,listen: false).setUser(model.User.fromMap(value));
            } return value;
            }),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return const LodingIndicator();
            }
          if(snapshot.hasData)
            {
              return const HomeScreen();
            } return const Onboarding();
        },
      )
    );
  }
}
