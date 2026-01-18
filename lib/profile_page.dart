import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_for_bacholr/providers/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildProfileHeader(context),
          const SizedBox(height: 32),
          _buildSettingsList(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.person_outline,
            size: 70,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Happy Cooking!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(context),
        const SizedBox(height: 24),
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAboutCard(context),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: Icon(Icons.brightness_6_outlined, color: Theme.of(context).colorScheme.primary),
        title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme(value);
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.primary),
            title: Text('Privacy Policy', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          AboutListTile(
            icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
            applicationName: 'Bachelor Recipes',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2024 Bachelor Recipes',
            aboutBoxChildren: const [SizedBox(height: 16), Text('Happy cooking!')],
            child: Text('About App', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Last updated: 2024-01-01

This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.

**Data We Collect and How We Use It**

This app is designed to work offline. However, it uses the google_fonts package to provide a richer user experience, which may fetch fonts from Google servers. This is the only instance where the app makes a network request.

**Local Data Storage**

All data, including your favorite recipes, is stored locally on your device. This data is not transmitted off your device and is solely for your use. You can clear your favorites at any time, which will delete this data. The app also has the capability to interact with other apps to process text, but no data from this interaction is stored.

**Third-Party Services**

The only third-party service used is Google Fonts. We do not share any personal data with them.

**Your Privacy Rights**

Since we do not collect any personal information, your privacy is in your hands. You can manage the data stored by this app by clearing the app data from your device settings.
            ''',
          ),
        ),
      ),
    );
  }
}
