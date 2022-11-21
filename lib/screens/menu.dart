import "package:flutter/material.dart";
import 'package:flutter_login_ui/screens/CompaniesList.dart';
import 'package:flutter_login_ui/screens/Info.dart';



class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  void onTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Info(),
          CompaniesScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile" ),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance),label: "Company" )
      ],
      currentIndex:  _selectedIndex,
        selectedItemColor: Colors.red[400],
        unselectedItemColor: Colors.grey,
        onTap: onTapped),
    );
  }
}


