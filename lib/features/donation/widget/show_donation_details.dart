// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
  String localStatus = '';
  double donated = 0;
  double goal = 1;
  double progress = 0;
  bool isLoading = true;

  double? enteredAmount; // donor’s input

  @override
  void initState() {
    super.initState();
    localStatus = widget.donation.status;
    _fetchRequestProgress();
  }

  Future<void> _fetchRequestProgress() async {
    final req = await RequestService().getRequestById(
      widget.donation.requestId!,
    );
    setState(() {
      donated = req.donatedAmount;
      goal = req.goalAmount > 0 ? req.goalAmount : 1;
      progress = donated / goal;
      isLoading = false;
    });
  }

  Future<void> _confirmDonation() async {
    // 1) Validate confirmation code
    if (widget.enteredCode != widget.donation.confirmationCode) {
      setState(() => widget.codeErrorMessage = 'Incorrect code');
      return;
    }

    // 2) Validate amount
    if (enteredAmount == null || enteredAmount! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // 3) Fetch fresh request
    final req = await RequestService().getRequestById(
      widget.donation.requestId!,
    );
    final remainingAmount = req.goalAmount - req.donatedAmount;

    if (remainingAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This request has already been fully funded!'),
        ),
      );
      return;
    }

    if (enteredAmount! > remainingAmount) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can only donate up to \$${remainingAmount.toStringAsFixed(2)} to reach the goal.',
          ),
        ),
      );
      return;
    }

    final newTotal = req.donatedAmount + enteredAmount!;
    final fulfilled = newTotal >= req.goalAmount;

    // 4) Update the request table
    await RequestService().updateDonatedAmount(
      req.id,
      newTotal,
      fulfilled ? 'Fulfilled' : 'Pending',
      widget.enteredCode!,
      fulfilled,
    );

    // ✅ 5) Insert into the donation table
    final response =
        await Supabase.instance.client
            .from('donation')
            .insert({
              'id': Uuid().v4(),
              'donor_id': widget.donation.donorId,
              'request_id': widget.donation.requestId,
              'amountdonated': enteredAmount,
            })
            .limit(1)
            .maybeSingle();

    if (response != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save donation: ${response.toString()}'),
        ),
      );
      return;
    }

    // 6) Update UI
    setState(() {
      donated = newTotal;
      progress = newTotal / goal;
      localStatus = fulfilled ? 'Fulfilled' : 'Pending';
      widget.codeErrorMessage = null;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Donation of \$${enteredAmount!.toStringAsFixed(2)} confirmed!',
        ),
      ),
    );

    // 7) Pop and return
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(
      Donation(
        id: widget.donation.id,
        donorId: widget.donation.donorId,
        requestId: widget.donation.requestId,
        requestTitle: widget.donation.requestTitle,
        amount: enteredAmount ?? 0.0,
        date: widget.donation.date,
        status: localStatus,
        confirmationCode: widget.donation.confirmationCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isGoalReached = progress >= 1.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Donation to: ${widget.donation.requestTitle}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            LinearProgressIndicator(value: progress),
            const SizedBox(height: 4),
            Text('${(progress * 100).toStringAsFixed(1)}% funded'),
            const SizedBox(height: 12),

            _buildDetailRow(
              'Current Donated',
              '\$${donated.toStringAsFixed(2)}',
            ),
            _buildDetailRow('Goal Amount', '\$${goal.toStringAsFixed(2)}'),
            _buildDetailRow('Status', localStatus),
            const SizedBox(height: 12),

            if (localStatus == 'Pending' && !isGoalReached) ...[
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Enter donation amount',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (v) => setState(() => enteredAmount = double.tryParse(v)),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter the code',
                  border: const OutlineInputBorder(),
                  errorText: widget.codeErrorMessage,
                ),
                onChanged:
                    (v) => setState(() {
                      widget.enteredCode = v;
                      widget.codeErrorMessage = null;
                    }),
              ),
            ],

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      final bool shouldShowConfirm =
                          (enteredAmount != null && enteredAmount! > 0) &&
                          (widget.enteredCode != null &&
                              widget.enteredCode!.isNotEmpty);

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              shouldShowConfirm ? Colors.orange : Colors.red,
                        ),
                        onPressed: () async {
                          if (shouldShowConfirm) {
                            await _confirmDonation();
                          } else {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                      'Delete this saved donation?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed:
                                            () => Navigator.pop(ctx, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirmed == true) {
                              await Supabase.instance.client
                                  .from('savedrequest')
                                  .delete()
                                  .eq('donor_id', widget.donation.donorId!)
                                  .eq('request_id', widget.donation.requestId!);

                              // Delay to avoid Navigator pop collision
                              Future.microtask(() {
                                if (mounted)
                                  Navigator.pop(context, true); // return result
                              });
                            }
                          }
                        },
                        child: Text(
                          shouldShowConfirm ? 'Confirm Donation' : 'Delete',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
