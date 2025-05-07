// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/models/donation_model.dart';
import 'package:mobile_project/core/widgets/donation_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  List<DonationModel> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final donorId = Supabase.instance.client.auth.currentUser?.id;
      if (donorId == null) throw Exception('Not logged in');

      final response = await Supabase.instance.client
          .from('donation')
          .select()
          .eq('donorId', donorId);

      if (response == null || response is! List) {
        setState(() {
          _donations = [];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _donations =
            response
                .map((item) => DonationModel.fromMap(item))
                .toList()
                .cast<DonationModel>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load donations: $e')));
    }
  }

  void _showDonationDetails(DonationModel donation) {
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
                  'Request Title: ${donation.requestTitle}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Amount: \$${donation.amount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Status: ${donation.status}'),
                const SizedBox(height: 8),
                Text('Message: ${donation.message ?? 'No message'}'),
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
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return _donations.isEmpty
        ? const Center(child: Text('No donations yet'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _donations.length,
          itemBuilder: (context, index) {
            return DonationCard(
              donation: _donations[index],
              onTap: () => _showDonationDetails(_donations[index]),
            );
          },
        );
  }
}
