import 'package:flutter/material.dart';
import 'package:mobile_project/core/constants.dart';
import 'package:mobile_project/models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onTap;

  const RequestCard({super.key, required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    backgroundColor: _getUrgencyColor(request.urgency),
                    label: Text(
                      request.urgency,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    '${request.date.day}/${request.date.month}/${request.date.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    request.location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    request.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(request.category),
                  const Spacer(),
                  Chip(
                    label: Text(request.status),
                    backgroundColor:
                        request.status == 'Fulfilled'
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}
