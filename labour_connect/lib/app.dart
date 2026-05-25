import 'package:flutter/material.dart';
import 'src/helper/authenticate.dart';
import 'src/helper/helperfunctions.dart';
import 'src/screens/home_screen.dart';

class LabourConnectApp extends StatelessWidget {
  const LabourConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabourConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A4A2E),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AppState(),
    );
  }
}

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppState> {
  bool userLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  getLoggedInState() async {
    final loggedIn = await HelperFunctions.getUserLoggedIn();
    if (loggedIn != null) {
      setState(() {
        userLoggedIn = loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userLoggedIn ? HomeScreen() : Authenticate();
  }
}