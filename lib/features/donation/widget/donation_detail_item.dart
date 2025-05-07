import 'package:flutter/material.dart';
import 'package:mobile_project/core/utils/constants.dart';

class DonationDetailItem extends StatelessWidget {
  const DonationDetailItem({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
