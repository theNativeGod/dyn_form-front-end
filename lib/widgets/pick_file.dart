import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickFileWidget extends StatefulWidget {
  const PickFileWidget({
    super.key,
  });

  @override
  State<PickFileWidget> createState() => _PickFileWidgetState();
}

class _PickFileWidgetState extends State<PickFileWidget> {
  String? _filePath;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path;
        });
      }
    } catch (e) {
      // Handle file picking errors
      throw Exception('File picking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Pick a file'),
        ),
        const SizedBox(height: 20),
        if (_filePath != null) Text('Selected file: ${_filePath}'),
      ],
    );
  }
}
