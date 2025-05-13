// import 'package:flutter/material.dart';
// import 'package:mobile_project/core/models/donation.dart';
// import 'package:mobile_project/core/services/request_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';

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
//   double donated = 0;
//   double goal = 1;
//   double progress = 0;
//   bool isLoading = true;

//   double? enteredAmount; // donor’s input

//   @override
//   void initState() {
//     super.initState();
//     localStatus = widget.donation.status;
//     _fetchRequestProgress();
//   }

//   Future<void> _fetchRequestProgress() async {
//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );
//     setState(() {
//       donated = req.donatedAmount.toDouble();
//       goal = req.goalAmount > 0 ? req.goalAmount.toDouble() : 1.0;
//       progress = donated / goal;
//       isLoading = false;
//     });
//   }

//   Future<void> _confirmDonation() async {
//     // 1) Validate confirmation code
//     if (widget.enteredCode != widget.donation.confirmationCode) {
//       setState(() => widget.codeErrorMessage = 'Incorrect code');
//       return;
//     }

//     // 2) Validate amount
//     if (enteredAmount == null || enteredAmount! <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid amount')),
//       );
//       return;
//     }

//     // 3) Fetch fresh request
//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );
//     final remainingAmount =
//         req.goalAmount.toDouble() - req.donatedAmount.toDouble();

//     if (remainingAmount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('This request has already been fully funded!'),
//         ),
//       );
//       return;
//     }

//     if (enteredAmount! > remainingAmount) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'You can only donate up to \$${remainingAmount.toStringAsFixed(2)} to reach the goal.',
//           ),
//         ),
//       );
//       return;
//     }

//     final newTotal = req.donatedAmount.toDouble() + enteredAmount!.toDouble();
//     final fulfilled = newTotal >= req.goalAmount;

//     // 4) Update the request table
//     await RequestService().updateDonatedAmount(
//       req.id,
//       newTotal,
//       fulfilled ? 'Fulfilled' : 'Pending',
//       widget.enteredCode!,
//       fulfilled,
//     );

//     // ✅ 5) Insert into the donation table
//     final response = await Supabase.instance.client.from('donation').insert({
//       'id': Uuid().v4(),
//       'donor_id': widget.donation.donorId,
//       'request_id': widget.donation.requestId,
//       'amountdonated': enteredAmount,
//     });

//     if (response.error != null) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save donation: ${response.error!.message}'),
//         ),
//       );
//       return;
//     }

//     // 6) Update UI
//     setState(() {
//       donated = newTotal;
//       progress = newTotal / goal;
//       localStatus = fulfilled ? 'Fulfilled' : 'Pending';
//       widget.codeErrorMessage = null;
//     });
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Donation of \$${enteredAmount!.toStringAsFixed(2)} confirmed!',
//         ),
//       ),
//     );

//     // 7) Pop and return
//     if (!mounted) return;
//     Navigator.of(context, rootNavigator: true).pop(
//       Donation(
//         id: widget.donation.id,
//         donorId: widget.donation.donorId,
//         requestId: widget.donation.requestId,
//         requestTitle: widget.donation.requestTitle,
//         amount: enteredAmount ?? 0.0,
//         date: widget.donation.date,
//         status: localStatus,
//         confirmationCode: widget.donation.confirmationCode,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final isGoalReached = progress >= 1.0;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Donation to: ${widget.donation.requestTitle}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 12),

//             LinearProgressIndicator(value: progress),
//             const SizedBox(height: 4),
//             Text('${(progress * 100).toStringAsFixed(1)}% funded'),
//             const SizedBox(height: 12),

//             _buildDetailRow(
//               'Current Donated',
//               '\$${donated.toStringAsFixed(2)}',
//             ),
//             _buildDetailRow('Goal Amount', '\$${goal.toStringAsFixed(2)}'),
//             _buildDetailRow('Status', localStatus),
//             const SizedBox(height: 12),

