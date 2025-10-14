import 'package:fitness_app/core/localization/app_strings.dart';
import 'failures.dart';

String mapFailureToMessage(Failure failure) {
  return switch (failure) {
    ServerFailure() => AppStringsEn.serverFailure,
    CacheFailure() => AppStringsEn.cacheFailure,
    LoginFailure() => AppStringsEn.loginFailure,
    DomainRestrictionFailure() => AppStringsEn.domainRestriction,
    InvalidInputFailure() => AppStringsEn.invalidInputFailure,
    _ => AppStringsEn.error,
  };
}
