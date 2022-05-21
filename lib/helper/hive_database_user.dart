import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_mealdb/hive_model/myfavorite_model.dart';


class HiveDatabase{
  final Box<UserAccountModel> _localDB = Hive.box<UserAccountModel>("account");

  void addData(UserAccountModel data) {
    _localDB.add(data);
  }

  int getLength() {
    return _localDB.length;
  }

  // void updateHistory(String username, String password, String _search, String images){
  //   for (int i = 0; i < getLength(); i++) {
  //     if (username == _localDB.getAt(i)!.username) {
  //       _localDB.putAt(i,UserAccountModel(username: username, password: password, history: _search, images: images));
  //     }
  //   }
  // }
  //
  // void updateImage(String username, String password, String history, String newImage){
  //   for (int i = 0; i < getLength(); i++) {
  //     if (username == _localDB.getAt(i)!.username) {
  //       _localDB.putAt(i,UserAccountModel(username: username, password: password, history: history, images: newImage));
  //     }
  //   }
  // }
  //
  // String? getHistory(String username) {
  //   String found = '';
  //   for (int i = 0; i < getLength(); i++) {
  //     if (username == _localDB.getAt(i)!.username) {
  //       found = _localDB.getAt(i)!.history!;
  //       break;
  //     } else {
  //       found = '';
  //     }
  //
  //     (_localDB.getAt(i)!.username+"www");
  //
  //   }
  //   return found;
  // }

  // String? getImage(String username) {
  //   String found = '';
  //   for (int i = 0; i < getLength(); i++) {
  //     if (username == _localDB.getAt(i)!.username) {
  //       found = _localDB.getAt(i)!.images!;
  //       break;
  //     } else {
  //       found = '';
  //     }
  //   }
  //   return found;
  // }

  bool checkLogin(String username, String password) {
    bool found = false;
    for(int i = 0; i< getLength(); i++){
      if (username == _localDB.getAt(i)!.username && password == _localDB.getAt(i)!.password) {
        ("Login Success");
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }

  bool checkUsers(String username) {
    bool found = false;
    for(int i = 0; i< getLength(); i++){
      if (username == _localDB.getAt(i)!.username) {
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }

}