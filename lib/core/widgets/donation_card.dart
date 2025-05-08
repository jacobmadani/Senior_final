import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation_model.dart';
import 'package:mobile_project/core/utils/constants.dart';

class DonationCard extends StatelessWidget {
  final DonationModel donation;
  final VoidCallback onTap;

  const DonationCard({super.key, required this.donation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                donation.requestTitle.isNotEmpty
                    ? donation.requestTitle
                    : 'General Donation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\$${donation.amount}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(donation.status),
                    backgroundColor: _getStatusColor(donation.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(donation.date as String, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'canceled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
