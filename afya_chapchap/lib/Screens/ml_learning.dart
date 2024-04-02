import 'package:flutter/material.dart';

class MLLearningPage extends StatefulWidget {
  const MLLearningPage({super.key});

  @override
  _MLLearningPageState createState() => _MLLearningPageState();
}

class _MLLearningPageState extends State<MLLearningPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _featureValues = <String, dynamic>{};
  double? _predictedPrice;
  final _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _currentStep++;
          _focusNodes[_currentStep].requestFocus();
        });
      }
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // Call your machine learning model to predict the price
        // _predictedPrice = predictHousePrice(_featureValues);
        // setState(() {});
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _focusNodes[_currentStep].requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Learning'),
        backgroundColor: Colors.indigo[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'House Price Prediction',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 24.0),
            Stepper(
              currentStep: _currentStep,
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (_currentStep != 0)
                      ElevatedButton(
                        onPressed: _previousStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _currentStep == 4
                            ? const Text('Predict Price')
                            : const Text('Next'),
                      ),
                    ),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('Area'),
                  content: TextFormField(
                    focusNode: _focusNodes[0],
                    decoration: const InputDecoration(
                      labelText: 'Area (sq. ft.)',
                      prefixIcon: Icon(Icons.house),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the area';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _featureValues['area'] = double.parse(value!);
                    },
                  ),
                  isActive: _currentStep == 0,
                ),
                Step(
                  title: const Text('Bedrooms'),
                  content: TextFormField(
                    focusNode: _focusNodes[1],
                    decoration: const InputDecoration(
                      labelText: 'Number of Bedrooms',
                      prefixIcon: Icon(Icons.bed),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of bedrooms';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _featureValues['bedrooms'] = int.parse(value!);
                    },
                  ),
                  isActive: _currentStep == 1,
                ),
                Step(
                  title: const Text('Bathrooms'),
                  content: TextFormField(
                    focusNode: _focusNodes[2],
                    decoration: const InputDecoration(
                      labelText: 'Number of Bathrooms',
                      prefixIcon: Icon(Icons.bathtub),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of bathrooms';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _featureValues['bathrooms'] = int.parse(value!);
                    },
                  ),
                  isActive: _currentStep == 2,
                ),
                Step(
                  title: const Text('House Type'),
                  content: DropdownButtonFormField<String>(
                    focusNode: _focusNodes[3],
                    decoration: const InputDecoration(
                      labelText: 'House Type',
                      prefixIcon: Icon(Icons.home),
                    ),
                    items: ['Apartment', 'House', 'Townhouse']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _featureValues['houseType'] = value;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a house type';
                      }
                      return null;
                    },
                  ),
                  isActive: _currentStep == 3,
                ),
                Step(
                  title: const Text('Result'),
                  content: _predictedPrice != null
                      ? Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Predicted Price: \$${_predictedPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      : const Text(
                          'Please enter the required information to predict the house price.'),
                  isActive: _currentStep == 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
