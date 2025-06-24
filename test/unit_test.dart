// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:cake_it_app/src/features/cake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cake should be created from valid JSON', () {
    // Arrange
    final json = {
      'title': 'Chocolate Cake',
      'desc': 'Delicious chocolate cake with ganache',
      'image': 'https://example.com/chocolate.jpg'
    };

    // Act
    final cake = Cake.fromJson(json);

    // Assert
    expect(cake.title, equals('Chocolate Cake'));
    expect(cake.description, equals('Delicious chocolate cake with ganache'));
    expect(cake.image, equals('https://example.com/chocolate.jpg'));
  });
}
