// import 'package:flutter/material.dart';

// class DonationPage extends StatelessWidget {
//   const DonationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _donations.isEmpty
//         ? const Center(child: Text('No donations yet'))
//         : ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: _donations.length,
//           itemBuilder: (context, index) {
//             return DonationCard(
//               donation: _donations[index],
//               onTap: () {
//                 _showDonationDetails(_donations[index]);
//               },
//             );
//           },
//         );
//   }
// }
