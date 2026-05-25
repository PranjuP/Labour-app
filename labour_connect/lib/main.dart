import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Uncomment after running: flutterfire configure

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Directly initializes Firebase using your google-services.json file
  await Firebase.initializeApp(); 
  
  runApp(const Myapp());
}
