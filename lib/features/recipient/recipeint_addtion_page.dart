import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:mobile_project/core/widgets/request_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipientRequestsPage extends StatefulWidget {
  const RecipientRequestsPage({super.key});

  @override
  State<RecipientRequestsPage> createState() => _RecipientRequestsPageState();
}

class _RecipientRequestsPageState extends State<RecipientRequestsPage> {
  List<RequestModel> _requests = [];
  bool _isLoading = true;
  final RequestService requestService = RequestService();

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final recipientId = Supabase.instance.client.auth.currentUser?.id;
    if (recipientId == null) return;

    setState(() => _isLoading = true);

    try {
      final requests = await requestService.getRequestsByRecipient(recipientId);
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load requests: $e')));
    }
  }

  void _showRequestDetails(RequestModel request) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${request.title}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Description: ${request.description}'),
                const SizedBox(height: 8),
                Text('Goal: \$${request.goalAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Donated: \$${request.donatedAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Status: ${request.status}'),
                const SizedBox(height: 8),
                Text('Confirmation Code: ${request.confirmationCode}'),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _requests.isEmpty
                ? const Center(child: Text('No requests created yet'))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    return RequestCard(
                      request: _requests[index],
                      onTap: () => _showRequestDetails(_requests[index]),
                    );
                  },
                ),
      ),
    );
  }
}
