import 'package:flutter/material.dart';
import 'package:mobile_project/models/donation.dart';
import 'package:mobile_project/models/request.dart';

class AdminHomeScreen extends StatelessWidget {
  final List<Request> requests;
  final List<Donation> donations;

  const AdminHomeScreen({
    super.key,
    required this.requests,
    required this.donations,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Requests'), Tab(text: 'Donations')],
          ),
        ),
        body: TabBarView(children: [_buildRequestList(), _buildDonationList()]),
      ),
    );
  }

  Widget _buildRequestList() {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Recipient: ${req.recipientName}'),
                Text('Phone: ${req.recipientPhone}'),
                Text('Description: ${req.description}'),
                Text('Category: ${req.category}'),
                Text('Urgency: ${req.urgency}'),
                Text('Location: ${req.location}'),
                Text('Date: ${req.date.toLocal().toString().split(' ')[0]}'),
                Text('Status: ${req.status}'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                'Are you sure you want to delete this request?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    requests.removeAt(index);
                                    (context as Element)
                                        .reassemble(); // refresh UI
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationList() {
    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final don = donations[index];
        return ListTile(
          title: Text(
            don.requestTitle.isNotEmpty ? don.requestTitle : 'General Donation',
          ),
          subtitle: Text('${don.status} • ${don.date}'),
        );
      },
    );
  }
}
