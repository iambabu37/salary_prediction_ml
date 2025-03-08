import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalaryPredictionPage extends StatefulWidget {
  const SalaryPredictionPage({Key? key}) : super(key: key);

  @override
  _SalaryPredictionPageState createState() => _SalaryPredictionPageState();
}

class _SalaryPredictionPageState extends State<SalaryPredictionPage> {
  // Controllers for text fields
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _customYearsExperienceController =
      TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  // Selected values for dropdowns
  String _payPeriod = 'monthly';
  String _educationLevel = 'Bachelor\'s Degree';
  String? _yearsExperience;

  String? _predictedSalary;

  Future<void> _predictSalary() async {
    final url = 'http://127.0.0.1:8000/api/predict/'; // Update with server URL
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    int yearsOfExperience = 0; // Default value
    if (_yearsExperience == 'custom') {
      yearsOfExperience = int.tryParse(_customYearsExperienceController.text) ??
          0; // Use custom input
    } else if (_yearsExperience != null) {
      yearsOfExperience =
          _parseYearsExperience(_yearsExperience!); // Parse the string
    }

    final body = jsonEncode(<String, dynamic>{
      'max_salary': int.tryParse(_maxSalaryController.text) ?? 0,
      'min_salary': int.tryParse(_minSalaryController.text) ?? 0,
      'pay_period': _payPeriod,
      'location': _locationController.text,
      'years_experience': yearsOfExperience,
      'job_title': _jobTitleController.text,
      'education_level': _educationLevel,
    });

    print('Sending POST request to: $url');
    print('Request headers: $headers');
    print('Request body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        _predictedSalary =
            json.decode(response.body)['predicted_salary'].toString();
        print(_predictedSalary);
      });
    } else {
      print('Failed to predict salary');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to predict salary. Status code: ${response.statusCode}')),
      );
      throw Exception('Failed to predict salary');
    }
  }

  // Helper function to parse years of experience
  int _parseYearsExperience(String value) {
    if (value.contains('+')) {
      return int.parse(value.replaceAll('+', ''));
    }
    return int.parse(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Prediction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row for Max and Min Salary Inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0), // Space between columns
                    child: TextField(
                      controller: _maxSalaryController,
                      decoration: const InputDecoration(
                          labelText: 'Max Expected Salary'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Space between columns
                    child: TextField(
                      controller: _minSalaryController,
                      decoration: const InputDecoration(
                          labelText: 'Min Expected Salary'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), // Space between rows

            // Location Input
            TextField(
              controller: _locationController,
              decoration:
                  const InputDecoration(labelText: 'Location (City, State)'),
            ),

            const SizedBox(height: 16), // Space between rows

            // Years of Experience Dropdown
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Years of Experience'),
              value: _yearsExperience,
              items: <String>[
                '1',
                '2',
                '3',
                '5+',
                '10+',
                '15+',
                '20+',
                'custom'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _yearsExperience = newValue;
                });
              },
            ),

            // Custom Years of Experience Input
            if (_yearsExperience == 'custom')
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0), // Space above custom input
                child: TextField(
                  controller: _customYearsExperienceController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Years of Experience'),
                  keyboardType: TextInputType.number,
                ),
              ),

            const SizedBox(height: 16), // Space between rows

            // Job Title Input
            TextField(
              controller: _jobTitleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
            ),

            const SizedBox(height: 16), // Space between rows

            // Pay Period Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Pay Period'),
              value: _payPeriod,
              items: <String>['monthly', 'yearly', 'hourly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _payPeriod = newValue!;
                });
              },
            ),

            const SizedBox(height: 16), // Space between rows

            // Education Level Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Education Level'),
              value: _educationLevel,
              items: <String>[
                'High School Diploma',
                'Associate\'s Degree',
                'Bachelor\'s Degree',
                'Master\'s Degree',
                'PhD'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _educationLevel = newValue!;
                });
              },
            ),

            const SizedBox(height: 16), // Space between rows

            // Predict Salary Button
            ElevatedButton(
              onPressed: _predictSalary,
              child: const Text('Predict Salary'),
            ),

            // Predicted Salary Output
            if (_predictedSalary != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Predicted Salary:',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
