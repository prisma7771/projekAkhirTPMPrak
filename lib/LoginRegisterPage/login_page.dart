import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projek_mealdb/LoginRegisterPage/register_page.dart';
import 'package:projek_mealdb/helper/common_submit_button.dart';
import 'package:projek_mealdb/helper/hive_database_user.dart';
import 'package:projek_mealdb/helper/shared_preference.dart';
import 'package:projek_mealdb/main.dart';
import 'package:projek_mealdb/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if(form != null){
      if (form.validate()) {
        print('Form is valid');
      } else {
        print('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,4,8,8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                  child: Container(
                    // height:300.0,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 6, color: Colors.orange),
                        borderRadius: BorderRadius.circular(200),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: CircleAvatar(
                      radius: 100,
                        backgroundColor:  const Color(0xFFEFEFEF),
                        backgroundImage: Image.asset('assets/images/logo1.png',  fit: BoxFit.cover,).image,
                  ),
                    )),
                ),
            Center(
                child: Stack(
                  children: [
                    // The text border
                    Center(
                      child: Text(
                        'Our Meal\nRecipe!!!',
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'OpenSans',
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 10
                            ..color = Colors.orange.shade700,
                        ),
                      ),
                    ),
                    // The text inside
                    const Center(
                      child: Text(
                        'Our Meal\nRecipe!!!',
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'OpenSans',
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black54),
                        labelText: "USERNAME",
                        hintText: "USERNAME",
                        hintStyle: TextStyle(color: Colors.black87),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black54),
                        label: Text("PASSWORD"),
                        hintText: "PASSWORD",
                        hintStyle: TextStyle(color: Colors.black87),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25.0))
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                _buildLoginButton(),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonSubmitButton(
        labelButton: "LOGIN",
        submitCallback: (value) {
          validateAndSave();
          String currentUsername = _usernameController.value.text;
          String currentPassword = _passwordController.value.text;
          if(currentUsername == "" || currentPassword == ""){
            _showToast("Field Tidak Boldeh Kosong",
                duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          }
          else {
            _processLogin(currentUsername, currentPassword);
          }
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonSubmitButton(
        labelButton: "REGISTER",
        submitCallback: (value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
      ),
    );
  }

  void _processLogin(String username, String password) async {
    final HiveDatabase _hive = HiveDatabase();
    bool found = false;

    found = _hive.checkLogin(username, password);
    if(!found) {
      _showToast("Akun Tidak Ada",
          duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } else{
      SharedPreference().setLogin(username, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(username:username),
        ),
      );
    }
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}){
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}





































