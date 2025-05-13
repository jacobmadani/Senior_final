// import 'package:country_flags/country_flags.dart';
// import 'package:flutter/material.dart';
// import 'package:jemle_app/core/constants/app_pallet.dart';
// import 'package:jemle_app/core/widgets/phone/model/country_phone_numbers.dart';
// import 'package:jemle_app/core/widgets/phone/model/load_country_phone_number.dart';
// import 'package:mobile_project/core/models/request.dart';
// import 'package:mobile_project/core/models/request_model.dart';
// import 'package:mobile_project/core/utils/constants.dart';

// class Search extends StatefulWidget {
//   const Search({super.key, required this.selectedrequest});
//   final Request selectedrequest;

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   List<Request> request = [];
//   List<Request> filteredrequests = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//     filteredrequests = request;
//   }

//   void _loadData() async {
//     List<Request> requests = await loadCountryPhoneNumber();
//     setState(() {
//       request = requests;
//       filteredrequests = request;
//     });
//   }

//   void _runFilter(String enteredkey) {
//     List<Request> results = [];
//     if (enteredkey.isEmpty) {
//       results = request;
//     } else {
//       results =
//           request
//               .where(
//                 (user) =>
//                     user.title.toLowerCase().contains(enteredkey.toLowerCase()),
//               )
//               .toList();
//     }
//     setState(() {
//       filteredrequests = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: AppColors.background,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               onChanged: (value) => _runFilter(value),
//               decoration: InputDecoration(
//                 focusColor: AppColors.accent,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.accent, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: 'Search',
//                 prefixIcon: const Icon(Icons.search),
//               ),
//               cursorColor: AppColors.accent,
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         Expanded(
//           child:
//               filteredrequests.isNotEmpty
//                   ? ListView.builder(
//                     itemBuilder:
//                         (context, index) => ListTile(
//                           onTap: () {
//                             var country = filteredrequests[index];
//                             setState(() {});
//                             Navigator.pop(context, selectedCountry1);
//                           },
//                           leading: CountryFlag.fromCountryCode(
//                             filteredCountries[index].countrycode,
//                             shape: Circle(),
//                           ),
//                           title: Text(filteredrequests[index].title),
//                           subtitle: Text(filteredC[index].callingcode),
//                         ),
//                     itemCount: filteredCountries.length,
//                   )
//                   : Center(child: Text('No result Found')),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/widgets/request_card.dart';
import 'package:mobile_project/features/recipient/show_request_details.dart';

class SearchRequestScreen extends StatefulWidget {
  final List<RequestModel> requests;

  const SearchRequestScreen({super.key, required this.requests});

  @override
  State<SearchRequestScreen> createState() => _SearchRequestScreenState();
}

class _SearchRequestScreenState extends State<SearchRequestScreen> {
  List<RequestModel> filteredRequests = [];

  @override
  void initState() {
    super.initState();
    filteredRequests = widget.requests;
  }

  void _runFilter(String keyword) {
    final results =
        keyword.isEmpty
            ? widget.requests
            : widget.requests
                .where(
                  (req) =>
                      req.title.toLowerCase().contains(keyword.toLowerCase()),
                )
                .toList();

    setState(() => filteredRequests = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Requests')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child:
                filteredRequests.isEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                      itemCount: filteredRequests.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final req = filteredRequests[index];
                        return RequestCard(
                          request: req,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => ShowRequestDetails(request: req),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
