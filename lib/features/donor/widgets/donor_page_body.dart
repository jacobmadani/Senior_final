part of 'package:mobile_project/features/donor/widgets/donar_imports.dart';

// class DonorHomeController {
//   final List<Request> _requests;
//   final List<Donation> _donations;

//   DonorHomeController({
//     required List<Request> requests,
//     required List<Donation> donations,
//   }) : _requests = requests,
//        _donations = donations;

//   List<Request> get activeRequests =>
//       _requests.where((r) => r.status != 'Fulfilled').toList();
//   List<Donation> get allDonations => _donations;

//   void fulfillRequest(Request request, Donation donation) {
//     request.status = 'Fulfilled';
//     _donations.add(donation);
//   }
// }

class DonorPageBody extends StatefulWidget {
  const DonorPageBody({super.key});

  @override
  State<DonorPageBody> createState() => _DonorPageBodyState();
}

class _DonorPageBodyState extends State<DonorPageBody> {
  String enteredCode = '';
  String? _codeErrorMessage;
  int currentIndex = 0;
  bool isrefreshing = false;
  final RequestService requestService = RequestService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.resourceMap);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isrefreshing = true;
          });
          await Future.delayed(const Duration(seconds: 3));
          await requestService.refreshRequests();
          setState(() {
            isrefreshing = false;
          });
        },
        child: StreamBuilder(
          stream: requestService.getRequestStream(),
          builder: (context, snapshot) {
            if (isrefreshing ||
                (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData)) {
              return const Center(child: CircularProgressIndicator());
            }
            final requests = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  request: requests[index],
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ShowDonorRequestDetails(request: requests[index]);
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton:
      //     _currentIndex == 0
      //         ? FloatingActionButton(
      //           backgroundColor: AppColors.primary,
      //           onPressed: () {
      //             _showCreateDonationDialog();
      //           },
      //           child: const Icon(Icons.add, color: Colors.white),
      //         )
      //         : null,
    );
  }

  // void _showCreateDonationDialog({Request? request}) async {
  //   final TextEditingController amountController = TextEditingController();
  //   final TextEditingController itemsController = TextEditingController();
  //   final TextEditingController messageController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           request == null
  //               ? 'Create New Donation'
  //               : 'Donate to ${request.title}',
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: amountController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Amount (USD)',
  //                 prefixText: '\$',
  //               ),
  //               keyboardType: TextInputType.number,
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: itemsController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Items (comma separated)',
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: messageController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Message (optional)',
  //               ),
  //               maxLines: 3,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               final newDonation = Donation(
  //                 id: DateTime.now().millisecondsSinceEpoch.toString(),
  //                 requestTitle: request?.title ?? 'General Donation',
  //                 amount: double.tryParse(amountController.text) ?? 0,
  //                 items: itemsController.text.split(','),
  //                 date: DateTime.now().toIso8601String(),
  //                 status: 'Pending',
  //                 message:
  //                     messageController.text.isNotEmpty
  //                         ? messageController.text
  //                         : null,
  //               );
  //               if (request != null) {
  //                 setState(() {
  //                   request.status = 'Fulfilled';
  //                   // _donations.add(newDonation);
  //                 });
  //               } else {
  //                 // setState(() => _donations.add(newDonation));
  //               }

  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text(
  //                     request != null
  //                         ? 'Thank you for fulfilling the request!'
  //                         : 'General donation submitted!',
  //                   ),
  //                 ),
  //               );
  //             },
  //             child: const Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showDonationDetails(Donation donation) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return ShowDonationDetails(
  //         donation: donation,
  //         codeErrorMessage: _codeErrorMessage,
  //         donationStatus: '',
  //         enteredCode: enteredCode,
  //       );
  //     },
  //   );
  // }
}
