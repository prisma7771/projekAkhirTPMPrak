import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_mealdb/view/home_page.dart';
import 'LoginRegisterPage/login_page.dart';
import 'helper/shared_preference.dart';
import 'hive_model/myfavorite_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initiateLocalDB();
  String username = await SharedPreference.getUsername();
  bool status = await SharedPreference.getLoginStatus();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
        primarySwatch: Colors.brown,
      ),
    title: 'Flutter Demo',
      home: status == true
          ? MyApp(
        username: username,
      )
          : const LoginPage()),
  );
}

void initiateLocalDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter<MyFavorite>(MyFavoriteAdapter());
  Hive.registerAdapter<UserAccountModel>(UserAccountModelAdapter());
  Hive.registerAdapter<MyRecipeModel>(MyRecipeModelAdapter());
  await Hive.openBox<MyFavorite>("favorite");
  await Hive.openBox<UserAccountModel>("account");
  await Hive.openBox<MyRecipeModel>("recipe");
}

class MyApp extends StatefulWidget {
  final String username;
  const MyApp({Key? key, required this.username})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()))
        : HomePage(username: widget.username,);
  }
}