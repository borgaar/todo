import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetInputDialog extends StatelessWidget {
  GetInputDialog({super.key, required this.title, initialInput = ''}) {
    _textController = TextEditingController(text: initialInput);
  }

  final String title;
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: _textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'List Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: (value) => context.pop(value.trim()),
      ),
      actions: [
        TextButton(onPressed: context.pop, child: const Text('Cancel')),
        FilledButton(
          onPressed: () => context.pop(_textController.text.trim()),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
