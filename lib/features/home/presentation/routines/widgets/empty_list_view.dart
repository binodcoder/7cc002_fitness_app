import 'package:flutter/material.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 200),
        Center(child: Text('No routines available')),
      ],
    );
  }
}
