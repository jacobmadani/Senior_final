import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';

class SavedDonationSheet extends StatelessWidget {
  final Donation donatedAmount;
  final VoidCallback onRemove;

  const SavedDonationSheet({
    super.key,
    required this.donatedAmount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You donated \$${donatedAmount.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onRemove();
                    Navigator.pop(context); // close sheet
                  },
                  child: const Text('Remove Saved Donation'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
