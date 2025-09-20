import '../../layers/presentation/localization/app_strings.dart';
import '../errors/failures.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return AppStringsEn.serverFailure;
    case CacheFailure:
      return AppStringsEn.cacheFailure;
    case LoginFailure:
      return AppStringsEn.loginFailure;
    default:
      return 'Unexpected error';
  }
}
