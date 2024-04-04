import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Model());
}

// The Model class is the main app widget for the Sales Prediction app
class Model extends StatefulWidget {
  const Model({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       debugShowCheckedModeBanner: false, // Hide the debug banner
      home:
          const PredictionScreen(), // PredictionScreen is the main screen of the app
    );
  }
  
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => throw UnimplementedError();
}

// PredictionScreen is a StatefulWidget that handles the UI and logic for predicting sales
class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _tvController =
      TextEditingController(); // Controller to manage the TV marketing expenses input field
  double? _prediction; // Variable to store the predicted sales value

  // Method to make a POST request to the FastAPI endpoint and get the predicted sales value
  Future<void> _predictSales() async {
    final tv = double.tryParse(_tvController.text);
    if (tv == null || tv <= 0 || tv >= 300) {
      // Handle invalid TV value
      return;
    }

    final response = await http.post(
      Uri.parse('http://your-api-url/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tv': tv}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _prediction = jsonResponse['Sales prediction'];
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Prediction'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _tvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'TV Marketing Expenses',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed:
                          _predictSales, // Button to trigger the prediction
                      child: const Text('Predict Sales'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            if (_prediction != null)
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Predicted Sales:', // Label for the predicted sales value
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '\$${_prediction!.toStringAsFixed(2)}', // Display the predicted sales value
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tvController
        .dispose(); // Dispose the TextEditingController when the widget is removed from the widget tree
    super.dispose();
  }
}
