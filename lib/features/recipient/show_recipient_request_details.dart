// ignore_for_file: use_build_context_synchronously

part of 'recipient_imports.dart';

class ShowRecipeintRequestDetails extends StatefulWidget {
  const ShowRecipeintRequestDetails({super.key, required this.request});
  final RequestModel request;

  @override
  State<ShowRecipeintRequestDetails> createState() =>
      _ShowRecipientRequestDetailsState();
}

class _ShowRecipientRequestDetailsState
    extends State<ShowRecipeintRequestDetails> {
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

  Future<void> deleteRequest(String requestId) async {
    try {
      await Supabase.instance.client
          .from('request')
          .delete()
          .eq('id', requestId);

      debugPrint("✅ Request deleted: $requestId");
    } catch (e) {
      debugPrint("Error deleting request: $e");
      throw Exception("Failed to delete request");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.request.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          // 🔽 Added fields here before category
          Text(
            'Recipient Name: ${recipientProfile?.name ?? 'Loading...'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Recipient Phone: ${recipientProfile?.phone ?? 'Loading...'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Area: ${widget.request.location}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Category: ${widget.request.category}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Urgency: ${widget.request.urgency}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Location: ${widget.request.location}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Description:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(widget.request.description),
          const SizedBox(height: 16),
          Text(
            'Confirmation Code: ${widget.request.confirmationCode}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                              'Are you sure you want to delete this request?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      try {
                        await deleteRequest(widget.request.id);
                        Navigator.pop(
                          context,
                          true,
                        ); // ✅ signal to parent to refresh

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request deleted successfully!'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting request: $e')),
                        );
                      }
                    }
                  },

                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
