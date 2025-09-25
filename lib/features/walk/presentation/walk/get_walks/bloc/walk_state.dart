import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkState extends Equatable {
  const WalkState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class WalkActionState extends WalkState {
  const WalkActionState();
}

class WalkInitialState extends WalkState {
  const WalkInitialState();
}

class WalkLoadingState extends WalkState {
  const WalkLoadingState();
}

class WalkLoadedSuccessState extends WalkState {
  final List<Walk> walks;
  const WalkLoadedSuccessState({required this.walks});
  WalkLoadedSuccessState copyWith({List<Walk>? walks}) {
    return WalkLoadedSuccessState(walks: walks ?? this.walks);
  }

  @override
  List<Object?> get props => [walks];
}

class WalkErrorState extends WalkState {
  final String message;
  const WalkErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class WalkShowErrorActionState extends WalkActionState {
  final String message;
  const WalkShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class WalkNavigateToAddWalkActionState extends WalkActionState {
  const WalkNavigateToAddWalkActionState();
}

class WalkNavigateToDetailPageActionState extends WalkActionState {
  final Walk walk;

  const WalkNavigateToDetailPageActionState({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkNavigateToUpdatePageActionState extends WalkActionState {
  final Walk walk;

  const WalkNavigateToUpdatePageActionState({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkItemDeletedActionState extends WalkActionState {
  const WalkItemDeletedActionState();
}

class WalkItemSelectedActionState extends WalkActionState {
  const WalkItemSelectedActionState();
}

class WalkItemsDeletedActionState extends WalkActionState {
  const WalkItemsDeletedActionState();
}

class WalkJoinedActionState extends WalkActionState {
  const WalkJoinedActionState();
}

class WalkLeftActionState extends WalkActionState {
  const WalkLeftActionState();
}
