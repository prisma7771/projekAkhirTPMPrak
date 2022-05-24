import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_mealdb/helper/hive_database_fav.dart';
import 'package:projek_mealdb/helper/search_bar.dart';
import 'package:projek_mealdb/helper/shared_preference.dart';
import 'package:projek_mealdb/hive_model/myfavorite_model.dart';
import 'package:projek_mealdb/model/meal_list_model.dart';
import 'package:projek_mealdb/source/meal_source.dart';
import 'package:projek_mealdb/view/meal_category.dart';
import '../main.dart';
import 'detail_page.dart';
import 'favorite_detail_page.dart';
import 'home_page.dart';


class MyFavoritPage extends StatefulWidget {
  final String name;
  const MyFavoritPage({Key? key, required this.name}) : super(key: key);

  @override
  State<MyFavoritPage> createState() => _MyFavoritPageState();
}

class _MyFavoritPageState extends State<MyFavoritPage> {
  final HiveDatabaseFav _hiveFav = HiveDatabaseFav();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite Meals"),
        actions: [
          IconButton(onPressed: () async {
            String username  = await SharedPreference.getUsername();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                    username: username,
                  )),
                  (_) => false,
            );
          }, icon: const Icon(Icons.home), iconSize: 30,)
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList(){
    int check = _hiveFav.getLength(widget.name);
    return Container(
      height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder(
          valueListenable: _hiveFav.listenable(),
          builder: (BuildContext context, Box<dynamic> value, Widget? child){
            if(value.isEmpty ||  check == 0){
              return Center(
                child: Text("Data Kosong"),
              );
            }
            debugPrint(widget.name);
            return _buildSuccessSection(_hiveFav);
          },
        ),
      );
  }

  Widget _buildSuccessSection(HiveDatabaseFav _hiveFav) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child:  ListView.builder(
                itemCount: _hiveFav.getLength(widget.name),
                itemBuilder: (BuildContext context, int index){
                  List filteredUsers = _hiveFav.values()
                      .where((_localDB) => _localDB.name == widget.name)
                      .toList();
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                        decoration:
                        BoxDecoration(
                          border: Border.all(color: Colors.brown.shade800, width: 3.0,),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.brown.withOpacity(0.7),
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return FavoriteDetailPage(
                                        list: filteredUsers,
                                        index: index);
                                  })
                              );
                            },
                            child: _buildItemList(
                                filteredUsers, index
                            ))),
                  );
                })
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List filteredUsers, int index) {
    String imageUrl = "${filteredUsers[index].imageMeal}";
    var text = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.brown.shade800,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    imageUrl,
                    width: 130.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("${filteredUsers[index].nameMeal}".toTitleCase(), style: const TextStyle(fontSize: 28.0)),
          )),
        ],
      ),
    );
    return text;
  }

}
