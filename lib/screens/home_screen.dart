import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repice_book/provider/recipes_provider.dart';
import 'package:repice_book/screens/recipe_detail.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );
    recipesProvider.fetchRecipes();

    return Scaffold(
      body: Consumer<RecipesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.recipes.isEmpty) {
            return const Center(child: Text("No recipes found"));
          } else {
            return ListView.builder(
              itemCount: provider.recipes.length,
              itemBuilder: (context, index) {
                return _RecipesCard(context, provider.recipes[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showBottom(context);
        },
      ),
    );
  }

  Future<void> _showBottom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          // 🛟 Permite hacer scroll si no cabe
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: RecipeForm(),
          ),
        ),
      ),
    );
  }

  Widget _RecipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipeName: recipe, recipesData: recipe),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: <Widget>[
                Container(
                  height: 125,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      recipe.image_link,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 26),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipe.name,
                      style: TextStyle(fontSize: 16, fontFamily: "Quicksand"),
                    ),
                    SizedBox(height: 4),
                    Container(height: 1, width: 50, color: Colors.orange),
                    Text(
                      recipe.author,
                      style: TextStyle(fontSize: 16, fontFamily: "Quicksand"),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeForm extends StatefulWidget {
  const RecipeForm({Key? key});

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _recipeName = TextEditingController();
  final TextEditingController _recipeAuthor = TextEditingController();
  final TextEditingController _recipeIMG = TextEditingController();
  final TextEditingController _recipeDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                'Add New Recipe',
                style: TextStyle(fontSize: 20, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeName,
              label: "Recipe Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe name';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeAuthor,
              label: "Author",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Author`s name';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeIMG,
              label: "Image URL",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Image URL';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeDescription,
              label: "Recipe",
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Desciption of the recipe';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save Recipe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: "Quicksand", color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
