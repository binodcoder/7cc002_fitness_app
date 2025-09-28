import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => const [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  const ResetPasswordSubmitted(this.email);

  @override
  List<Object?> get props => [email];
}

