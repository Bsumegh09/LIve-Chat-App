import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkme/go_live_screen.dart';
import 'package:talkme/user_provider.dart';
import 'package:talkme/utils/colours.dart';
import 'feed_screen.dart';
class HomeScreen extends StatefulWidget {
  static String routeName='/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 int _page=0;
 List<Widget>pages=[
   const FeedScreen(),
   const GoliveScreen(),
   const Center(child:Text('Browser')),
 ];
  onPageChange(int page)
  { setState(() {
    _page=page;
  });

  }
  @override
  Widget build(BuildContext context) {
    final userProvider=Provider.of<UserProvider>(context);
    return Scaffold(
    bottomNavigationBar: BottomNavigationBar(
      selectedItemColor: Colors.purple,
      unselectedItemColor: primaryColour,
      backgroundColor: backgroundColour,
      unselectedFontSize:12,
      onTap: onPageChange,
      currentIndex: _page,
      items: const [
        BottomNavigationBarItem(
        icon:Icon(Icons.favorite),
          label:'Following',
        ),

        BottomNavigationBarItem(
          icon:Icon(Icons.live_tv_outlined),
          label:'Go Live',
        ),

        BottomNavigationBarItem(
          icon:Icon(Icons.person_search_rounded),
          label:'Browser',
        ),
      ],
    ),
      body: pages[_page],
    );
  }
}
