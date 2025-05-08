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
  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices(Supabase.instance.client);
    UserProfile currentUser = UserProfile(
      name: authServices.currentUserSession?.user.userMetadata!['name'] ?? '',
      email: authServices.currentUserSession?.user.email ?? '',
      phone:
          authServices.currentUserSession?.user.userMetadata!['number'] ?? '',
    );
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
            'Recipient Name: ${currentUser.name}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Recipient Phone: ${currentUser.phone}',
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
