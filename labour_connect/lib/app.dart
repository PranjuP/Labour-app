import 'package:flutter/material.dart';
import 'helper/authenticate.dart';
import 'helper/helperfunctions.dart';
import 'screens/home_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool? _userIsLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final loggedIn = await HelperFunctions.getUserLoggedIn();
    setState(() => _userIsLoggedIn = loggedIn ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabourConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          primary: const Color(0xFF1A4A2E),
          secondary: const Color(0xFF6EE89E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A4A2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A4A2E), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1A4A2E),
          foregroundColor: Colors.white,
        ),
      ),
      home: _userIsLoggedIn == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()))
          : _userIsLoggedIn!
              ?  HomeScreen()
              :  Authenticate(),
    );
  }
}
