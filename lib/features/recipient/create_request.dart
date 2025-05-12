import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
  final _goalAmountController = TextEditingController();
  String _category = 'Food';
  String _urgency = 'Medium';
  bool _isLoading = false;

  final requestservice = RequestService();
  String _generateConfirmationCode() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijklmnpoqrstuvwxyz1023456789';
    final rand = Random();
    return List.generate(
      10,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

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
              // --- Title
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

              // --- Category
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

              // --- Urgency
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

              // --- Location
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

              // --- Goal Amount
              TextFormField(
                controller: _goalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Goal Amount (\$)',
                  hintText: 'e.g., 500',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal amount';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Description
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

              // --- Submit Button
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            try {
                              await requestservice.ensureRecipientExists();

                              final goal =
                                  double.tryParse(_goalAmountController.text) ??
                                  0.0;

                              final confirmationCode =
                                  _generateConfirmationCode();

                              final newrequest = RequestModel(
                                id: Uuid().v1(),
                                recipientId:
                                    Supabase
                                        .instance
                                        .client
                                        .auth
                                        .currentUser
                                        ?.id ??
                                    '',
                                title: _titleController.text,
                                description: _descriptionController.text,
                                category: _category,
                                urgency: _urgency,
                                location: _locationController.text,
                                date: DateTime.now(),
                                status: 'Pending',
                                donatedAmount: 0,
                                goalAmount: goal,
                                confirmationCode: confirmationCode,
                              );

                              await requestservice.createRequest(newrequest);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Request submitted successfully!',
                                  ),
                                ),
                              );

                              Navigator.pop(context, newrequest);
                            } catch (e) {
                              print(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to submit request: $e'),
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
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
