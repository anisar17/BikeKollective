import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Bike model
class Bike {
  final String name;
  final String type;
  final String description;
  final String code;

  Bike({
    required this.name,
    required this.type,
    required this.description,
    required this.code,
  });
}

// State management class using ChangeNotifier
class BikeNotifier extends ChangeNotifier {
  String? _name;
  String? _type;
  String? _description;
  String? _code;

  List<String> bikeTypes = ['Road Bike', 'Mountain Bike', 'E-bike'];

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setLockCode(String lockCode) {
    _code = lockCode;
    notifyListeners();
  }

  Bike? get bike {
    if (_name != null && _type != null && _description != null && _code != null) {
      return Bike(name: _name!, type: _type!, description: _description!, code: _code!);
    }
    return null;
  }

  void clear() {
    _name = null;
    _type = null;
    _description = null;
    _code = null;
    notifyListeners();
  }
}

final bikeProvider = ChangeNotifierProvider<BikeNotifier>((ref) {
  return BikeNotifier();
});

class AddBikeScreen extends ConsumerWidget {
  const AddBikeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(bikeProvider);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Name Field
              _buildLabeledTextField(
                label: 'Name',
                hint: 'Enter your bike name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) notifier.setName(value);
                },
              ),
              SizedBox(height: 16.0), // Spacing between fields

              // Type Field
              _buildLabeledDropdownField(
                label: 'Type',
                hint: 'Select bike type',
                value: notifier._type,
                items: notifier.bikeTypes,
                onChanged: (value) {
                  if (value != null) {
                    notifier.setType(value);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a bike type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Spacing between fields

              // Description Field
              _buildLabeledTextField(
                label: 'Description',
                hint: 'Enter bike description',
                minLines: 6,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) notifier.setDescription(value);
                },
              ),
              SizedBox(height: 16.0), // Spacing between fields

              // Lock Code Field
              _buildLabeledTextField(
                label: 'Lock Code',
                hint: 'Enter lock code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a lock code';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) notifier.setLockCode(value);
                },
              ),
              SizedBox(height: 16.0), // Add some spacing

              // Centered Upload Image Button
// Centered Upload Image Button
Center(
  child: ElevatedButton(
    onPressed: () async {
      // Logic to upload image goes here
      print('Upload Image Button Pressed');
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey, // Set to grey
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Increase padding for larger button
      textStyle: TextStyle(fontSize: 20), // Increase font size
    ),
    child: Text('Upload Image'), // Button Label
  ),
),
SizedBox(height: 20), // Add some spacing between the Upload Image button and the next buttons

// Row for Cancel and Add Bike buttons next to each other
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly within the Row
  children: [
    // Cancel Button - Navigates back to previous screen
    ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Go back to the previous screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding as needed
      ),
      child: Text('Cancel'), // Button Label
    ),
    // Add Bike Button
    ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // Save bike to Firestore
          final bike = notifier.bike;
          if (bike != null) {
            final bikeData = {
              'name': bike.name,
              'type': bike.type,
              'description': bike.description,
              'lockCode': bike.code,
            };
            await FirebaseFirestore.instance
                .collection('bikes')
                .add(bikeData);

            notifier.clear(); // Clear the fields after submission

            // Show a confirmation dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Bike Added'),
                  content: Text(
                      'Bike Name: ${bike.name}\nType: ${bike.type}\nDescription: ${bike.description}\nLock Code: ${bike.code}'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding as needed
      ),
      child: Text('Add Bike'), // Button Label
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }  

  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    int? minLines,
    int? maxLines,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns label to the left
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildLabeledDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns label to the left
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          items: items.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}