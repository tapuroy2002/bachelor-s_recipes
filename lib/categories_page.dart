import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes_for_bacholr/category_recipes_page.dart';
import 'package:recipes_for_bacholr/models/recipe.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
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
        _categories = allRecipes.map((recipe) => recipe.category).toSet().toList();
      });
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'desserts':
        return Icons.cake;
      case 'snacks':
        return Icons.fastfood;
      case 'bangali':
        return Icons.ramen_dining;
      case 'beverages':
        return Icons.local_bar;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryRecipesPage(category: category),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForCategory(category),
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
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
