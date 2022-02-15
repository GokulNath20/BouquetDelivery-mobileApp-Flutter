import 'package:flutter/material.dart';
import 'package:project_bouquet_delivery/cartpage.dart';
import 'package:project_bouquet_delivery/profile.dart';
import 'logout.dart';
import 'model/user.dart';
import 'productpurchase.dart';
import 'package:badges/badges.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Purchase";
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
    tabchildren = [
      Productlist(
        user: widget.user,
      ),
      CartPage(
        user: widget.user,
      ),
      if (widget.user.name == 'na')
        LogoutPage(
          user: widget.user,
        )
      else if (widget.user.name != null)
        ProfilePage(
          user: widget.user,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BOUQUET DELIVERY SEPANG'),
        backgroundColor: Colors.pink,
      ),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
                size: resWidth * 0.07,
              ),
              label: "Purchase"),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Column(
              children: [
                if (widget.user.email != 'na') ...[
                  Badge(
                      badgeContent: const Text('0'),
                      child: Icon(Icons.store_mall_directory,
                          size: resWidth * 0.07)),
                ] else ...[
                  Icon(Icons.store_mall_directory, size: resWidth * 0.07),
                ]
              ],
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: resWidth * 0.07),
              label: "Profile"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Purchase";
      }
      if (_currentIndex == 1) {
        maintitle = "Cart";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
