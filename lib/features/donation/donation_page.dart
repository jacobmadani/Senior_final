// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/donation.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/models/saved_request.dart';
import 'package:mobile_project/core/services/request_service.dart';
import 'package:mobile_project/core/services/save_request_service.dart';
import 'package:mobile_project/core/widgets/request_card.dart';
import 'package:mobile_project/features/donation/widget/save_donation_sheet.dart';
import 'package:mobile_project/features/donation/widget/show_donation_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedDonationPage extends StatefulWidget {
  const SavedDonationPage({super.key});

  @override
  State<SavedDonationPage> createState() => _SavedDonationPageState();
}

class _SavedDonationPageState extends State<SavedDonationPage> {
  final SavedDonationService _savedRequestService = SavedDonationService();
  bool isRefreshing = false;
  Future<void> refreshPage() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate refresh
    setState(() => isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final donorId = Supabase.instance.client.auth.currentUser?.id;

    if (donorId == null) {
      return const Center(
        child: Text('You must be logged in to see saved donations.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => isRefreshing = true);
        await Future.delayed(const Duration(seconds: 2));
        setState(() => isRefreshing = false);
      },
      child: StreamBuilder<List<SavedDonation>>(
        stream: _savedRequestService.getSavedRequestStream(donorId),
        builder: (context, snapshot) {
          if (isRefreshing || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final savedRequests = snapshot.data!;
          if (savedRequests.isEmpty) {
            return const Center(child: Text('No saved donations.'));
          }

          return ListView.builder(
            itemCount: savedRequests.length,
            itemBuilder: (context, index) {
              final saved = savedRequests[index];

              return FutureBuilder<RequestModel>(
                future: RequestService().getRequestById(saved.requestId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final request = snapshot.data!;
                  return RequestCard(
                    request: request,
                    onTap: () async {
                      final modalContext = context;

                      final donationRow =
                          await Supabase.instance.client
                              .from('donation')
                              .select()
                              .eq('donor_id', saved.donorId)
                              .eq('request_id', saved.requestId)
                              .limit(1)
                              .maybeSingle();

                      if (!mounted) return;

                      if (donationRow != null) {
                        final donatedAmount =
                            (donationRow['amountdonated'] as num).toDouble();

                        final donation = Donation(
                          id: donationRow['id'],
                          donorId: saved.donorId,
                          requestId: saved.requestId,
                          requestTitle: request.title,
                          amount: donatedAmount,
                          date: request.date,
                          status: request.status,
                          confirmationCode: request.confirmationCode,
                        );

                        await showModalBottomSheet(
                          context: modalContext,
                          isScrollControlled: true,
                          builder:
                              (_) => SavedDonationSheet(
                                donatedAmount: donation,
                                onRemove: () async {
                                  await Supabase.instance.client
                                      .from('savedrequest')
                                      .delete()
                                      .eq('donor_id', saved.donorId)
                                      .eq('request_id', saved.requestId);

                                  if (mounted) {
                                    setState(
                                      () {},
                                    ); // refresh UI after modal closes
                                  }
                                },
                              ),
                        );
                      } else {
                        final donation = Donation(
                          id: saved.id,
                          donorId: saved.donorId,
                          requestId: request.id,
                          requestTitle: request.title,
                          amount: 0.0,
                          date: request.date,
                          status: request.status,
                          confirmationCode: request.confirmationCode,
                        );
                        final deletedOrConfirmed = await showModalBottomSheet(
                          context: modalContext,
                          isScrollControlled: true,
                          builder:
                              (_) => ShowDonationDetails(
                                donation: donation,
                                enteredCode: '',
                                codeErrorMessage: null,
                                donationStatus: request.status,
                              ),
                        );

                        if (deletedOrConfirmed != null && mounted) {
                          await refreshPage(); // ✅ refresh after confirm OR delete
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
