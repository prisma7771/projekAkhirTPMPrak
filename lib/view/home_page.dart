import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_mealdb/helper/search_bar.dart';
import 'package:projek_mealdb/helper/shared_preference.dart';
import 'package:projek_mealdb/transit/change_page_login.dart';
import 'package:projek_mealdb/view/meal_area.dart';
import 'package:projek_mealdb/view/meal_category.dart';
import 'package:projek_mealdb/view/meal_ingredient.dart';
import 'package:projek_mealdb/view/meal_list_page.dart';
import 'package:projek_mealdb/view/random_detail_page.dart';

import 'favorit_meal_list_page.dart';
import 'my_recipe_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "OUR FOOD RECIPE",
              style: TextStyle(
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            actions: [
              Center(
                  child: Text(
                "Hello, ${widget.username}",
                style: TextStyle(fontSize: 18),
              )),
              IconButton(
                onPressed: () {
                  SharedPreference().setLogout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePageLogin()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout),
              )
            ]),
        body: Container(
          color: Colors.brown.shade100,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SearchBar(),
                _buildMenu(),
                _buildItemFavorite(
                    "MY FAVORITE", Colors.brown.shade400, widget.username, 1),
                _buildItemFavorite(
                    "MY RECIPE", Colors.brown.shade200, widget.username, 2),
                const Center(
                    child: Text(
                  "By Alphabet",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'Koulen',
                      fontWeight: FontWeight.bold),
                )),
                _buildAlphabet(),
              ],
            ),
          ),
        ));
  }

  Widget _buildMenu() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 42, 28, 18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
        mainAxisSpacing: 15,
      ),
      children: [
        _buildItem("Category", Colors.brown.shade500, 1),
        _buildItem("Ingredient", Colors.brown.shade400, 2),
        _buildItem("Random", Colors.brown.shade400, 3),
        _buildItem("Area", Colors.brown.shade500, 4)
      ],
    );
  }

  Widget _buildCircleDecoration({required double height}) {
    return Positioned(
      top: -height * 0.616,
      left: -height * 0.53,
      child: CircleAvatar(
        radius: (height * 1.03) / 2,
        backgroundColor: Colors.white.withOpacity(0.14),
      ),
    );
  }

  Widget _buildItem(String title, color, int route) {
    return LayoutBuilder(builder: (context, constrains) {
      final itemHeight = constrains.maxHeight;
      return Stack(
        children: <Widget>[
          Material(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.brown.shade800,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => route == 1
                            ? CategoryListPage()
                            : route == 2
                                ? IngredientsListPage()
                                : route == 3
                                    ? RandomDetailPage()
                                    : AreaListPage()),
                  );
                },
                child: Stack(
                  children: [
                    _buildCircleDecoration(height: itemHeight),
                    Center(
                      child: Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24.0,
                            fontFamily: 'Caveat'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItemFavorite(String title, color, String name, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.brown.shade800,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(25),
            color: color),
        child: InkWell(
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          onTap: () {
            i == 1
                ? Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                    return MyFavoritPage(name: name);
                  }))
                : Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                    return MyRecipePage(name: name);
                  }));
          },
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  fontFamily: 'Caveat'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22.0),
      child: Container(
        alignment: Alignment.center,
        // height: 200.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown.shade800, width: 4.0),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Wrap(
            runSpacing: 4,
            spacing: 4,
            alignment: WrapAlignment.center,
            children: List.generate(26, (index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MealListPage(value: alphabet[index], index: 3);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.brown.shade600,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.brown.withOpacity(0.6),
                  ),
                  width: 50,
                  height: 50,
                  child: Center(child: Text(alphabet[index])),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
