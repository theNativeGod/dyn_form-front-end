import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  const RadioButton({required this.options, super.key});
  final options;
  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String selectedValue = '0';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.options.map((option) {
          return RadioListTile(
            title: Text(option['optname']),
            value: option['optval'],
            groupValue: selectedValue, // Set groupValue based on your logic
            onChanged: (dynamic value) {
              selectedValue = value;
              setState(() {});
            },
          );
        }).toList()
      ],
    );
  }
}
