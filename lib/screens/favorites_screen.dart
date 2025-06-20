import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repice_book/provider/recipes_provider.dart';
import 'package:repice_book/screens/recipe_detail.dart';

import '../models/recipe_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<RecipesProvider>(
        builder: (context, recipeProvider, child) {
          final favoritesRecipes = recipeProvider.favoriteRecipe;

          return favoritesRecipes.isEmpty
              ? Center(child: Text('No favorites recipes'))
              : ListView.builder(
                  itemCount: favoritesRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = favoritesRecipes[index];
                      favoriteRecipesCard(recipe: recipe);
                  }
              );
        }
      ),
    );
  }
}

class favoriteRecipesCard extends StatelessWidget {
  final Recipe recipe;

  const favoriteRecipesCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecipeDetail(recipeName: recipe, recipesData: recipe)));
      },
      child: Card(
        color: Colors.white,
        child: Column(
            children: [
              // Image.network(recipe.image_link),
              Text(recipe.name),
              Text(recipe.author),
              // Text(recipe.recipeSteps),
            ]
        ),
      ),
    );
  }
}


