import 'package:flutter/material.dart';
import 'package:mobile_project/core/constants.dart';
import 'package:mobile_project/core/routes.dart';
import 'package:mobile_project/models/donation.dart';
import 'package:mobile_project/models/request.dart';
import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/widgets/request_card.dart';
import 'package:mobile_project/widgets/donation_card.dart';

class DonorHomeController {
  final List<Request> _requests;
  final List<Donation> _donations;

  DonorHomeController({
    required List<Request> requests,
    required List<Donation> donations,
  }) : _requests = requests,
       _donations = donations;

  List<Request> get activeRequests =>
      _requests.where((r) => r.status != 'Fulfilled').toList();
  List<Donation> get allDonations => _donations;

  void fulfillRequest(Request request, Donation donation) {
    request.status = 'Fulfilled';
    _donations.add(donation);
  }
}

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  String _enteredCode = '';
  String? _codeErrorMessage;
  int _currentIndex = 0;
  final List<Request> _requests = Request.mockRequests();
  final List<Donation> _donations = Donation.mockDonations();
  final User _currentUser = User(
    id: '',
    name: '',
    email: '',
    phone: '',
    address: '',
    avatarUrl: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.resourceMap);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              return RequestCard(
                request: _requests[index],
                onTap: () {
                  _showRequestDetails(_requests[index]);
                },
              );
            },
          ),

          _buildDonationsTab(),

          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Requests'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donations',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  _showCreateDonationDialog();
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildDonationsTab() {
    return _donations.isEmpty
        ? const Center(child: Text('No donations yet'))
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _donations.length,
          itemBuilder: (context, index) {
            return DonationCard(
              donation: _donations[index],
              onTap: () {
                _showDonationDetails(_donations[index]);
              },
            );
          },
        );
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_currentUser.avatarUrl),
          ),
          const SizedBox(height: 16),
          Text(
            _currentUser.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            _currentUser.email,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildProfileInfoItem(Icons.person, _currentUser.name),
          _buildProfileInfoItem(Icons.email, _currentUser.email),
          _buildProfileInfoItem(Icons.phone, _currentUser.phone),
          _buildProfileInfoItem(Icons.home, _currentUser.address),
          _buildProfileInfoItem(Icons.badge, _currentUser.id),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Log Out'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Contact Us'),
                          content: const Text(
                            'For support, email us at:\nsupport@unitedhope.org\n\nOr call: +961-71-123456',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.contact_support),
                label: const Text('Contact Us'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Request request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                request.title,
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
                'Category: ${request.category}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Urgency: ${request.urgency}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Location: ${request.location}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(request.description),
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
                          date: DateTime.now().toIso8601String(),
                          status: 'Pending',
                          message: null,
                        );

                        setState(() {
                          request.status = 'Fulfilled';
                          _donations.add(donation);
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
      },
    );
  }

  void _showCreateDonationDialog({Request? request}) async {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController itemsController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            request == null
                ? 'Create New Donation'
                : 'Donate to ${request.title}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (USD)',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: itemsController,
                decoration: const InputDecoration(
                  labelText: 'Items (comma separated)',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message (optional)',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newDonation = Donation(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  requestTitle: request?.title ?? 'General Donation',
                  amount: double.tryParse(amountController.text) ?? 0,
                  items: itemsController.text.split(','),
                  date: DateTime.now().toIso8601String(),
                  status: 'Pending',
                  message:
                      messageController.text.isNotEmpty
                          ? messageController.text
                          : null,
                );
                if (request != null) {
                  setState(() {
                    request.status = 'Fulfilled';
                    _donations.add(newDonation);
                  });
                } else {
                  setState(() => _donations.add(newDonation));
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      request != null
                          ? 'Thank you for fulfilling the request!'
                          : 'General donation submitted!',
                    ),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showDonationDetails(Donation donation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Donation to: ${donation.requestTitle}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildDonationDetailItem('Recipient Name', 'John Doe'),
              _buildDonationDetailItem('Phone number', '+961-70123456'),
              _buildDonationDetailItem('Location', 'Beirut, Lebanon'),
              _buildDonationDetailItem('Amount', '\$${donation.amount}'),
              _buildDonationDetailItem('Items', donation.items.join(', ')),
              _buildDonationDetailItem('Date', donation.date),
              _buildDonationDetailItem('Status', donation.status),
              const SizedBox(height: 16),
              Text(
                'Message:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(donation.message ?? 'No message'),
              if (donation.status == 'Pending') ...[
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter the code',
                    border: OutlineInputBorder(),
                    errorText: _codeErrorMessage,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredCode = value;
                      _codeErrorMessage = null; // Clear error on new input
                    });
                  },
                ),
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (donation.status == 'Pending')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_enteredCode == '1234') {
                              donation.status = 'Delivered';
                              _codeErrorMessage = null;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Donation was done!'),
                                ),
                              );
                            } else {
                              _codeErrorMessage = 'Incorrect code';
                            }
                          });
                        },
                        child: const Text('Donate'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textLight),
          const SizedBox(width: 16),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDonationDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
