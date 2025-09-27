import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/localization/app_strings.dart';

class UnknownFailure extends Failure {
  @override
  List<Object?> get props => [];
}

void main() {
  test('maps ServerFailure to serverFailure message', () {
    expect(mapFailureToMessage(ServerFailure()), AppStringsEn.serverFailure);
  });

  test('maps CacheFailure to cacheFailure message', () {
    expect(mapFailureToMessage(CacheFailure()), AppStringsEn.cacheFailure);
  });

  test('maps LoginFailure to loginFailure message', () {
    expect(mapFailureToMessage(LoginFailure()), AppStringsEn.loginFailure);
  });

  test('maps InvalidInputFailure to invalidInputFailure message', () {
    expect(mapFailureToMessage(InvalidInputFailure()),
        AppStringsEn.invalidInputFailure);
  });

  test('maps unknown Failure to generic error message', () {
    expect(mapFailureToMessage(UnknownFailure()), AppStringsEn.error);
  });
}
