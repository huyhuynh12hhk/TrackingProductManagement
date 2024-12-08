import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app_v1/components/common/custom_drawer.dart';
import 'package:tracking_app_v1/components/common/custom_search_bar.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/components/document_view/expandable_document.dart';
import 'package:tracking_app_v1/components/images/show_image_popup.dart';
import 'package:tracking_app_v1/components/products/editable_gallery.dart';
import 'package:tracking_app_v1/components/products/product_edit_info_modal.dart';
import 'package:tracking_app_v1/components/products/product_gallery_list.dart';
import 'package:tracking_app_v1/components/products/show_product_detail.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/image_source.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/pages/common/not_found.dart';
import 'package:tracking_app_v1/services/media_service.dart';
import 'package:tracking_app_v1/services/product_service.dart';
import 'package:tracking_app_v1/utils/app_coverter.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final bool editable;

  const ProductDetailPage(
      {super.key, required this.productId, this.editable = false});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product _product = Product.empty();
  late Future<bool> _isLoaded;
  bool _isModifying = false;
  Product _oldStateProduct = Product.empty();

  Future<bool?> _fetchProduct() async {
    try {
      final rs = await fetchProductDetail(widget.productId);

      if (rs.isSuccess) {
        // print("Gotta product ${json.encode(rs.data)}");
        _product = rs.data!;
      } else {
        throw Exception("Product not found.");
      }
    } catch (e) {
      print("View Product Error: $e");
      return false;
    }

    setState(() {});

    return true;
  }

  @override
  void initState() {
    super.initState();
    //pre-check some scope here (if any)

    print("Start to fetch product (id: ${widget.productId})..");
    //fetch product

    _fetchProduct();

    // _editable = widget.editable;
    _isLoaded = Future.value(true);
    setState(() {});
    // print("????State change, loaded = ${_isLoaded}");
  }

  void _onChangeInfo(Product product) {
    _product = Product.cloneFrom(product);
    setState(() {});
  }

  Widget _buildAvatar(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;

    var avtPath = _product.galleryPaths?.isNotEmpty ?? false
        ? _product.galleryPaths![0]
        : "";

    return GestureDetector(
      onTap: avtPath.isEmpty
          ? null
          : () {
              showImagePopup(
                  context, _product.name, _product.supplier.id, avtPath);
            },
      child: Container(
        width: globalSize.width / 2 + 50,
        height: globalSize.width / 2 + 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
            // color: Colors.black,
            image: DecorationImage(
                image: avtPath.isNotEmpty
                    ? NetworkImage(ApiEndpoints.getImagePath(avtPath))
                    : const AssetImage("assets/images/product.png"),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildProviderTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5, top: 3, bottom: 3),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (!_product.supplier.isEmpty() &&
                          _product.supplier.avatarImage.isNotEmpty)
                      ? NetworkImage(ApiEndpoints.getImagePath(
                          _product.supplier.avatarImage))
                      : const AssetImage("assets/images/avatar.png"))),
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 10),
        horizontalTitleGap: 30,
        title: Text(
          _product.supplier.fullName
          // + " dsadas sdsad qrqwe  21313 12213 wqeq daas"
          ,
          maxLines: 2,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_right,
                  size: 40,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, bool isLoading) {
    var globalSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Skeletonizer(
              enabled: isLoading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                  if(!isLoading && _product.discount != 0)
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        convertPrice(_product.price),
                        style: TextStyle(
                            color: Colors.redAccent.shade700,
                            decoration: TextDecoration.lineThrough),
                      )),
                  if (!isLoading)
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          convertPrice(
                              _product.price * (1 - _product.discount)),
                          style: TextStyle(
                            color: Colors.lightGreenAccent.shade100,
                            // decoration: TextDecoration.lineThrough
                          ),
                        )),
                  SizedBox(
                    width: globalSize.width / 30,
                  )
                ],
              ),
            ),
          ),
          DividerTitle(
              content: Text(
            "Description",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            // height: 60,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: ExpandableDocument(
              content: _product.description.isNotEmpty
                  ? _product.description
                  : "Not set",
            ),
          ),
          DividerTitle(
              content: Text(
            "Provider",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
          )),
          _buildProviderTile(context)
        ],
      ),
    );
  }

  Widget _buildOriginDetailSection(BuildContext context, bool isLoading) {
    // print("Orign size ${_product.originProducts?.length ?? 0}");
    // print("Media ${_product.galleryPaths}");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DividerTitle(
            content: Text(
          "Origin product",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
        )),
        (_product.originProducts?.isNotEmpty ?? false)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _product.originProducts?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = _product.originProducts![index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productId: item.id),
                          ));
                    },
                    child: Container(
                      height: 100,
                      width: 300,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (item.galleryPaths?.isNotEmpty ??
                                                false) &&
                                            item.galleryPaths![0].isNotEmpty
                                        ? NetworkImage(
                                            ApiEndpoints.getImagePath(
                                                item.galleryPaths![0]))
                                        : const AssetImage(
                                            "assets/images/product.png"))),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  convertPrice(item.price),
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.green[800]),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "By ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    item.supplier.fullName,
                                    style: TextStyle(
                                        color: Colors.blue[600], fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.blue[500],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        "No origin product added.",
                        style: TextStyle(color: Colors.grey[400], fontSize: 20),
                      ),
                    ),
                  ),
                  Divider()
                ],
              )
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, List<String> galleryPaths, bool onLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            //avatar
            _buildAvatar(context),

            EditableGallery(
                modifiable: _isModifying,
                ownerId: _product.supplier.id,
                initImages: galleryPaths,
                onAddFile: (value) {},
                onRemoveFile: (value) {},
                onClearAll: () {}),

            _buildInfoSection(context, onLoading),

            const SizedBox(
              height: 10,
            ),

            _buildOriginDetailSection(context, onLoading),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomSearchBar(),
        drawer: CustomDrawer(),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _isModifying
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ProductEditInfoModal(
                        onConfirm: _onChangeInfo,
                        product: _product,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Edit info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.edit_document,
                        size: 18,
                        color: Colors.blue[900],
                      )
                    ],
                  ))
              : null,
        ),
        floatingActionButton: widget.editable
            ? (_isModifying
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          heroTag: 1,
                          shape: CircleBorder(),
                          backgroundColor: Colors.red.shade400,
                          onPressed: () {
                            _isModifying = false;
                            _product = Product.cloneFrom(_oldStateProduct);
                            _oldStateProduct = Product.empty();
                            setState(() {});
                          },
                          child: Icon(Icons.close)),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                          heroTag: 2,
                          shape: CircleBorder(),
                          backgroundColor: Colors.green[400],
                          onPressed: () {
                            //submit
                            print("On Submitting...");

                            _isModifying = false;
                            setState(() {});
                          },
                          child: Icon(Icons.check))
                    ],
                  )
                : FloatingActionButton(
                    heroTag: 3,
                    shape: CircleBorder(),
                    backgroundColor: Colors.blue[300],
                    onPressed: () {
                      _isModifying = true;
                      _oldStateProduct = Product.cloneFrom(_product);

                      setState(() {});
                    },
                    child: Icon(_isModifying ? Icons.check : Icons.edit)))
            : null,
        body: FutureBuilder(
            future: _isLoaded,
            builder: (context, snapshot) {
              final onLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Skeletonizer(
                        enabled: onLoading,
                        child: _buildBody(
                            context, _product.galleryPaths ?? [], onLoading)));
              }
              // By default, show a loading spinner.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "On loading...",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const CircularProgressIndicator()
                  ],
                ),
              );
            }));
  }
}
