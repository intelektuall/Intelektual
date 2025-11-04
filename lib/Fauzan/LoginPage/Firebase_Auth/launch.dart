import 'package:flutter/material.dart';
import 'package:sopan_santun_app/Activity/Home.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/auth.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/login_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Auth auth = Auth();
    auth
        .getUSer()
        .then((user) {
          MaterialPageRoute route;
          if (user != null) {
            route = MaterialPageRoute(
              builder: (context) => HomeScreen(user.uid),
            );
          } else {
            route = MaterialPageRoute(builder: (context) => MyLoginAndSignin());
          }
          Navigator.pushReplacement(context, route);
        })
        .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
