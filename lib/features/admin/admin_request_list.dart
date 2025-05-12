import 'package:flutter/material.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:mobile_project/core/widgets/request_card.dart';
import 'package:mobile_project/features/recipient/recipient_imports.dart';

class AdminRequestList extends StatefulWidget {
  const AdminRequestList({super.key});

  @override
  State<AdminRequestList> createState() => _AdminRequestListState();
}

class _AdminRequestListState extends State<AdminRequestList> {
  final RequestService requestService = RequestService();
  bool isRefreshing = false;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
    );
  }
}

