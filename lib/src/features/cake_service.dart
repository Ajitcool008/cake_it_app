import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cake_it_app/src/features/cake.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CakeService with ChangeNotifier {
  static final CakeService _instance = CakeService._internal();
  factory CakeService() => _instance;
  CakeService._internal();

  static const String _baseUrl =
      "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList";

  List<Cake> _cakes = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Cake> get cakes => List.unmodifiable(_cakes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _cakes.isEmpty && !_isLoading && !hasError;

  /// Fetches cakes from the API with comprehensive error handling
  Future<void> fetchCakes({bool isRefresh = false}) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Accept': 'application/json',
          'Cache-Control': isRefresh ? 'no-cache' : 'max-age=300',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException(
            'Request timed out', const Duration(seconds: 15)),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);

        if (decodedResponse.isEmpty) {
          throw const FormatException('No cakes found in response');
        }

        final List<Cake> fetchedCakes = decodedResponse
            .where((item) => item is Map<String, dynamic>)
            .map((cakeJson) => Cake.fromJson(cakeJson as Map<String, dynamic>))
            .where((cake) => cake.title.isNotEmpty)
            .toList();

        _setCakes(fetchedCakes);
      } else {
        throw HttpException(
          'Failed to load cakes: ${response.statusCode} ${response.reasonPhrase}',
          uri: Uri.parse(_baseUrl),
        );
      }
    } on SocketException {
      _setError(
          'No internet connection. Please check your network and try again.');
    } on TimeoutException {
      _setError('Request timed out. Please try again.');
    } on FormatException catch (e) {
      _setError('Invalid data format: ${e.message}');
    } on HttpException catch (e) {
      _setError('Network error: ${e.message}');
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      debugPrint('CakeService error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Private methods for state management
  void _setCakes(List<Cake> cakes) {
    _cakes = cakes;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Clears all data (useful for logout scenarios)
  void clear() {
    _cakes.clear();
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
