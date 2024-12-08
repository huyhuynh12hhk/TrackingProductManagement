import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/notifications/show_notification_dialog.dart';
import 'package:tracking_app_v1/components/products/origin_search_dialog.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/pages/qr_scanner/qr_scanner_page.dart';

import 'package:tracking_app_v1/services/product_service.dart';

class ProductOriginField extends StatefulWidget {
  final void Function(Product) onAddOrigin;
  final void Function() onClearAll;

  final List<Product> originProducts;
  const ProductOriginField(
      {super.key,
      required this.onAddOrigin,
      required this.originProducts,
      required this.onClearAll});

  @override
  State<ProductOriginField> createState() => _ProductOriginFieldState();
}

class _ProductOriginFieldState extends State<ProductOriginField> {
  void _showAddOriginsModal() {
    showDialog(
        context: context,
        builder: (context) => OriginSearchDialog(
              selectedOriginProducts: widget.originProducts,
              onAddProduct: (value) => widget.onAddOrigin(value),
            ));
  }

  void onScanProduct() async {
    final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => const QrScannerPage(),
        ));

    if (result?.isNotEmpty ?? false) {
      print("fetch success");
      final data = await fetchProductDetail(result!);

      if (data.isSuccess) {
        if (!widget.originProducts.any((p) => p.id == data.data!.id)) {
          showNotificationMessage(context, "This product has already added.");
          return;
        } else {
          widget.onAddOrigin(data.data!);
        }
      }
    }
  }

  Widget _buildListOrigins(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.originProducts.length,
      itemBuilder: (context, index) {
        final item = widget.originProducts[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[500]!),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200]),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[900]!),
                    image: DecorationImage(
                        image: ((item.galleryPaths?.isNotEmpty ?? false) &&
                                item.galleryPaths![0].isNotEmpty)
                            ? NetworkImage(ApiEndpoints.getImagePath(
                                item.galleryPaths?[0] ?? ""))
                            : const AssetImage('assets/images/product.png'),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Text(
                      item.name
                      // + " There are many variations of passages of Lorem Ipsum available."
                      ,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(height: 4,),
                    //description
                    Text(
                      "${item.price.toInt()} (VND)",
                      style: TextStyle(fontSize: 13, color: Colors.green[700]),
                    ),

                    Row(
                      children: [
                        const Text(
                          "By:",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          item.supplier.fullName,
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ],
                    ),

                    Expanded(
                      child: Text(
                        item.name +
                            " There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(width: 10,)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          //tool button
          SizedBox(
            height: 50,
            // width: globalSize.width,
            // width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: globalSize.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //add button
                                Expanded(
                                  // width: 90,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent.shade700,
                                          foregroundColor: Colors.grey[900]),
                                      onPressed: () {
                                        _showAddOriginsModal();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Add ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          
                                          Icon(
                                            Icons.add,
                                            size: 17,
                                            color: Colors.grey[800],
                                          )
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                            
                                //scan button
                                Expanded(
                                  // width: 90,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlue[400],
                                          foregroundColor: Colors.grey[900]),
                                      onPressed: () {
                                        onScanProduct();
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Scan ",
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                                Icon(
                                                  Icons.qr_code_2,
                                                  size: 17,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[400],
                                          foregroundColor: Colors.grey[900]),
                                      onPressed: () {
                                        widget.onClearAll();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Clear ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Icon(
                                            Icons.delete,
                                            size: 17,
                                            color: Colors.grey[900],
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //list
          widget.originProducts.isNotEmpty
              ? _buildListOrigins(context)
              : Container(
                  height: 100,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Divider()),
                      Text(
                        "Nothing to display",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
