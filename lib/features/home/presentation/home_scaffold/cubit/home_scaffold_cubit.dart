import 'dart:async';

import 'package:fitness_app/core/services/session_manager.dart';
import 'package:fitness_app/features/home/domain/usecases/get_unread_count.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScaffoldCubit extends Cubit<int> {
  final GetUnreadCount getUnreadCount;
  final SessionManager sessionManager;
  StreamSubscription<int>? _subscription;

  HomeScaffoldCubit({
    required this.getUnreadCount,
    required this.sessionManager,
  }) : super(0);

  void startListening() {
    final userId = sessionManager.getCurrentUser()?.id;
    if (userId == null) return;

    _subscription = getUnreadCount(userId).listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
