import 'package:flutter/material.dart';
import '../../core/theme.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _recipeLinkController = TextEditingController();
  String _selectedCategory = 'Breakfast';
  bool _isUploading = false;
  bool _videoSelected = false;

  final categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Quick Eats'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _recipeLinkController.dispose();
    super.dispose();
  }

  void _handlePublish() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a video title'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video published successfully! Processing video...'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashed Drag & Drop Box: Choose video · up to 10 min
            GestureDetector(
              onTap: () {
                setState(() {
                  _videoSelected = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video file selected (Pancakes_recipe.mp4)')),
                );
              },
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.darkCardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _videoSelected ? AppTheme.successGreen : AppTheme.darkBorderColor,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _videoSelected ? Icons.check_circle_outline : Icons.upload_outlined,
                      size: 36,
                      color: _videoSelected ? AppTheme.successGreen : AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _videoSelected ? 'Pancakes_recipe.mp4 ready' : 'Choose video · up to 10 min',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title Field
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 16),

            // Description Field
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown Field
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              dropdownColor: AppTheme.darkCardSurface,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Category',
              ),
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCategory = val;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Link a Recipe (Optional)
            TextField(
              controller: _recipeLinkController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Link a recipe (optional)',
                prefixIcon: Icon(Icons.link, color: AppTheme.textSecondary),
              ),
            ),

            const SizedBox(height: 36),

            // White Pill Primary Button: Publish
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _isUploading ? null : _handlePublish,
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text(
                        'Publish',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
