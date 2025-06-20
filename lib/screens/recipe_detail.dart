import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repice_book/models/recipe_model.dart';
import 'package:repice_book/provider/recipes_provider.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({
    super.key,
    required this.recipesData,
    required recipeName,
  });

  final Recipe recipesData;

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipesProvider>(
      context,
      listen: false,
    ).favoriteRecipe.contains(widget.recipesData);
    ;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.recipesData.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<RecipesProvider>(
                context,
                listen: false,
              ).toggleFavoriteStatus(widget.recipesData);
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.recipesData.image_link,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey[700],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.recipesData.author,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("by ${widget.recipesData.author}"),
              ],
            ),

            SizedBox(height: 8),
            Text("Recipes steps:"),

            for (var step in widget.recipesData.recipeSteps) Text("- $step"),
          ],
        ),
      ),
    );
  }
}

/*
                   Image.network(
                      recipe.image_link,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.broken_image),
                        );
                      },
                    ),
                    * */
