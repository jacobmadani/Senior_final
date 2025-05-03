import 'package:flutter/material.dart';
import 'package:mobile_project/models/request.dart';
import 'package:mobile_project/widgets/request_card.dart';

class ResourceMapScreen extends StatefulWidget {
  const ResourceMapScreen({super.key});

  @override
  State<ResourceMapScreen> createState() => _ResourceMapScreenState();
}

class _ResourceMapScreenState extends State<ResourceMapScreen> {
  final List<Request> _requests = Request.mockRequests();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resource Map')),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Map view will appear here',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Requests by Location'),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _requests.length,
                        itemBuilder: (context, index) {
                          return RequestCard(
                            request: _requests[index],
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
