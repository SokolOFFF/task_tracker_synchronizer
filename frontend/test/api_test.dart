import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/api.dart';

void main() {
  final api = Api();
  test('Check getRules', () async {
    final rules = await api.getRules().run();
  });
}
