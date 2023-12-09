import 'package:flutter/material.dart';

class DatePickWidget extends StatefulWidget {
  DatePickWidget({
    super.key,
    required this.lbl,
    required this.isValid,
    required DateTime? selectedDate,
  }) : _selectedDate = selectedDate;

  final String lbl;
  final bool isValid;
  DateTime? _selectedDate;

  @override
  State<DatePickWidget> createState() => _DatePickWidgetState();
}

class _DatePickWidgetState extends State<DatePickWidget> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != widget._selectedDate) {
      setState(() {
        widget._selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('${widget.lbl} ${widget.isValid ? '*' : ''}'),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Select Date'),
          ),
        ),
        const SizedBox(height: 20),
        if (widget._selectedDate != null)
          Center(
            child: Text(
              'Selected Date: ${widget._selectedDate!.toString().substring(0, 10)}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
      ],
    );
  }
}
