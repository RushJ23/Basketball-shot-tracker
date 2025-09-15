import 'package:basketball_app/models/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// Widget to create a customizable share message with selectable placeholders
class ShareMessage extends StatefulWidget {
  @override
  State<ShareMessage> createState() => _ShareMessageState();
}

class _ShareMessageState extends State<ShareMessage> {
  final TextEditingController _textController = TextEditingController();

  // Function to insert a placeholder text at the current cursor position
  void _addText(String text) {
    final textValue = _textController.text;
    final cursorPosition = _textController.selection.baseOffset;

    // Check if no cursor position is set, append to the end of the text
    if (cursorPosition < 0) {
      _textController.text += "{$text} ";
    } else {
      // Insert placeholder text at the current cursor position
      final newText =
          "${textValue.substring(0, cursorPosition)}{$text} ${textValue.substring(cursorPosition)}";
      _textController.text = newText;

      // Move cursor position to after the inserted text
      _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPosition + text.length + 3));
    }
    // Update the share message in SettingsProvider
    context.read<SettingsProvider>().updateShareMessage(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    // Set the initial text from the current share message setting
    _textController.text = context.read<SettingsProvider>().shareMessage;

    return Row(
      children: [
        // Input field to edit the share message
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                // Update the share message when user types
                context.read<SettingsProvider>().updateShareMessage(value);
              },
              maxLines: 5,
              minLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input Text',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        // List of placeholder buttons for user to insert into the message
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            height: 120,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // List of placeholders for easy insertion
                  'Accuracy',
                  'Shots',
                  'Made',
                  'Mean_release_height',
                  'Mean_release_time',
                  'Mean_shot_depth',
                  'Mean_shot_position',
                  'Mean_entry_angle',
                  'Quartile_release_height',
                  'Quartile_release_time',
                  'Quartile_shot_depth',
                  'Quartile_shot_position',
                  'Quartile_entry_angle',
                  'Total_workouts',
                ]
                    .map((text) => TextButton(
                          onPressed: () => _addText(text),  // Insert placeholder text on button press
                          style: TextButton.styleFrom(
                            shape: const LinearBorder(
                              bottom: LinearBorderEdge(),
                              top: LinearBorderEdge(),
                            ),
                            minimumSize: const Size.fromHeight(30),
                            padding: EdgeInsets.all(0),
                          ),
                          child: Text(text),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
