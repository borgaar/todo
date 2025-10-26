import 'package:flutter/material.dart';

class NewItemTextField extends StatelessWidget {
  NewItemTextField({
    super.key,
    required void Function(String value) onSubmitted,
  }) : _onSubmitted = onSubmitted;

  final FocusNode _focusNode = FocusNode();
  final _textController = TextEditingController();
  final void Function(String value) _onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: 'Add new item',
        hintText: 'Enter item description...',
        prefixIcon: const Icon(Icons.add_circle_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          _onSubmitted(value.trim());
          _textController.clear();
          _focusNode.requestFocus();
        }
      },
      controller: _textController,
    );
  }
}
