part of 'package:mobile_project/features/donor/widgets/donar_imports.dart';

class DonorPageBody extends StatefulWidget {
  const DonorPageBody({super.key});

  @override
  State<DonorPageBody> createState() => _DonorPageBodyState();
}

class _DonorPageBodyState extends State<DonorPageBody> {
  String enteredCode = '';
  String? codeErrorMessage;
  int currentIndex = 0;
  bool isrefreshing = false;
  final RequestService requestService = RequestService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Requests'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final snapshot = await requestService.getRequestStream().first;

              if (context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchRequestScreen(requests: snapshot),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isrefreshing = true;
          });
          await Future.delayed(const Duration(seconds: 3));
          await requestService.refreshRequests();
          setState(() {
            isrefreshing = false;
          });
        },
        child: StreamBuilder(
          stream: requestService.getRequestStream(),
          builder: (context, snapshot) {
            if (isrefreshing ||
                (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No requests found.'));
            }

            final requests = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  request: requests[index],
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return ShowDonorRequestDetails(
                          request: requests[index],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
