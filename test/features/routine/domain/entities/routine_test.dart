import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';

void main() {
  const a = Routine(
    id: 1,
    name: 'n',
    description: 'd',
    duration: 10,
    source: 's',
  );
  const b = Routine(
    id: 1,
    name: 'n',
    description: 'd',
    duration: 10,
    source: 's',
  );
  const c = Routine(
    id: 2,
    name: 'n',
    description: 'd',
    duration: 10,
    source: 's',
  );

  test('equatable equals for same values', () {
    expect(a, equals(b));
  });

  test('equatable not equals for different id', () {
    expect(a == c, isFalse);
  });
}
