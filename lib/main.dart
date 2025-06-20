import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repice_book/provider/recipes_provider.dart';
import 'package:repice_book/screens/favorites_screen.dart';
import 'package:repice_book/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipesProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Hola mundo",
        home: RecipeBook(),
      ),
    );
  }
}

class RecipeBook extends StatelessWidget {
  const RecipeBook({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Recipe Book", style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.home, color: Colors.white),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.favorite, color: Colors.white),
                text: "Favorites",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [HomeScreen(), FavoritesScreen()]),
      ),
    );
  }
}
