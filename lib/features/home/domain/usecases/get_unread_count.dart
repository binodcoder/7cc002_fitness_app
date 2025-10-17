import 'package:fitness_app/features/home/domain/repositories/home_repositories.dart';

class GetUnreadCount {
  HomeRepository homeRepository;

  GetUnreadCount(this.homeRepository);

  Stream<int> call(int userId) {
    return homeRepository.getUnreadCount(userId);
  }
}
