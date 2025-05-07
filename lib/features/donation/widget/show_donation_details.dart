// import 'package:flutter/material.dart';
// import 'package:mobile_project/core/models/donation.dart';
// import 'package:mobile_project/core/utils/constants.dart';

// // ignore: must_be_immutable
// class ShowDonationDetails extends StatefulWidget {
//   ShowDonationDetails({
//     super.key,
//     required this.donation,
//     this.enteredCode,
//     this.codeErrorMessage,
//     this.donationStatus,
//   });

//   final Donation donation;
//   String? enteredCode;
//   String? codeErrorMessage;
//   final String? donationStatus;

//   @override
//   State<ShowDonationDetails> createState() => _ShowDonationDetailsState();
// }

// class _ShowDonationDetailsState extends State<ShowDonationDetails> {
//   String localStatus = '';

//   @override
//   void initState() {
//     super.initState();
//     localStatus = widget.donation.status;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             'Donation to: ${widget.donation.requestTitle}',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 16),

//           _buildDonationDetailItem('Amount', '\$${widget.donation.amount}'),
//           _buildDonationDetailItem('Items', widget.donation.items.join(', ')),
//           _buildDonationDetailItem(
//             'Date',
//             widget.donation.date.toLocal().toString().split(' ')[0],
//           ),
//           _buildDonationDetailItem('Status', localStatus),

//           const SizedBox(height: 16),
//           Text(
//             'Message:',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.textDark,
//             ),
//           ),
//           Text(widget.donation.message ?? 'No message'),

//           if (localStatus == 'Pending') ...[
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Enter the code',
//                 border: OutlineInputBorder(),
//                 errorText: widget.codeErrorMessage,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   widget.enteredCode = value;
//                   widget.codeErrorMessage = null;
//                 });
//               },
//             ),
//           ],

//           const SizedBox(height: 24),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               if (localStatus == 'Pending')
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (widget.enteredCode == '1234') {
//                           localStatus = 'Delivered';
//                           widget.codeErrorMessage = null;
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Donation was confirmed!'),
//                             ),
//                           );
//                         } else {
//                           widget.codeErrorMessage = 'Incorrect code';
//                         }
//                       });
//                     },
//                     child: const Text('Confirm'),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDonationDetailItem(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:mobile_project/core/utils/constants.dart';

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
  double goal = 1; // prevent division by 0
  double progress = 0;
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   localStatus = widget.donation.status;
  //   _fetchRequestProgress();
  // }

  // Future<void> _fetchRequestProgress() async {
  //   final request = await RequestService().getRequestById(widget.donation.requestId!);
  //   setState(() {
  //     donated = request.donatedAmount;
  //     goal = request.goalAmount > 0 ? request.goalAmount : 1;
  //     progress = donated / goal;
  //     isLoading = false;
  //   });
  // }

  // Future<void> _confirmDonation() async {
  //   if (widget.enteredCode != widget.donation.confirmationCode) {
  //     setState(() => widget.codeErrorMessage = 'Incorrect code');
  //     return;
  //   }

  //   final request = await RequestService().getRequestById(widget.donation.requestId!);

  //   final updatedAmount = request.donatedAmount + widget.donation.amount;
  //   final fulfilled = updatedAmount >= request.goalAmount;

  //   await RequestService().updateDonatedAmount(
  //     request.id,
  //     updatedAmount,
  //     fulfilled ? 'Fulfilled' : 'Pending',
  //   );

  //   setState(() {
  //     localStatus = 'Delivered';
  //     progress = updatedAmount / request.goalAmount;
  //     widget.codeErrorMessage = null;
  //   });

  //   Navigator.pop(context);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Donation was confirmed!')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final isGoalReached = progress >= 1.0;

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
          const SizedBox(height: 12),

          LinearProgressIndicator(value: progress),
          const SizedBox(height: 4),
          Text('${(progress * 100).toStringAsFixed(1)}% funded'),

          const SizedBox(height: 12),
          _buildDonationDetailItem('Amount', '\$${widget.donation.amount}'),
          _buildDonationDetailItem('Items', widget.donation.items.join(', ')),
          _buildDonationDetailItem(
            'Date',
            widget.donation.date.toLocal().toString().split(' ')[0],
          ),
          _buildDonationDetailItem('Status', localStatus),
          const SizedBox(height: 12),

          Text(
            'Message:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(widget.donation.message ?? 'No message'),

          if (localStatus == 'Pending' && !isGoalReached) ...[
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
                  widget.codeErrorMessage = null;
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
              if (localStatus == 'Pending' && !isGoalReached)
                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: _confirmDonation,
                //     child: const Text('Confirm'),
                //   ),
                // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