//             if (localStatus == 'Pending' && !isGoalReached) ...[
//               TextField(
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 decoration: const InputDecoration(
//                   labelText: 'Enter donation amount',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged:
//                     (v) => setState(() => enteredAmount = double.tryParse(v)),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Enter the code',
//                   border: const OutlineInputBorder(),
//                   errorText: widget.codeErrorMessage,
//                 ),
//                 onChanged:
//                     (v) => setState(() {
//                       widget.enteredCode = v;
//                       widget.codeErrorMessage = null;
//                     }),
//               ),
//             ],

//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Close'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 if (localStatus == 'Pending' && !isGoalReached)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed:
//                           (enteredAmount != null && enteredAmount! > 0)
//                               ? _confirmDonation
//                               : null,
//                       child: const Text('Confirm Donation'),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:mobile_project/core/models/donation.dart';
// import 'package:mobile_project/core/services/request_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';

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
//   double donated = 0;
//   double goal = 1;
//   double progress = 0;
//   bool isLoading = true;
//   bool isPaidRequest = true;

//   double? enteredAmount;

//   @override
//   void initState() {
//     super.initState();
//     localStatus = widget.donation.status;
//     _fetchRequestProgress();
//   }

//   Future<void> _fetchRequestProgress() async {
//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );
//     final paid = req.goalAmount > 0;

//     setState(() {
//       isPaidRequest = paid;
//       donated = req.donatedAmount.toDouble();
//       goal = paid ? req.goalAmount.toDouble() : 1.0;
//       progress = donated / goal;
//       isLoading = false;
//     });
//   }

//   // Future<void> _confirmDonation() async {
//   //   if (widget.enteredCode != widget.donation.confirmationCode) {
//   //     setState(() => widget.codeErrorMessage = 'Incorrect code');
//   //     return;
//   //   }

//   //   if (isPaidRequest) {
//   //     if (enteredAmount == null || enteredAmount! <= 0) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Please enter a valid amount')),
//   //       );
//   //       return;
//   //     }

//   //     final req = await RequestService().getRequestById(
//   //       widget.donation.requestId!,
//   //     );
//   //     final remainingAmount =
//   //         req.goalAmount.toDouble() - req.donatedAmount.toDouble();

//   //     if (remainingAmount <= 0) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(
//   //           content: Text('This request has already been fully funded!'),
//   //         ),
//   //       );
//   //       return;
//   //     }

//   //     if (enteredAmount! > remainingAmount) {
//   //       if (!mounted) return;
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text(
//   //             'You can only donate up to \$${remainingAmount.toStringAsFixed(2)} to reach the goal.',
//   //           ),
//   //         ),
//   //       );
//   //       return;
//   //     }

//   //     final newTotal = req.donatedAmount.toDouble() + enteredAmount!;
//   //     final fulfilled = newTotal >= req.goalAmount;

//   //     await RequestService().updateDonatedAmount(
//   //       req.id,
//   //       newTotal,
//   //       fulfilled ? 'Fulfilled' : 'Pending',
//   //       widget.enteredCode!,
//   //       fulfilled,
//   //     );

//   //     final response = await Supabase.instance.client.from('donation').insert({
//   //       'id': Uuid().v4(),
//   //       'donor_id': widget.donation.donorId,
//   //       'request_id': widget.donation.requestId,
//   //       'amountdonated': enteredAmount,
//   //       'code': widget.enteredCode,
//   //     });

//   //     if (response.error != null) {
//   //       if (!mounted) return;
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text(
//   //             'Failed to save donation: ${response.error!.message}',
//   //           ),
//   //         ),
//   //       );
//   //       return;
//   //     }

//   //     setState(() {
//   //       donated = newTotal;
//   //       progress = newTotal / goal;
//   //       localStatus = fulfilled ? 'Fulfilled' : 'Pending';
//   //       widget.codeErrorMessage = null;
//   //     });

//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text(
//   //           'Donation of \$${enteredAmount!.toStringAsFixed(2)} confirmed!',
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     // UNPAID request → only confirm code with amount = 0
//   //     final response = await Supabase.instance.client.from('donation').insert({
//   //       'id': Uuid().v4(),
//   //       'donor_id': widget.donation.donorId,
//   //       'request_id': widget.donation.requestId,
//   //       'amountdonated': 0,
//   //       'code': widget.enteredCode,
//   //     });

//   //     if (response.error != null) {
//   //       if (!mounted) return;
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text('Failed to confirm code: ${response.error!.message}'),
//   //         ),
//   //       );
//   //       return;
//   //     }

//   //     await _fetchRequestProgress(); // refresh progress bar

//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Code confirmed for this request!')),
//   //     );
//   //   }

//   //   if (!mounted) return;
//   //   Navigator.of(context, rootNavigator: true).pop(widget.donation);
//   // }

//   Future<void> _confirmDonation() async {
//     if (widget.enteredCode != widget.donation.confirmationCode) {
//       setState(() => widget.codeErrorMessage = 'Incorrect code');
//       return;
//     }

//     if (enteredAmount == null || enteredAmount! <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid amount')),
//       );
//       return;
//     }

//     // Fetch request from DB
//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );

//     final bool isPaid = req.goalAmount > 0;
//     final double effectiveGoal = isPaid ? req.goalAmount.toDouble() : 5.0;
//     final double currentDonated = req.donatedAmount.toDouble();
//     final double remainingAmount = effectiveGoal - currentDonated;

//     if (remainingAmount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('This request has already been fully funded!'),
//         ),
//       );
//       return;
//     }

//     if (enteredAmount! > remainingAmount) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'You can only donate up to \$${remainingAmount.toStringAsFixed(2)} to complete the request.',
//           ),
//         ),
//       );
//       return;
//     }

//     final double newTotal = currentDonated + enteredAmount!;
//     final bool fulfilled = newTotal >= effectiveGoal;

//     // ✅ Update the request (required even for unpaid requests)
//     await RequestService().updateDonatedAmount(
//       req.id,
//       newTotal,
//       fulfilled ? 'Fulfilled' : 'Pending',
//       widget.enteredCode!,
//       fulfilled,
//     );

//     // ✅ Insert the donation
//     final response = await Supabase.instance.client.from('donation').insert({
//       'id': Uuid().v4(),
//       'donor_id': widget.donation.donorId,
//       'request_id': widget.donation.requestId,
//       'amountdonated': enteredAmount,
//       'code': widget.enteredCode,
//     });

//     if (response.error != null) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save donation: ${response.error!.message}'),
//         ),
//       );
//       return;
//     }

//     // ✅ Update local UI
//     setState(() {
//       donated = newTotal;
//       progress = newTotal / effectiveGoal;
//       localStatus = fulfilled ? 'Fulfilled' : 'Pending';
//       widget.codeErrorMessage = null;
//     });

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Donation of \$${enteredAmount!.toStringAsFixed(2)} confirmed!',
//         ),
//       ),
//     );

//     Navigator.of(context, rootNavigator: true).pop(
//       widget.donation.copyWith(amount: enteredAmount!, status: localStatus),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final isGoalReached = progress >= 1.0;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Donation to: ${widget.donation.requestTitle}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 12),

//             LinearProgressIndicator(value: progress),
//             const SizedBox(height: 4),
//             Text('${(progress * 100).toStringAsFixed(1)}% funded'),
//             const SizedBox(height: 12),

//             _buildDetailRow(
//               'Current Donated',
//               '\$${donated.toStringAsFixed(2)}',
//             ),
//             _buildDetailRow('Goal Amount', '\$${goal.toStringAsFixed(2)}'),
//             _buildDetailRow('Status', localStatus),
//             const SizedBox(height: 12),

//             if (localStatus == 'Pending' && !isGoalReached) ...[
//               if (isPaidRequest)
//                 TextField(
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                   decoration: const InputDecoration(
//                     labelText: 'Enter donation amount',
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged:
//                       (v) => setState(() => enteredAmount = double.tryParse(v)),
//                 ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Enter the code',
//                   border: const OutlineInputBorder(),
//                   errorText: widget.codeErrorMessage,
//                 ),
//                 onChanged:
//                     (v) => setState(() {
//                       widget.enteredCode = v;
//                       widget.codeErrorMessage = null;
//                     }),
//               ),
//             ],

//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Close'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 if (localStatus == 'Pending' && !isGoalReached)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed:
//                           (isPaidRequest
//                                   ? (enteredAmount != null &&
//                                       enteredAmount! > 0)
//                                   : (widget.enteredCode != null &&
//                                       widget.enteredCode!.isNotEmpty))
//                               ? _confirmDonation
//                               : null,
//                       child: const Text('Confirm Donation'),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:mobile_project/core/models/donation.dart';
// import 'package:mobile_project/core/services/request_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';

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
//   double donated = 0;
//   double goal = 1;
//   double progress = 0;
//   bool isLoading = true;
//   double? enteredAmount;
//   bool isPaidRequest = true;

//   @override
//   void initState() {
//     super.initState();
//     localStatus = widget.donation.status;
//     _fetchRequestProgress();
//   }

//   Future<void> _fetchRequestProgress() async {
//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );

//     final bool isPaid = req.goalAmount > 0;
//     final double effectiveGoal = isPaid ? req.goalAmount.toDouble() : 5.0;

//     setState(() {
//       isPaidRequest = isPaid;
//       donated = req.donatedAmount.toDouble();
//       goal = effectiveGoal;
//       progress = (donated / effectiveGoal).clamp(0.0, 1.0);
//       isLoading = false;
//     });
//   }

//   Future<void> _confirmDonation() async {
//     if (widget.enteredCode != widget.donation.confirmationCode) {
//       setState(() => widget.codeErrorMessage = 'Incorrect code');
//       return;
//     }

//     if (enteredAmount == null || enteredAmount! <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid amount')),
//       );
//       return;
//     }

//     final req = await RequestService().getRequestById(
//       widget.donation.requestId!,
//     );

//     final bool isPaid = req.goalAmount > 0;
//     final double effectiveGoal = isPaid ? req.goalAmount.toDouble() : 5.0;
//     final double currentDonated = req.donatedAmount.toDouble();
//     final double remainingAmount = effectiveGoal - currentDonated;

//     if (remainingAmount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('This request has already been fully funded!'),
//         ),
//       );
//       return;
//     }

//     if (enteredAmount! > remainingAmount) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'You can only donate up to \$${remainingAmount.toStringAsFixed(2)} to complete the request.',
//           ),
//         ),
//       );
//       return;
//     }

//     final double newTotal = currentDonated + enteredAmount!;
//     final bool fulfilled = newTotal >= effectiveGoal;

//     // Update the request
//     await RequestService().updateDonatedAmount(
//       req.id,
//       newTotal,
//       fulfilled ? 'Fulfilled' : 'Pending',
//       widget.enteredCode!,
//       fulfilled,
//     );

//     // Insert the donation
//     final response = await Supabase.instance.client.from('donation').insert({
//       'id': Uuid().v4(),
//       'donor_id': widget.donation.donorId,
//       'request_id': widget.donation.requestId,
//       'amountdonated': enteredAmount,
//       'code': widget.enteredCode,
//     });

//     if (response.error != null) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save donation: ${response.error!.message}'),
//         ),
//       );
//       return;
//     }

//     // Update UI
//     setState(() {
//       donated = newTotal;
//       progress = newTotal / goal;
//       localStatus = fulfilled ? 'Fulfilled' : 'Pending';
//       widget.codeErrorMessage = null;
//     });

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Donation of \$${enteredAmount!.toStringAsFixed(2)} confirmed!',
//         ),
//       ),
//     );

//     Navigator.of(context, rootNavigator: true).pop(
//       widget.donation.copyWith(amount: enteredAmount!, status: localStatus),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final isGoalReached = progress >= 1.0;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Donation to: ${widget.donation.requestTitle}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 12),
//             LinearProgressIndicator(value: progress),
//             const SizedBox(height: 4),
//             Text('${(progress * 100).toStringAsFixed(1)}% funded'),
//             const SizedBox(height: 12),
//             _buildDetailRow(
//               'Current Donated',
//               '\$${donated.toStringAsFixed(2)}',
//             ),
//             _buildDetailRow('Goal Amount', '\$${goal.toStringAsFixed(2)}'),
//             _buildDetailRow('Status', localStatus),
//             const SizedBox(height: 12),

//             if (localStatus == 'Pending' && !isGoalReached) ...[
//               TextField(
//                 keyboardType: const TextInputType.numberWithOptions(
//                   decimal: true,
//                 ),
//                 decoration: const InputDecoration(
//                   labelText: 'Enter donation amount',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged:
//                     (v) => setState(() => enteredAmount = double.tryParse(v)),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Enter the code',
//                   border: const OutlineInputBorder(),
//                   errorText: widget.codeErrorMessage,
//                 ),
//                 onChanged:
//                     (v) => setState(() {
//                       widget.enteredCode = v;
//                       widget.codeErrorMessage = null;
//                     }),
//               ),
//             ],

//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Close'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 if (localStatus == 'Pending' && !isGoalReached)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed:
//                           (enteredAmount != null &&
//                                   enteredAmount! > 0 &&
//                                   widget.enteredCode != null &&
//                                   widget.enteredCode!.isNotEmpty)
//                               ? _confirmDonation
//                               : null,
//                       child: const Text('Confirm Donation'),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
  bool isPaidRequest = true;

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

    final bool isPaid = req.goalAmount > 0;
    final double effectiveGoal = isPaid ? req.goalAmount.toDouble() : 1.0;

    setState(() {
      isPaidRequest = isPaid;
      donated = req.donatedAmount.toDouble();
      goal = effectiveGoal;
      progress = (donated / effectiveGoal).clamp(0.0, 1.0);
      isLoading = false;
    });
  }

  // Future<void> _confirmDonation() async {
  //   final req = await RequestService().getRequestById(
  //     widget.donation.requestId!,
  //   );

  //   final bool isPaid = req.goalAmount > 0;

  //   if (widget.enteredCode != req.confirmationCode) {
  //     setState(() => widget.codeErrorMessage = 'Incorrect code');
  //     return;
  //   }

  //   // Paid request → proceed as usual
  //   if (isPaid) {
  //     final double currentDonated = req.donatedAmount.toDouble();
  //     final double remainingAmount = goal - currentDonated;

  //     if (remainingAmount <= 0) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('This request has already been fully funded!'),
  //         ),
  //       );
  //       return;
  //     }

  //     final double newTotal = currentDonated + 1;
  //     final bool fulfilled = newTotal >= goal;

  //     await RequestService().updateDonatedAmount(
  //       req.id,
  //       newTotal,
  //       fulfilled ? 'Fulfilled' : 'Pending',
  //       widget.enteredCode!,
  //       fulfilled,
  //     );

  //     await Supabase.instance.client.from('donation').insert({
  //       'id': Uuid().v4(),
  //       'donor_id': widget.donation.donorId,
  //       'request_id': widget.donation.requestId,
  //       'amountdonated': 1,
  //       'code': widget.enteredCode,
  //     });

  //     setState(() {
  //       donated = newTotal;
  //       progress = donated / goal;
  //       localStatus = fulfilled ? 'Fulfilled' : 'Pending';
  //       widget.codeErrorMessage = null;
  //     });

  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Code confirmed! \$1 added.')));
  //   } else {
  //     // Unpaid request → confirm code and mark as fulfilled
  //     await RequestService().updateDonatedAmount(
  //       req.id,
  //       0,
  //       'Fulfilled',
  //       widget.enteredCode!,
  //       true,
  //     );

  //     await Supabase.instance.client.from('donation').insert({
  //       'id': Uuid().v4(),
  //       'donor_id': widget.donation.donorId,
  //       'request_id': widget.donation.requestId,
  //       'amountdonated': 0,
  //       'code': widget.enteredCode,
  //     });

  //     setState(() {
  //       localStatus = 'Fulfilled';
  //       widget.codeErrorMessage = null;
  //     });

  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Code confirmed. Request marked as fulfilled.'),
  //       ),
  //     );
  //   }

  //   if (!mounted) return;
  //   Navigator.of(
  //     context,
  //     rootNavigator: true,
  //   ).pop(widget.donation.copyWith(amount: 0, status: localStatus));
  // }
  Future<void> _confirmDonation() async {
    final req = await RequestService().getRequestById(
      widget.donation.requestId!,
    );

    final bool isPaid = req.goalAmount > 0;

    if (widget.enteredCode != req.confirmationCode) {
      setState(() => widget.codeErrorMessage = 'Incorrect code');
      return;
    }

    if (isPaid) {
      // === PAID REQUEST ===
      final double currentDonated = req.donatedAmount.toDouble();
      final double remainingAmount = goal - currentDonated;

      if (remainingAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This request has already been fully funded!'),
          ),
        );
        return;
      }

      final double newTotal = currentDonated + 1;
      final bool fulfilled = newTotal >= goal;

      // ✅ Update request only for paid requests
      await RequestService().updateDonatedAmount(
        req.id,
        newTotal,
        fulfilled ? 'Fulfilled' : 'Pending',
        widget.enteredCode!,
        fulfilled,
      );

      await Supabase.instance.client.from('donation').insert({
        'id': Uuid().v4(),
        'donor_id': widget.donation.donorId,
        'request_id': widget.donation.requestId,
        'amountdonated': 1,
        'code': widget.enteredCode,
        'status':
            fulfilled
                ? 'Fulfilled'
                : 'Pending', // Optional if you're tracking per donation
      });

      setState(() {
        donated = newTotal;
        progress = donated / goal;
        localStatus = fulfilled ? 'Fulfilled' : 'Pending';
        widget.codeErrorMessage = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Code confirmed! \$1 added.')));
    } else {
      // === UNPAID REQUEST ===
      // ❌ Do not update the request status
      await Supabase.instance.client.from('donation').insert({
        'id': Uuid().v4(),
        'donor_id': widget.donation.donorId,
        'request_id': widget.donation.requestId,
        'amountdonated': 0,
        'code': widget.enteredCode,
        'status': 'Fulfilled', // optional if you want to track on donation
      });

      setState(() {
        localStatus = 'Fulfilled';
        widget.codeErrorMessage = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code confirmed. Marked as fulfilled locally.'),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(
      widget.donation.copyWith(amount: isPaid ? 1 : 0, status: localStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

            if (isPaidRequest) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 4),
              Text('${(progress * 100).toStringAsFixed(1)}% funded'),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Current Donated',
                '\$${donated.toStringAsFixed(2)}',
              ),
              _buildDetailRow('Goal Amount', '\$${goal.toStringAsFixed(2)}'),
            ],

            _buildDetailRow('Status', localStatus),
            const SizedBox(height: 12),

            if (localStatus == 'Pending') ...[
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
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                if (localStatus == 'Pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          (widget.enteredCode != null &&
                                  widget.enteredCode!.isNotEmpty)
                              ? _confirmDonation
                              : null,
                      child: const Text('Confirm Code'),
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
