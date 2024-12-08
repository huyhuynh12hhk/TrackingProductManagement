import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/result_model.dart';
import 'package:tracking_app_v1/services/product_service.dart';

class OriginSearchDialog extends StatefulWidget {
  final void Function(Product) onAddProduct;
  final List<Product> selectedOriginProducts;
  const OriginSearchDialog(
      {super.key,
      required this.onAddProduct,
      required this.selectedOriginProducts});

  @override
  State<OriginSearchDialog> createState() => _OriginSearchDialogState();
}

class _OriginSearchDialogState extends State<OriginSearchDialog> {
  final _searchController = TextEditingController();
  List<Product> _searchResult = [];
  bool onLoading = false;

  Product? _selectedProduct = null;

  Future<void> fetchProduct() async {
    onLoading = true;
    await Future.delayed(const Duration(milliseconds: 500));
    ResultModel<List<Product>>? rs;

    if (_searchController.text.isNotEmpty) {
      print("Search term ${_searchController.text}");
      rs = await searchProducts(_searchController.text);
    } else {
      _searchResult.clear();
    }

    if (rs != null && rs.isSuccess) {
      print("has ${rs.data!.length} results");
      print("Raw result: ${rs.data!.map((e) => e.toJson())}");
      _searchResult.clear();
      _searchResult.addAll(rs.data ?? []);
    }

    setState(() {
      onLoading = false;
    });
  }

  void onSelectProduct(Product product) {
    // print("Choose ${product.name}");

    if ((_selectedProduct?.id ?? "") == product.id) {
      _selectedProduct = null;
    } else {
      _selectedProduct = product;
    }
    setState(() {});
    // print("Result: ${product == _selectedProduct}");
  }

  void onConfirmSelect() {
    widget.onAddProduct(_selectedProduct!);
    Navigator.pop(context);
  }

  Widget _buildToolHeader() {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[400]!))),
          child: Text(
            "Find origin product here",
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );
  }

  Widget _buildSearchTool() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _searchController,
          onChanged: (value) => fetchProduct(),
          decoration: InputDecoration(
              hintText: "Input product or supplier name...",
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400])),
        )),
        const Icon(Icons.search)
      ],
    );
  }

  Widget _buildResultList() {
    final globalSize = MediaQuery.of(context).size;
    return Container(
      height: 250,
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _searchResult.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final product = _searchResult[index];

            return Container(
              height: 60,
              width: 200,
              // width: globalSize.width>300?300:globalSize.width,
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[500]!)),
              child: Row(
                children: [
                  //avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[900]!),
                        image: DecorationImage(
                            image: ((product.galleryPaths?.isNotEmpty ??
                                        false) &&
                                    product.galleryPaths![0].isNotEmpty)
                                ? NetworkImage(ApiEndpoints.getImagePath(
                                    product.galleryPaths?[0] ?? ""))
                                : const AssetImage('assets/images/product.png'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width:
                        globalSize.width / 100 < 2 ? 2 : globalSize.width / 100,
                  ),

                  //title
                  SizedBox(
                    width:
                        globalSize.width / 3 > 150 ? 150 : globalSize.width / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: globalSize.width,
                              child: Row(
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: globalSize.width,
                              child: Row(
                                children: [
                                  Text(
                                    "By:",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    product.supplier.fullName,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width:
                        globalSize.width / 30 > 20 ? 20 : globalSize.width / 30,
                  ),
                  // const Spacer(),
                  widget.selectedOriginProducts.any((p) => p.id == product.id)
                      ? Checkbox(
                          checkColor: Colors.grey[700],
                          value: true,
                          onChanged: null)
                      : Checkbox(
                          shape: const CircleBorder(),
                          activeColor: Colors.blue[600],
                          value: product.id == (_selectedProduct?.id ?? ""),
                          onChanged: (value) {
                            onSelectProduct(product);
                          },
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectReview() {
    return Column(
      children: [
        const DividerTitle(
            content: Text(
          "Review selected product",
          style: TextStyle(fontSize: 16),
        )),
        _selectedProduct == null
            ? Container(
                height: 120,
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: Text(
                    "Choose a product to show",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
              )
            : Container(
                height: 120,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[500]!)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[900]!),
                              image: DecorationImage(
                                  image: (_selectedProduct
                                                  ?.galleryPaths?.isNotEmpty ??
                                              false) &&
                                          _selectedProduct!
                                              .galleryPaths![0].isNotEmpty
                                      ? NetworkImage(ApiEndpoints.getImagePath(
                                          _selectedProduct!.galleryPaths![0]))
                                      : const AssetImage(
                                          'assets/images/product.png'),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),

                        //title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _selectedProduct!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              "${_selectedProduct!.price.toInt()} (VND)",
                              style: TextStyle(
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.green[800]),
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                  "By:",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _selectedProduct!.supplier.fullName,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedProduct!.description,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
        const Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(right: 15, left: 15, top: 10),
      actionsPadding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      title: null,
      content: SingleChildScrollView(
        child: Container(
          // margin: EdgeInsets.symmetric(
          //     horizontal: 20, vertical: globalSize.height / 5),
          width: globalSize.width,
          height: 550,
          // decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Find Product",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  //tool header
                  _buildToolHeader(),

                  //tool body
                  _buildSearchTool(),

                  const SizedBox(
                    height: 10,
                  ),
                  //result
                  _buildResultList(),
                  const SizedBox(
                    height: 5,
                  ),

                  //review
                  _buildSelectReview()
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white),
                onPressed: _selectedProduct == null
                    ? null
                    : () {
                        onConfirmSelect();
                      },
                child: const Text("Confirm")),
          ],
        ),
      ],
    );
  }
}
