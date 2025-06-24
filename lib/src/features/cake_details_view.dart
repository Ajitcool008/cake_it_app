import 'package:cake_it_app/src/features/cake.dart';
import 'package:cake_it_app/src/localization/app_localizations.dart';
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

    // Localize default values if they exist
    final localizedTitle = cake.title == 'Unknown Cake'
        ? AppLocalizations.of(context)!.unknownCake
        : cake.title;
    final localizedDescription = cake.description == 'No description available'
        ? AppLocalizations.of(context)!.noDescriptionAvailable
        : cake.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cakeDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCakeImage(context, cake),
            const SizedBox(height: 16),
            Text(localizedTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(localizedDescription),
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
    return Builder(
      builder: (context) => Container(
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
              AppLocalizations.of(context)!.imageNotAvailable,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoading() {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.loadingImage,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Builder(
      builder: (context) => Container(
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
              AppLocalizations.of(context)!.noImageAvailable,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
