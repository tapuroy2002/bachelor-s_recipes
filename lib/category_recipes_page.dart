import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes_for_bacholr/models/recipe.dart';
import 'package:recipes_for_bacholr/recipe_detail_page.dart';

class CategoryRecipesPage extends StatefulWidget {
  final String category;

  const CategoryRecipesPage({super.key, required this.category});

  @override
  State<CategoryRecipesPage> createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final String fileName;
    switch (widget.category.toLowerCase()) {
      case 'bangali':
        fileName = 'bangali_recipes.json';
        break;
      default:
        fileName = '${widget.category.toLowerCase()}_recipes.json';
    }

    final String filePath = 'assets/$fileName';

    try {
      final String response = await rootBundle.loadString(filePath);
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _recipes = List<Recipe>.from(data.map((i) => Recipe.fromJson(i)));
        });
      }
    } catch (e) {
      print('Error loading recipe file: $filePath, error: $e');
      if (mounted) {
        setState(() {
          _recipes = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: _recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No Recipes Found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There are no recipes in the ${widget.category} category yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _recipes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(recipe: recipe),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          recipe.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            recipe.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
