import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/layout/window_size.dart';

void main() {
  test('under 600 dp is compact', () {
    expect(WindowSize.fromWidth(0), WindowSize.compact);
    expect(WindowSize.fromWidth(360), WindowSize.compact);
    expect(WindowSize.fromWidth(599.9), WindowSize.compact);
  });

  test('600 to 839 dp is medium', () {
    expect(WindowSize.fromWidth(600), WindowSize.medium);
    expect(WindowSize.fromWidth(839.9), WindowSize.medium);
  });

  test('840 dp or wider is expanded', () {
    expect(WindowSize.fromWidth(840), WindowSize.expanded);
    expect(WindowSize.fromWidth(1280), WindowSize.expanded);
  });
}
