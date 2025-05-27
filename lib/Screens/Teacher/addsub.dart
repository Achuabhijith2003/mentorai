import 'package:flutter/material.dart';
import 'package:mentorai/Screens/components/buttons.dart';

class AddSubjectPage extends StatelessWidget {
  const AddSubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show the bottom sheet as soon as this page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        builder:
            (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Add Subject",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TextField from components (replace with your custom widget if needed)
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Subject Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Syllabus upload section
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement syllabus file picker
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Syllabus'),
                    ),
                    const SizedBox(height: 10),
                    // Sample note upload section
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement sample note file picker
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Sample Note'),
                    ),
                    const SizedBox(height: 20),
                    // Submit button
                    PrimaryButton(onTap: () {}, text: "Add Subject"),
                  ],
                ),
              ),
            ),
      );
    });

    // Return an empty Scaffold or Container since the bottom sheet is the focus
    Navigator.of(context).pop();
    return SizedBox.shrink();
  }
}
