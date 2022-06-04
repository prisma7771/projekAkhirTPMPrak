import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projek_mealdb/helper/hive_database_recipe.dart';
import 'package:projek_mealdb/helper/shared_preference.dart';
import 'package:projek_mealdb/hive_model/myfavorite_model.dart';
import 'package:projek_mealdb/image_picker/image_picker_section.dart';
import 'package:projek_mealdb/model/ingredient_list_model.dart';
import 'package:projek_mealdb/source/meal_source.dart';

class CreateRecipe extends StatefulWidget {
  final String username;

  const CreateRecipe({Key? key, required this.username}) : super(key: key);

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final HiveDatabaseRecipe _hiveRec = HiveDatabaseRecipe();
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final TextEditingController _searchController3 = TextEditingController();
  List<String> ingredients = [];
  String _recipename = "";
  String _insMeal = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Recipe",
          style: TextStyle(
              fontFamily: 'Caveat',
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
      ),
      body: _buildFormRecipe(),
    );
  }

  Widget _buildFormRecipe() {
    return FutureBuilder(
        future: MealSource.instance.loadIngredient(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            IngredientList ingredientList =
                IngredientList.fromJson(snapshot.data);
            return _buildSuccessSection(ingredientList);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error2");
  }

  Widget _buildSuccessSection(IngredientList data) {
    ingredients = [];
    for (int i = 0; i < data.meals!.length; i++) {
      ingredients.add("${data.meals?[i].strIngredient}");
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text(
              "Hello, ${widget.username}!!!\nCreate your Recipe!!!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.brown.shade100),
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.brown.shade200),
              height: MediaQuery.of(context).size.height - 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImagePickerSection(
                  img: '',
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildForm(),
            ),
            SizedBox(
              height: 24,
            ),
            _buildButtonSubmit()
          ],
        ),
      ),
    );
  }

  Widget _formInput(
      {required String hint,
      required String label,
      required Function(String value) setStateInput,
      int maxLines = 1,
      int charSize = 0}) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(charSize),
      ],
      enabled: true,
      maxLines: maxLines,
      decoration: InputDecoration(
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.brown),
          hintText: hint,
          label: Text(label),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.brown),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.brown),
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      onChanged: setStateInput,
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        _formInput(
            hint: "Enter Recipe Name",
            label: "Recipe Name",
            setStateInput: (value) {
              setState(() {
                _recipename = value;
              });
            },
            charSize: 50),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(1),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(2),
        const SizedBox(
          height: 12,
        ),
        _formSuggest(3),
        const SizedBox(
          height: 12,
        ),
        _formInput(
            hint: "Instruction",
            label: "Type Instruction... ",
            setStateInput: (value) {
              setState(() {
                _insMeal = value;
              });
            },
            maxLines: 10,
            charSize: 200),
      ],
    );
  }

  Widget _formSuggest(int ing) {
    List<String> getSuggestions(String query) {
      List<String> matches = <String>[];
      matches.addAll(ingredients);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }

    return TypeAheadField(
      hideOnEmpty: true,
      suggestionsCallback: (pattern) {
        return getSuggestions(pattern);
      },
      textFieldConfiguration: TextFieldConfiguration(
          controller: ing == 1
              ? _searchController1
              : ing == 2
                  ? _searchController2
                  : _searchController3,
          decoration: const InputDecoration(
              fillColor: Colors.white,
              labelStyle: TextStyle(color: Colors.brown),
              labelText: "Ingredient",
              hintText: "Ingredient",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.brown),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.brown),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))))),
      onSuggestionSelected: (String suggestion) {
        ing == 1
            ? _searchController1.text = suggestion
            : ing == 2
                ? _searchController2.text = suggestion
                : _searchController3.text = suggestion;
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
    );
  }

  Widget _buildButtonSubmit() {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          bool check = _hiveRec.checkData(widget.username, _recipename);
          if (_recipename.isEmpty ||
              _searchController1.text.isEmpty ||
              _searchController2.text.isEmpty ||
              _searchController3.text.isEmpty ||
              _insMeal.isEmpty) {
            _showToast("Please fill all field",
                duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          } else if (check == true) {
            _showToast("Meal Recipe is already exist",
                duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          } else {
            String img = await SharedPreference.getImage();
            _hiveRec.addData(MyRecipeModel(
                name: widget.username,
                nameMeal: _recipename,
                imageMeal: img,
                ingMeal1: _searchController1.text,
                ingMeal2: _searchController2.text,
                ingMeal3: _searchController3.text,
                insMeal: _insMeal));
            Navigator.pop(context);

            _searchController1.clear();
            _searchController2.clear();
            _searchController3.clear();
          }
        },
        child: Text("Add"),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}) {
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}
