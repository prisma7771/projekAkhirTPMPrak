import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projek_mealdb/helper/common_submit_button.dart';
import 'package:projek_mealdb/helper/hive_database_user.dart';
import 'package:projek_mealdb/hive_model/myfavorite_model.dart';

import '../main.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HiveDatabase _hive = HiveDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isExist = false;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-80,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: Center(child: Text("REGISTRATION FORM", style: TextStyle(fontSize: 34, fontFamily: 'OpenSans'),),),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:16,horizontal: 24.0),
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
                    validator: (value) => value!.isEmpty ? 'Username cannot be blank':null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:16,horizontal: 24.0),
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
                  validator: (value) => value!.isEmpty ? 'Password cannot be blank' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: _buildRegisterButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return CommonSubmitButton(
      labelButton: "REGISTER",
      submitCallback: (value) {
        isExist = _hive.checkUsers(_usernameController.text);
        if (isExist == false && _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          _hive.addData(
              UserAccountModel(
                  username: _usernameController.text,
                  password: _passwordController.text,

              )
          );
          _usernameController.clear();
          _passwordController.clear();
          setState(() {});

          Navigator.pop(context);
        }
        else{
          _showToast("Akun Sudah Ada",
              duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        }
      },
    );
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}){
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}
