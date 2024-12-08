import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/custom_drawer.dart';
import 'package:tracking_app_v1/components/common/custom_search_bar.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/search_result.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKey;
  final List<SearchResult> initValues;
  const SearchResultPage({super.key, required this.initValues, required this.searchKey});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final List<SearchResult> _results = [];

  @override
  void initState() {
    _results.addAll(widget.initValues);
    super.initState();
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "${_results.length} result${_results.length > 1 ? "s" : ""} for \"${widget.searchKey}\" was found.",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Row(
          children: [Expanded(child: Divider())],
        )
      ],
    );
  }

  Widget _buildListResults(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];

        return GestureDetector(
          onTap: () {
            print("Go to ${item.type} ${item.label}");
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => item.navigateTo(),
                ));
          },
          child: Container(
            width: globalSize.width,
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300]),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[500]!, width: 1),
                      image: DecorationImage(
                          image: item.imagePath.isNotEmpty
                              ? NetworkImage(
                                  ApiEndpoints.getImagePath(item.imagePath))
                              : AssetImage('assets/images/product.png'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  item.label,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [_buildTitle(context), _buildListResults(context)],
          ),
        ),
      ),
    );
  }
}
