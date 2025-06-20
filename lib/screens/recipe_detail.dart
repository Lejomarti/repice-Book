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

class _RecipeDetailState extends State<RecipeDetail>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              _controller.forward();
            },

            icon: ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
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
