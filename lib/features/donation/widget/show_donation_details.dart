import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/utils/constants.dart';

// ignore: must_be_immutable
class ShowDonationDetails extends StatefulWidget {
  ShowDonationDetails({
    super.key,
    required this.donation,
    this.enteredCode,
    this.codeErrorMessage,
    this.donationStatus,
  });
  final Donation donation;
  String? enteredCode;
  String? codeErrorMessage;
  final String? donationStatus;

  @override
  State<ShowDonationDetails> createState() => _ShowDonationDetailsState();
}

class _ShowDonationDetailsState extends State<ShowDonationDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Donation to: ${widget.donation.requestTitle}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // _buildDonationDetailItem('Recipient Name', 'John Doe'),
          // _buildDonationDetailItem('Phone number', '+961-70123456'),
          // _buildDonationDetailItem('Location', 'Beirut, Lebanon'),
          // _buildDonationDetailItem('Amount', '\$${donation.amount}'),
          // _buildDonationDetailItem('Items', donation.items.join(', ')),
          // _buildDonationDetailItem('Date', donation.date),
          // _buildDonationDetailItem('Status', donation.status),
          const SizedBox(height: 16),
          Text(
            'Message:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(widget.donation.message ?? 'No message'),
          if (widget.donation.status == 'Pending') ...[
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter the code',
                border: OutlineInputBorder(),
                errorText: widget.codeErrorMessage,
              ),
              onChanged: (value) {
                setState(() {
                  widget.enteredCode = value;
                  widget.codeErrorMessage = null; // Clear error on new input
                });
              },
            ),
          ],

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 16),
              if (widget.donation.status == 'Pending')
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget.enteredCode == '1234') {
                          widget.donation.status = 'Delivered';
                          widget.codeErrorMessage = null;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Donation was done!')),
                          );
                        } else {
                          widget.codeErrorMessage = 'Incorrect code';
                        }
                      });
                    },
                    child: const Text('Donate'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
