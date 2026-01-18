import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipes_for_bacholr/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorited = (prefs.getStringList('favorite_recipes') ?? []).contains(widget.recipe.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_recipes') ?? [];

    setState(() {
      if (_isFavorited) {
        favoriteIds.remove(widget.recipe.id);
      } else {
        favoriteIds.add(widget.recipe.id);
      }
      _isFavorited = !_isFavorited;
    });

    await prefs.setStringList('favorite_recipes', favoriteIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: Colors.orange,
        child: Icon(
          _isFavorited ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      widget.recipe.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.0, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              background: Image.asset(
                widget.recipe.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  _buildInfoRow(context),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle(context, 'Ingredients'),
                  const SizedBox(height: 8.0),
                  _buildIngredientsList(),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle(context, 'Instructions'),
                  const SizedBox(height: 8.0),
                  _buildInstructionsList(),
                  const SizedBox(height: 80), // To make space for the FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoChip(Icons.timer_outlined, '${widget.recipe.duration} min'),
        _infoChip(Icons.leaderboard_outlined, widget.recipe.difficulty),
        _infoChip(Icons.fastfood_outlined, widget.recipe.category),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildIngredientsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.recipe.ingredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 20, color: Colors.orange),
                  const SizedBox(width: 12.0),
                  Expanded(child: Text(ingredient)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInstructionsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(widget.recipe.instructions.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 14,
                    child: Text('${index + 1}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(child: Text(widget.recipe.instructions[index])),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
