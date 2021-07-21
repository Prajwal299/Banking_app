import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_banking_app/screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BANK APP',
      theme: ThemeData(
        primaryColor: Colors.purple[100],
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      home: HomeScreen()));
}
