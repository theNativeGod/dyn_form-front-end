import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({
    required this.labelText,
    required this.isValid,
    required this.validatorFn,
    super.key,
  });

  final labelText;
  final isValid;
  final validatorFn;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.labelText),
      value: isChecked,
      onChanged: (bool? value) {
        // Update the 'isChecked' variable when the checkbox is toggled
        if (value != null) {
          isChecked = value;
          setState(() {});
        }
      },
      controlAffinity:
          ListTileControlAffinity.leading, // To place the checkbox on the left
    );
  }
}
