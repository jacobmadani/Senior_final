// ignore_for_file: use_build_context_synchronously

part of 'package:mobile_project/features/donor/widgets/donar_imports.dart';

class ShowDonorRequestDetails extends StatefulWidget {
  const ShowDonorRequestDetails({super.key, required this.request});
  final RequestModel request;

  @override
  State<ShowDonorRequestDetails> createState() =>
      _ShowDonorRequestDetailsState();
}

class _ShowDonorRequestDetailsState extends State<ShowDonorRequestDetails> {
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
                  onPressed: () async {
                    final userId =
                        Supabase.instance.client.auth.currentUser?.id;
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You must be logged in to save.'),
                        ),
                      );

                      return;
                    }

                    final savedDonationService = SavedDonationService();

                    try {
                      // ✅ Check if the request is already saved
                      final existing =
                          await Supabase.instance.client
                              .from('savedrequest')
                              .select()
                              .eq('donor_id', userId)
                              .eq('request_id', widget.request.id)
                              .maybeSingle();

                      if (existing != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You already saved this donation.'),
                          ),
                        );
                        Navigator.pop(context);
                        return;
                      }

                      // ✅ Save it
                      await savedDonationService.ensureDonorExists();
                      await savedDonationService.saveRequest(
                        userId,
                        widget.request.id,
                      );

                      if (!mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request saved to your donations!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save request: $e')),
                      );
                    }
                  },
                  child: const Text('Add to Donations'),
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
