import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A reusable profile avatar widget that lets the user pick an image
/// from camera or gallery, saves it to the app documents directory,
/// and persists the saved path in SharedPreferences.
class ProfileAvatar extends StatefulWidget {
  final double radius;
  final String prefsKey;
  final void Function(String? path)? onImageChanged;

  const ProfileAvatar({
    Key? key,
    this.radius = 60,
    this.prefsKey = 'profile_image_path',
    this.onImageChanged,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString(widget.prefsKey);
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          setState(() => _imagePath = path);
        } else {
          // stale path - remove
          await prefs.remove(widget.prefsKey);
        }
      }
    } catch (_) {
      // ignore errors and keep default avatar
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
      final savedPath = p.join(appDir.path, fileName);

      // copy to app dir
      final savedFile = await File(picked.path).copy(savedPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(widget.prefsKey, savedFile.path);

      setState(() => _imagePath = savedFile.path);
      widget.onImageChanged?.call(savedFile.path);
    } catch (e) {
      // show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  Future<void> _removeImage() async {
    try {
      if (_imagePath != null) {
        final f = File(_imagePath!);
        if (await f.exists()) await f.delete();
      }
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(widget.prefsKey);
    setState(() => _imagePath = null);
    widget.onImageChanged?.call(null);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _removeImage();
                },
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.radius;
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: _showPickerOptions,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color.withOpacity(0.1),
        child: ClipOval(
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: _loading
                ? Center(child: CircularProgressIndicator(color: color))
                : (_imagePath != null
                    ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                    : Icon(
                        Icons.person_outline,
                        size: radius * 1.15,
                        color: color,
                      )),
          ),
        ),
      ),
    );
  }
}
