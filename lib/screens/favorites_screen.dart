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
                    return favoriteRecipesCard(recipe: recipe);
                  },
                );
        },
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
                RecipeDetail(recipeName: recipe, recipesData: recipe),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.image_link,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 50,
                      height: 2,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 4),
                    Text(
                      recipe.author,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}