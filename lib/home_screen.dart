import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form_dyn/widgets/radio_button.dart';
import 'package:http/http.dart' as http;

import 'widgets/body.dart';
import 'widgets/checklist.dart';
import 'widgets/pick_date.dart';
import 'widgets/pick_file.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIOS = false;

  String apiUrl = 'https://dyn-form-server.onrender.com/api/form';

  final formKey = GlobalKey<FormState>();

  String selectedValue = '1';

  // Replace with your Node.js server URL
  Future<Map<String, dynamic>> fetchFormFields() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load form fields');
    }
  }

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchFormFields(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            List<dynamic> formFields = snapshot.data!['stepfields'];

            // Function to build form fields dynamically
            List<Widget> buildFormFields() {
              List<Widget> widgets = [];

              for (var field in formFields) {
                // Processing each field based on its type and other specifications
                bool isValid = field['fldreqd'] == '1' ? true : false;
                String lbl = field['fldlabel'] + (isValid ? '*' : '');

                switch (field['fldtype']) {
                  case '1':
                    widgets.add(
                      TextFormField(
                        decoration: InputDecoration(labelText: lbl),
                        validator: (value) {
                          return validatorFn(value, isValid);
                        },
                      ),
                    );
                    break;
                  case '2': //textarea
                    widgets.add(
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(labelText: lbl),
                      ),
                    );
                    break;
                  case '3': //checkbox
                    widgets.addAll([
                      const SizedBox(height: 16),
                      Text(lbl),
                    ]);
                    List<Widget> checkboxes = [];
                    for (var option in field['fldoptions']) {
                      checkboxes.add(CheckBoxWidget(
                          labelText: option['optname'],
                          isValid: isValid,
                          validatorFn: validatorFn));
                    }
                    widgets.addAll(checkboxes);
                    break;
                  case '4': //radio
                    widgets.addAll([
                      const SizedBox(height: 16),
                      Text(lbl),
                    ]);
                    widgets.add(RadioButton(options: field['fldoptions']));
                    break;
                  case '5': // select box
                    List<DropdownMenuItem<String>> dropdownItems = [];
                    for (var option in field['fldoptions']) {
                      dropdownItems.add(
                        DropdownMenuItem<String>(
                          value: option['optval'],
                          child: Text(option['optname']),
                        ),
                      );
                    }
                    widgets.add(
                      DropdownButtonFormField<String>(
                        items: dropdownItems,
                        onChanged: (String? value) {
                          // Handle dropdown value change
                        },
                        decoration:
                            InputDecoration(labelText: field['fldlabel']),
                        validator: (value) {
                          if (field['fldreqd'] == '1' &&
                              (value == null || value.isEmpty)) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                    );
                    break;
                  case '6': // file upload
                    widgets.addAll([
                      const SizedBox(height: 16),
                      Text(lbl),
                      const SizedBox(height: 16),
                      const PickFileWidget(),
                    ]);
                    break;
                  case '7': //date field
                    widgets.add(DatePickWidget(
                        lbl: lbl,
                        isValid: isValid,
                        selectedDate: _selectedDate));
                    break;
                  case '8': //number field
                    widgets.addAll([
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: field['fldlabel']),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (field['fldreqd'] == '1' &&
                              (value == null || value.isEmpty)) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ]);
                    break;
                  default:
                    throw Exception('Incorrect field type returned by API');
                }
              }

              return widgets;
            }

            return Body(formKey: formKey, selectedDate: _selectedDate, buildFormFields: buildFormFields,);
          }
        },
      ),
    );
  }

  validatorFn(value, isValid) {
    if (isValid) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

