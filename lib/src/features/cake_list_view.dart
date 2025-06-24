import 'package:cake_it_app/src/features/cake.dart';
import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake_service.dart';
import 'package:cake_it_app/src/localization/app_localizations.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

/// Displays a list of cakes.
class CakeListView extends StatelessWidget {
  const CakeListView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListenableBuilder(
        listenable: CakeService(),
        builder: (context, child) => _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.appTitle,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: AppLocalizations.of(context)!.settings,
          onPressed: () => Navigator.restorablePushNamed(
            context,
            SettingsView.routeName,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final cakeService = CakeService();

    // Initialize data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cakeService.cakes.isEmpty &&
          !cakeService.isLoading &&
          !cakeService.hasError) {
        cakeService.fetchCakes();
      }
    });

    if (cakeService.isLoading && cakeService.cakes.isEmpty) {
      return _buildLoadingState();
    }

    if (cakeService.hasError && cakeService.cakes.isEmpty) {
      return _buildErrorState(context, cakeService);
    }

    if (cakeService.isEmpty) {
      return _buildEmptyState(context, cakeService);
    }

    return _buildCakeList(context, cakeService);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Builder(
            builder: (context) => Text(
              AppLocalizations.of(context)!.loadingCakes,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CakeService cakeService) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              cakeService.errorMessage ??
                  AppLocalizations.of(context)!.unknownError,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => cakeService.fetchCakes(),
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CakeService cakeService) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cake_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noCakesFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.pullToRefresh,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => cakeService.fetchCakes(),
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCakeList(BuildContext context, CakeService cakeService) {
    return RefreshIndicator(
      onRefresh: cakeService.refreshCakes,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: cakeService.cakes.length,
        itemBuilder: (context, index) => _buildCakeItem(
          context,
          cakeService.cakes[index],
        ),
      ),
    );
  }

  Widget _buildCakeItem(BuildContext context, Cake cake) {
    // Localize default values if they exist
    final localizedTitle = cake.title == 'Unknown Cake'
        ? AppLocalizations.of(context)!.unknownCake
        : cake.title;
    final localizedDescription = cake.description == 'No description available'
        ? AppLocalizations.of(context)!.noDescriptionAvailable
        : cake.description;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: _buildCakeImage(cake),
          title: Text(
            localizedTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              localizedDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _navigateToCakeDetails(context, cake),
        ),
      ),
    );
  }

  Widget _buildCakeImage(Cake cake) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cake.hasValidImage
            ? Image.network(
                cake.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.cake,
        color: Colors.grey[500],
        size: 24,
      ),
    );
  }

  void _navigateToCakeDetails(BuildContext context, Cake cake) {
    Navigator.restorablePushNamed(
      context,
      CakeDetailsView.routeName,
      arguments: cake.toJson(),
    );
  }
}
