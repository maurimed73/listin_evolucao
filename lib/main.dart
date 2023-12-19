import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listin_evolucao/_core/my_colors.dart';
import 'package:listin_evolucao/firestore/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listin - Lista Colaborativa',
      theme: ThemeData(
        scaffoldBackgroundColor: MyColors.green,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: MyColors.red,
          foregroundColor: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: MyColors.blue,
        ),
        primarySwatch: MyColors.brown,
        appBarTheme: const AppBarTheme(
          color: MyColors.brown,
          toolbarHeight: 72,
          titleTextStyle: TextStyle(fontSize: 14),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
