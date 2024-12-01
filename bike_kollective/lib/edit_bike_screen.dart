import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:image_picker/image_picker.dart';

class BikeNotifier extends ChangeNotifier {
  late TextEditingController nameController;
  late TextEditingController descriptionController; // Add separate controller
  late TextEditingController lockCodeController; // Add separate controller
  BikeType? _type;
  Uint8List? _image; // Change this to the notifier to retain state

  BikeNotifier() {
    nameController = TextEditingController();
    descriptionController = TextEditingController(); // Initialize the description controller
    lockCodeController = TextEditingController(); // Initialize the lock code controller
  }

  void setType(BikeType type) {
    _type = type;
    notifyListeners();
  }

  void setDescription(String description) {
    descriptionController.text = description; // Update the description controller
    notifyListeners();
  }

  void setLockCode(String lockCode) {
    lockCodeController.text = lockCode; // Update the lock code controller
    notifyListeners();
  }

  void setImage(Uint8List image) {
    _image = image; // Set selected image
    notifyListeners(); // Notify listeners to update UI
  }

  BikeModel? get bike {
    if (nameController.text.isNotEmpty && _type != null && descriptionController.text.isNotEmpty && lockCodeController.text.isNotEmpty) {
      // Return a bike model with the data from the form, dummy data will be replaced later
      return BikeModel.newBike(
        owner: BKDocumentReference.fake(""),
        name: nameController.text,
        type: _type!,
        description: descriptionController.text,
        code: lockCodeController.text,
        imageUrl: '',
        startingPoint: const BKGeoPoint(0, 0),
      );
    }
    return null;
  }

  set bike(BikeModel? b) {
    if(b == null) {
      clear();
    } else {
      // Set everything based on the given model
      nameController.text = b.name;
      descriptionController.text = b.description;
      lockCodeController.text = b.code;
      _type = b.type;
      _image = null;
      notifyListeners();
    }
  }

  Uint8List? get image => _image; // Getter for the image

  void clear() {
    nameController.clear();
    descriptionController.clear(); // Clear the description field
    lockCodeController.clear(); // Clear the lock code field
    _type = null;
    _image = null; // Reset the image
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose(); // Dispose the description controller
    lockCodeController.dispose(); // Dispose the lock code controller
    super.dispose();
  }
}

final bikeProvider = ChangeNotifierProvider<BikeNotifier>((ref) {
  return BikeNotifier();
});

// Screen for adding a new bike or editing an existing bike
class EditBikeScreen extends ConsumerStatefulWidget {
  // The pre-existing bike data, null if this is a new bike
  final BikeModel? oldBike;

  const EditBikeScreen({super.key, this.oldBike});

  @override
  EditBikeScreenState createState() => EditBikeScreenState();
}

class EditBikeScreenState extends ConsumerState<EditBikeScreen> {
  @override
  void initState() {
    super.initState();
    if(widget.oldBike != null) {
      // If we are editing an existing bike, initialize the fields
      // to show the old bike's details
      Future.microtask(() {
        ref.read(bikeProvider).bike = widget.oldBike!;
      });
    }
  }

  bool _isNew() {
    // True if adding a new bike, False if editing an existing bike
    return (widget.oldBike == null);
  }

  @override
  Widget build(BuildContext context) {
    final bikeNotifier = ref.watch(bikeProvider);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: _isNew() ? const Text('Add Bike') : const Text('Edit Bike')),
      body: SingleChildScrollView(
        child: Padding(
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
                  controller: bikeNotifier.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Type Field
                _buildLabeledDropdownField(
                  label: 'Type',
                  hint: 'Select bike type',
                  value: bikeNotifier._type?.toString().split('.').last,
                  items: BikeType.values.map((e) => e.toString().split('.').last).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      bikeNotifier.setType(BikeType.values.firstWhere((e) => e.toString().split('.').last == value));
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bike type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Description Field
                _buildLabeledTextField(
                  label: 'Description',
                  hint: 'Enter bike description',
                  minLines: 6,
                  maxLines: 6,
                  controller: bikeNotifier.descriptionController, // Use the description controller
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Lock Code Field
                _buildLabeledTextField(
                  label: 'Lock Code',
                  hint: 'Enter lock code',
                  controller: bikeNotifier.lockCodeController, // Use the lock code controller
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a lock code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Image Preview Box
                Center(
                  child: Container(
                    width: 80, 
                    height: 80, 
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey), 
                    ),
                    child: bikeNotifier.image == null
                        ? const Center(child: Text('No image selected.'))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              bikeNotifier.image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Upload Image Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Uint8List? image = await pickImage();
                      if (image != null) {
                        bikeNotifier.setImage(image); 
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Upload Image'),
                  ),
                ),
                const SizedBox(height: 20),

                // Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final bike = bikeNotifier.bike;
                          final image = bikeNotifier.image;
                          // Require new bikes to have images
                          if (bike != null && (image != null || !_isNew())) {
                            if(_isNew()) {
                              await ref.read(ownedBikesProvider.notifier).addBike(
                                name: bike.name,
                                type: bike.type,
                                description: bike.description,
                                code: bike.code,
                                image: image!,
                              );
                            } else {
                              await ref.read(ownedBikesProvider.notifier).updateBikeDetails(
                                widget.oldBike!,
                                newName: bike.name,
                                newType: bike.type,
                                newDescription: bike.description,
                                newCode: bike.code,
                                newImage: image,
                              );
                            }

                            bikeNotifier.clear(); // Clear after success

                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:  _isNew() ? const Text('Bike Added') : const Text('Bike Updated'),
                                content: Text(
                                  'Bike Name: ${bike.name}\nType: ${bike.type.toString().split('.').last}\nDescription: ${bike.description}\nLock Code: ${bike.code}',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      // Navigate back to home screen
                                      Navigator.pushReplacementNamed(context, '/home');
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isNew() ? const Text('Add Bike') : const Text('Update Bike'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.readAsBytes();
    }
    return null; // Return null if no image is picked
  }

  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    int? minLines,
    int? maxLines,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.grey),
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
