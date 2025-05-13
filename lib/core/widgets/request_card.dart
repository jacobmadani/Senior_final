import 'package:flutter/material.dart';
import 'package:mobile_project/core/utils/constants.dart';
import 'package:mobile_project/core/models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onTap;

  const RequestCard({super.key, required this.request, required this.onTap});

  static const int totalBlocks = 20;

  @override
  Widget build(BuildContext context) {
    final double donated = request.donatedAmount;
    final double goal = request.goalAmount;
    final double progress = (donated / goal).clamp(0.0, 1.0);
    final int filledBlocks = (progress * totalBlocks).floor();
    final int percentage = (progress * 100).toInt();

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
                  Text(request.location),
                  const Spacer(),
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(request.category),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Collected: \$${donated.toStringAsFixed(0)} / \$${goal.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(totalBlocks, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 10,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              index < filledBlocks
                                  ? Colors.green
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text('$percentage%', style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 12),
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
