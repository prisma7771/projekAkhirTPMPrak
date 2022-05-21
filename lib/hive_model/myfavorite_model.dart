import 'package:hive/hive.dart';
part 'myfavorite_model.g.dart';

@HiveType(typeId: 1)
class MyFavorite {

  MyFavorite({required this.name, required this.nameMeal, required this.idMeal, required this.imageMeal});

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? nameMeal;

  @HiveField(2)
  String? imageMeal;

  @HiveField(3)
  String? idMeal;

  // @override
  // String toString() {
  //   return 'DataModel{username: $username, password: $password}';
  // }
}

@HiveType(typeId: 2)
class UserAccountModel {
  UserAccountModel({required this.username, required this.password});

  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @override
  String toString() {
    return 'UserAccountModel{username: $username, password: $password}';
  }
}