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
    print('Fetching recipient for id: ${widget.request.recipientId}');
    final response =
        await Supabase.instance.client
            .from('recipient')
            .select('id,name, number')
            .eq('id', widget.request.recipientId)
            .maybeSingle();

    print('Recipient response: $response');

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
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request Deleted successfully!'),
                      ),
                    );
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
