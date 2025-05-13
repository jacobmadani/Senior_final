import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/widgets/request_card.dart';
import 'package:mobile_project/features/recipient/show_request_details.dart';

class SearchRequestScreen extends StatefulWidget {
  final List<RequestModel> requests;

  const SearchRequestScreen({super.key, required this.requests});

  @override
  State<SearchRequestScreen> createState() => _SearchRequestScreenState();
}

class _SearchRequestScreenState extends State<SearchRequestScreen> {
  List<RequestModel> filteredRequests = [];

  @override
  void initState() {
    super.initState();
    filteredRequests = widget.requests;
  }

  void _runFilter(String keyword) {
    final results =
        keyword.isEmpty
            ? widget.requests
            : widget.requests
                .where(
                  (req) =>
                      req.title.toLowerCase().contains(keyword.toLowerCase()),
                )
                .toList();

    setState(() => filteredRequests = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Requests')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child:
                filteredRequests.isEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                      itemCount: filteredRequests.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final req = filteredRequests[index];
                        return RequestCard(
                          request: req,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => ShowRequestDetails(request: req),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
