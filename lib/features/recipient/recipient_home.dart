import 'package:flutter/material.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:mobile_project/core/utils/constants.dart';
import 'package:mobile_project/core/widgets/request_card.dart';

import 'package:mobile_project/features/recipient/create_request.dart';
import 'package:mobile_project/features/recipient/recipient_imports.dart';

class RecipientHomeScreen extends StatefulWidget {
  const RecipientHomeScreen({super.key});

  @override
  State<RecipientHomeScreen> createState() => _RecipientHomeScreenState();
}

class _RecipientHomeScreenState extends State<RecipientHomeScreen> {
  bool isRefreshing = false;
  final RequestService requestService = RequestService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isRefreshing = true;
          });
          await Future.delayed(const Duration(seconds: 3));
          await requestService.refreshRequests();
          setState(() {
            isRefreshing = false;
          });
        },
        child: StreamBuilder(
          stream: requestService.getRequestStream(),
          builder: (context, snapshot) {
            if (isRefreshing ||
                (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No requests found.'));
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
                        return ShowRecipeintRequestDetails(
                          request: requests[index],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          setState(() {
            isRefreshing = true;
          });
          final newRequest = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRequestScreen(),
            ),
          );
          if (newRequest != null) {
            await Future.wait([
              requestService.refreshRequests(),
              Future.delayed(const Duration(seconds: 3)),
            ]);
          }
          setState(() {
            isRefreshing = false;
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
