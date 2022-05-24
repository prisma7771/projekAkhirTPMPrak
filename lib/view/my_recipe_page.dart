import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projek_mealdb/helper/hive_database_fav.dart';
import 'package:projek_mealdb/helper/hive_database_recipe.dart';
import 'package:projek_mealdb/helper/shared_preference.dart';
import 'package:projek_mealdb/view/create_recipe_page.dart';
import 'package:projek_mealdb/view/meal_category.dart';
import 'package:projek_mealdb/view/recipe_detail_page.dart';
import 'favorite_detail_page.dart';
import 'home_page.dart';

class MyRecipePage extends StatefulWidget {
  final String name;
  const MyRecipePage({Key? key, required this.name}) : super(key: key);

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final HiveDatabaseRecipe _hiveRec = HiveDatabaseRecipe();
  late String name = widget.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite Meals"),
        actions: [
          IconButton(
            onPressed: () async {
              String username = await SharedPreference.getUsername();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          username: username,
                        )),
                (_) => false,
              );
            },
            icon: const Icon(Icons.home),
            iconSize: 30,
          )
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    int check = _hiveRec.getLength(widget.name);
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 100,
              width: 400,
              padding: EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () {
                  SharedPreference().setImage("");
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreateRecipe(username: name);
                  }));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 30.0,
                ),
                label: const Text("Add Recipe"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 600,
            child: ValueListenableBuilder(
              valueListenable: _hiveRec.listenable(),
              builder:
                  (BuildContext context, Box<dynamic> value, Widget? child) {
                if (value.isEmpty || check == 0) {
                  return const Center(
                    child: Text("Data Kosong"),
                  );
                }
                debugPrint(widget.name);
                return _buildSuccessSection(_hiveRec);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSection(HiveDatabaseRecipe _hiveRec) {
    // debugPrint("${_hiveRec.getLength(widget.name)}");
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: _hiveRec.getLength(widget.name),
          itemBuilder: (BuildContext context, int index) {
            List filteredUsers = _hiveRec
                .values()
                .where((_localDB) => _localDB.name == widget.name)
                .toList();
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.brown.shade800,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.brown.withOpacity(0.7),
                  ),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MyRecipeDetailPage(
                              list: filteredUsers, index: index);
                        }));
                      },
                      child: _buildItemList(filteredUsers, index))),
            );
          }),
    );
  }

  Widget _buildItemList(List filteredUsers, int index) {
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
                  child: filteredUsers[index].imageMeal == ""
                      ? CircleAvatar(
                          radius: 65.0,
                          child: Center(child: Text("NO IMAGE")),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 65,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: Image.file(
                              File("${filteredUsers[index].imageMeal}"),
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("${filteredUsers[index].nameMeal}".toTitleCase(),
                style: const TextStyle(fontSize: 28.0)),
          )),
           Center(
            child: Container(
              width: 100,
              child: InkWell(
                onTap: (){
                  _hiveRec.deleteData(name, "${filteredUsers[index].nameMeal}");
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                  size: 50.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
    return text;
  }
}
