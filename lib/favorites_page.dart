import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes_for_bacholr/models/recipe.dart';
import 'package:recipes_for_bacholr/recipe_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_recipes') ?? [];

    final List<String> categoryFiles = [
      'assets/dinner_recipes.json',
      'assets/lunch_recipes.json',
      'assets/breakfast_recipes.json',
      'assets/snacks_recipes.json',
      'assets/desserts_recipes.json',
      'assets/bangali_recipes.json',
      'assets/beverages_recipes.json',
    ];

    List<Recipe> allRecipes = [];
    for (String filePath in categoryFiles) {
      try {
        final String response = await rootBundle.loadString(filePath);
        final data = await json.decode(response);
        allRecipes.addAll(List<Recipe>.from(data.map((i) => Recipe.fromJson(i))));
      } catch (e) {
        print('Error loading recipe file: $filePath, error: $e');
      }
    }

    if (mounted) {
      setState(() {
        _favoriteRecipes =
            allRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _favoriteRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Favorites Yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Tap the heart on any recipe to add it to your favorites.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _favoriteRecipes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(recipe: recipe),
                        ),
                      );
                      _loadFavoriteRecipes();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                            child: Image.asset(
                              recipe.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.restaurant_menu, color: Colors.grey, size: 50),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recipe.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
