import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'model/config.dart';
import 'model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  late double screenHeight, screenWidth, resWidth;
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth * 0.85;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              child: Image.asset(
                  'assets/images/Bubble balloon with mix chocolate bucket bouquet(4).PNG'),
              width: resWidth),
          Text(
            "BOUQUET DELIVERY SEPANG",
            style: TextStyle(
                fontSize: resWidth * 0.07,
                //color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    late User user;
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse(MyConfig.server + "/lab3/loginuser.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          user = User.fromJson(jsonResponse);
          Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (content) => MainPage(user: user),
                  )));
        } else {
          user = User(
              id: "na",
              name: "na",
              email: "na",
              phone: "na",
              address: "na",
              regdate: "na",
              otp: "na",
              credit: 'na');
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainPage(user: user))));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          address: "na",
          regdate: "na",
          otp: "na",
          credit: '');
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainPage(user: user))));
    }
  }
}
