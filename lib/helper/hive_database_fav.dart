import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_mealdb/hive_model/myfavorite_model.dart';

class HiveDatabaseFav {
  late Box<MyFavorite> _localDB = Hive.box<MyFavorite>("favorite");

  void addData(MyFavorite data) {
    _localDB.add(data);
  }

  void deleteData(String? name, String? idMeal) {

    for (int i = 0; i < getLengthAll(); i++) {
      if (name == _localDB.getAt(i)!.name && idMeal == _localDB.getAt(i)!.idMeal) {
        _localDB.deleteAt(i);
        break;
      }
    }
  }

  void showAll(){
    for (int i = 0; i < getLengthAll(); i++) {
        debugPrint("${_localDB.getAt(i)!.name}");
      }
    }

  int getLength(String? username) {
    var filteredUsers = _localDB.values
        .where((_localDB) => _localDB.name == username)
        .toList();
    return filteredUsers.length;
  }

  int getLengthAll() {
    return _localDB.length;
  }

  List values() {
    List values = _localDB.values.toList();
    return values;
  }

  // String? getStringName(index){
  //   return _localDB.getAt(index)!.name;
  // }
  //
  // String? getStringImage(index){
  //   return _localDB.getAt(index)!.imageMeal;
  // }
  //
  // String? getStringMealName(index){
  //   return _localDB.getAt(index)!.nameMeal;
  // }
  //
  // String? getStringID(index){
  //   return _localDB.getAt(index)!.idMeal;
  // }

  ValueListenable<Box<MyFavorite>> listenable() {
    return _localDB.listenable();
  }

  bool checkFavorite(String? username, String? idMeal) {
    bool found = false;
    for (int i = 0; i < getLengthAll(); i++) {

      if (username == _localDB.getAt(i)!.name && idMeal == _localDB.getAt(i)!.idMeal) {
        found = true;
        break;
      } else {
        found = false;
      }
    }return found;
  }
}

  // bool checkLogin(String username, String password) {
  //   bool found = false;
  //   for(int i = 0; i< getLength(); i++){
  //     if (username == _localDB.getAt(i)!.username && password == _localDB.getAt(i)!.password) {
  //       SharedPreference().setLogin(username);
  //       print("Login Success");
  //       found = true;
  //       break;
  //     } else {
  //       found = false;
  //     }
  //   }
