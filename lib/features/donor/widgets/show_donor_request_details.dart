part of 'package:mobile_project/features/donor/widgets/donar_imports.dart';

class ShowDonorRequestDetails extends StatefulWidget {
  const ShowDonorRequestDetails({super.key, required this.request});
  final RequestModel request;

  @override
  State<ShowDonorRequestDetails> createState() =>
      _ShowDonorRequestDetailsState();
}

class _ShowDonorRequestDetailsState extends State<ShowDonorRequestDetails> {
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
            'Recipient Name: John Doe',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Recipient Phone: +961-70123456',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Area: Beirut, Lebanon',
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
                    final donation = Donation(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      requestTitle: '',
                      amount: 0,
                      items: ['Auto-added'],
                      date: DateTime.now(),
                      status: 'Pending',
                      message: null,
                    );

                    setState(() {
                      widget.request.status = 'Fulfilled';
                      // _donations.add(donation);
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Donation added successfully!'),
                      ),
                    );
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
