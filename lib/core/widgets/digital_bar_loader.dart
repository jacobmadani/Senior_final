import 'package:flutter/material.dart';

class DigitalBarLoader extends StatefulWidget {
  const DigitalBarLoader({super.key});

  @override
  State<DigitalBarLoader> createState() => _DigitalBarLoaderState();
}

class _DigitalBarLoaderState extends State<DigitalBarLoader> {
  final double goalAmount = 1000.0;
  double donatedAmount = 0.0;

  final int totalBlocks = 20;

  void addDonation(double amount) {
    setState(() {
      donatedAmount += amount;
      if (donatedAmount > goalAmount) donatedAmount = goalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = donatedAmount / goalAmount;
    int filledBlocks = (progress * totalBlocks).floor();
    int percentage = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: Text("Donation Progress")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Donated: \$${donatedAmount.toStringAsFixed(2)} / \$${goalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(totalBlocks, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    width: 20,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          index < filledBlocks
                              ? Colors.green
                              : Colors.grey[300],
                      border: Border.all(color: Colors.black),
                    ),
                  );
                }),
              ),
              SizedBox(height: 10),
              Text('$percentage%', style: TextStyle(fontSize: 24)),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => addDonation(10), // Simulate $10 donation
                child: Text("Donate \$10"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => addDonation(50), // Simulate $50 donation
                child: Text("Donate \$50"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
