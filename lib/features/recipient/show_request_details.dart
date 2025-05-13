import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/recipient.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShowRequestDetails extends StatefulWidget {
  final RequestModel request;
  const ShowRequestDetails({super.key, required this.request});

  @override
  State<ShowRequestDetails> createState() => _ShowRequestDetailsState();
}

class _ShowRequestDetailsState extends State<ShowRequestDetails> {
  Recipient? recipientProfile;
  @override
  void initState() {
    super.initState();
    _fetchRecipient();
  }

  Future<void> _fetchRecipient() async {
    final response =
        await Supabase.instance.client
            .from('recipient')
            .select('id,name, number')
            .eq('id', widget.request.recipientId)
            .maybeSingle();

    if (mounted) {
      setState(() {
        if (response != null) {
          recipientProfile = Recipient.fromJson(response);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipient Name: ${recipientProfile?.name ?? 'Loading...'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Recipient Phone: ${recipientProfile?.phone ?? 'Loading...'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Title: ${widget.request.title}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Description: ${widget.request.description}'),
          const SizedBox(height: 8),
          Text('Goal: \$${widget.request.goalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Donated: \$${widget.request.donatedAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Status: ${widget.request.status}'),
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
    );
  }
}
