import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/request_model.dart';

class ShowRequestDetails extends StatelessWidget {
  final RequestModel request;
  const ShowRequestDetails({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title: ${request.title}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Description: ${request.description}'),
          const SizedBox(height: 8),
          Text('Goal: \$${request.goalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Donated: \$${request.donatedAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Status: ${request.status}'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
