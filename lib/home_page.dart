import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes_for_bacholr/models/recipe.dart';
import 'package:recipes_for_bacholr/recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
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
        // Handle file loading errors, e.g., file not found
        print('Error loading recipe file: $filePath, error: $e');
      }
    }

    if (mounted) {
      setState(() {
        _recipes = allRecipes;
        _filteredRecipes = _recipes;
      });
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show the logo image from assets next to the title. Use double quotes so the single quote in the filename is valid.
        title: Row(
          children: [
            Image.asset(
              "assets/images/bachelor's_recipes.png",
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(child: Icon(Icons.restaurant_menu, size: 24)),
                );
              },
            ),
            const SizedBox(width: 12),
            Text('Easy Recipes', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _filterRecipes,
              decoration: InputDecoration(
                hintText: 'Search for a recipe...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: RawScrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 8.0,
              radius: const Radius.circular(4.0),
              thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _filteredRecipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final recipe = _filteredRecipes[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.1),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: recipe),
                          ),
                        );
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
            ),
          ),
        ],
      ),
    );
  }
}
