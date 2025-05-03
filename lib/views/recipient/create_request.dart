import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _category = 'Food';
  String _urgency = 'Medium';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Request Title',
                  hintText: 'e.g., Food Supplies for Family',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Medical', child: Text('Medical')),
                  DropdownMenuItem(value: 'Shelter', child: Text('Shelter')),
                  DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                  DropdownMenuItem(
                    value: 'Education',
                    child: Text('Education'),
                  ),
                ],
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _urgency,
                decoration: const InputDecoration(labelText: 'Urgency Level'),
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (value) => setState(() => _urgency = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., Beirut, Lebanon',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Detailed Description',
                  hintText: 'Explain what you need and why',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            Future.delayed(const Duration(seconds: 2)).then((
                              _,
                            ) {
                              setState(() => _isLoading = false);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Request submitted successfully!',
                                  ),
                                ),
                              );
                            });
                          }
                        },
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
