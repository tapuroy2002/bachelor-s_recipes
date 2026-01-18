import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipes_for_bacholr/home_page.dart';
import 'package:recipes_for_bacholr/categories_page.dart';
import 'package:recipes_for_bacholr/favorites_page.dart';
import 'package:recipes_for_bacholr/profile_page.dart';
import 'package:recipes_for_bacholr/providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Easy Recipes',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            home: const RootPage(),
          );
        },
      ),
    );
  }

  ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFF27121),
        secondary: Color(0xFFE94057),
        background: Color(0xFFF9F9F9),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFF333333),
        onSurface: Color(0xFF333333),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.aladinTextTheme(base.textTheme),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.white,
        elevation: 8,
      ),
    );
  }

  ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFF27121),
        secondary: Color(0xFFE94057),
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFFE0E0E0),
        onSurface: Color(0xFFE0E0E0),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.aladinTextTheme(base.textTheme),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 8,
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CategoriesPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              rippleColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              gap: 8,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.category_outlined,
                  text: 'Categories',
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'Favorites',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
