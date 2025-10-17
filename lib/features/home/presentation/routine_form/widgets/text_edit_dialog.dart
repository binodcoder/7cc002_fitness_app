import 'package:fitness_app/core/theme/tokens/layout_tokens.dart';
import 'package:flutter/material.dart';

class TextEditDialogPage extends StatefulWidget {
  final String title;
  final String initial;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  const TextEditDialogPage({
    super.key,
    required this.title,
    required this.initial,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<TextEditDialogPage> createState() => _TextEditDialogPageState();
}

class _TextEditDialogPageState extends State<TextEditDialogPage> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);
  String? _error;

  void _save() {
    final err = widget.validator?.call(_ctrl.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    Navigator.of(context).pop(_ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final fc = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(foregroundColor: fc),
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        title: Text(widget.title),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppWidth.w30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ctrl,
                keyboardType: widget.keyboardType,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: widget.title,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  errorText: _error,
                ),
                onSubmitted: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
