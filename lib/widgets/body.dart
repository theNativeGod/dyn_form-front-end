import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.formKey,
    required DateTime? selectedDate,
    required this.buildFormFields,
  }) : _selectedDate = selectedDate;

  final GlobalKey<FormState> formKey;
  final DateTime? _selectedDate;
  final buildFormFields;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Generate form fields dynamically
              ...buildFormFields(),

              // Example submit button
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate() &&
                      _selectedDate != null) {
                    formKey.currentState?.reset();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
