import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/search_result.dart';
import 'package:tracking_app_v1/pages/common/home_page.dart';
import 'package:tracking_app_v1/pages/common/search_result_page.dart';
import 'package:tracking_app_v1/pages/qr_scanner/qr_scanner_page.dart';
import 'package:tracking_app_v1/pages/qr_scanner/qr_scanner_v2_page.dart';
import 'package:tracking_app_v1/pages/qr_scanner/qr_scanner_v3_page.dart';
import 'package:tracking_app_v1/services/search_service.dart';

//https://stackoverflow.com/questions/58177759/what-is-the-use-of-preferredsize-widget-in-flutter
class CustomSearchBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final List<SearchResult> _searchResults = [];
  // List<String> _filteredData = [];
  bool _isLoading = false;
  Timer? _debounce;
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    // _filteredData = _searchResults;
    _searchController.addListener(_onSearching);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onSearching() async {
    setState(() {
      _searchResults.clear();
      _isLoading = true;
      _searchTerm = _searchController.text;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    print("Start searching keyword \"${_searchController.text}\".");
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_searchTerm.isNotEmpty) {
        searchAll(_searchTerm).then((result) {
          // Handle the fetched data (e.g., update the UI)
          if (result.isSuccess) {
            print("Fetched ${result.data!.length} Results");
            print("Searching complete");

            setState(() {
              _searchResults.addAll(result.data!);
              // _filteredData = _searchResults
              //     .where((element) => element
              //         .toLowerCase()
              //         .contains(_searchController.text.toLowerCase()))
              //     .toList();
              _isLoading = false;
            });
          }
        });
      }
    });
    //Simulates waiting for an API call
    // await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    var globaleSize = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
              onPressed: () async {
                print("Start to scan qr code");
                // await Navigator.push(context, MaterialPageRoute(builder: (context) => QrScannerPage(),));
                // await Navigator.push(context, MaterialPageRoute(builder: (context) => QrScannerV2Page(),));
                await Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerV3Page(),));
                // final rs = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => QrScannerPage(),
                //     ));
              },
              icon: Icon(
                Icons.qr_code_scanner,
                size: 25,
                color: Colors.grey.shade300,
              )),
        )
      ],
      title: Column(
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(vertical: 10),
            // margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownMenu<SearchResult>(
                      onSelected: (value) {
                        _searchController.clear();
                        if (value != null) {
                          print('Selected ${value.type} ${value.key}');
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => value.navigateTo(),
                              ));
                        }
                      },
                      selectedTrailingIcon: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(1),
                              // alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: const Icon(
                                Icons.clear,
                                size: 14,
                              ))),
                      enableSearch: true,
                      requestFocusOnTap: true,
                      enableFilter: false,
                      textStyle: const TextStyle(fontSize: 16),
                      width: globaleSize.width / 3 * 2,
                      // trailingIcon: Icon(Icons.search),
                      trailingIcon: Visibility(
                          visible: false, child: Icon(Icons.arrow_downward)),
                      hintText: "Search something here...",
                      inputDecorationTheme: InputDecorationTheme(
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          isDense: true,
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(40)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: _searchController,
                      menuHeight: _searchResults.isEmpty ? 0 : null,
                      dropdownMenuEntries: (_searchResults.take(5).map(
                        (e) {
                          return DropdownMenuEntry<SearchResult>(
                              leadingIcon: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: e.imagePath.isNotEmpty
                                            ? NetworkImage(
                                                ApiEndpoints.getImagePath(
                                                    e.imagePath))
                                            : AssetImage(
                                                'assets/images/product.png'),
                                        fit: BoxFit.cover)),
                              ),
                              value: e,
                              label: e.label);
                        },
                      ).toList())),
                ),
                IconButton(
                    onPressed: () async {
                      print("Search...");
                      // await _onSearching();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultPage(
                                searchKey: _searchController.text,
                                initValues: _searchResults),
                          ));
                      // _searchController.clear();
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 20,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
