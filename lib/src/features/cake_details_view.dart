import 'package:cake_it_app/src/features/cake.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a cake.
class CakeDetailsView extends StatelessWidget {
  const CakeDetailsView({
    super.key,
  });

  static const routeName = '/cake_detail';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Cake cake = Cake.fromJson(args);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCakeImage(context, cake),
            const SizedBox(height: 16),
            Text(cake.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(cake.description),
          ],
        ),
      ),
    );
  }

  Widget _buildCakeImage(BuildContext context, Cake cake) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cake.hasValidImage
            ? Image.network(
                cake.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImageError(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoading();
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading image...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cake,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'No image available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
