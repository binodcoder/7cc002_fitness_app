// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fitness_app/features/home/presentation/home_scaffold/cubit/home_scaffold_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBadgeIcon extends StatelessWidget {
  const ChatBadgeIcon({
    Key? key,
    required this.selected,
  }) : super(key: key);
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final baseIcon = Icon(
      selected ? Icons.chat_bubble : Icons.chat_bubble_outline,
    );

    return BlocBuilder<HomeScaffoldCubit, int>(
      builder: (context, unreadCount) {
        if (unreadCount == 0) return baseIcon;
        return Badge(
          label: Text(unreadCount.toString()),
          child: baseIcon,
        );
      },
    );
  }
}
