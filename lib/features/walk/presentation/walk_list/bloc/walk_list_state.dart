import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkListState extends Equatable {
  const WalkListState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class WalkListActionState extends WalkListState {
  const WalkListActionState();
}

class WalkListInitial extends WalkListState {
  const WalkListInitial();
}

class WalkListLoading extends WalkListState {
  const WalkListLoading();
}

class WalkListLoaded extends WalkListState {
  final List<Walk> walks;
  const WalkListLoaded({required this.walks});
  WalkListLoaded copyWith({List<Walk>? walks}) {
    return WalkListLoaded(walks: walks ?? this.walks);
  }

  @override
  List<Object?> get props => [walks];
}

class WalkListError extends WalkListState {
  final String message;
  const WalkListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WalkListShowErrorActionState extends WalkListActionState {
  final String message;
  const WalkListShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}


class WalkNavigateToDetailsActionState extends WalkListActionState {
  final Walk walk;

  const WalkNavigateToDetailsActionState({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkNavigateToEditActionState extends WalkListActionState {
  final Walk walk;

  const WalkNavigateToEditActionState({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkItemDeletedActionState extends WalkListActionState {
  const WalkItemDeletedActionState();
}

class WalkItemSelectedActionState extends WalkListActionState {
  const WalkItemSelectedActionState();
}

class WalkItemsDeletedActionState extends WalkListActionState {
  const WalkItemsDeletedActionState();
}

class WalkJoinedActionState extends WalkListActionState {
  const WalkJoinedActionState();
}

class WalkLeftActionState extends WalkListActionState {
  const WalkLeftActionState();
}
