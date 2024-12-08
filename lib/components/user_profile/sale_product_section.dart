import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/components/products/product_card.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/pages/products/add_product_page.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/services/product_service.dart';

class SaleProductSection extends StatefulWidget {
  final String userId;
  const SaleProductSection({super.key, required this.userId});

  @override
  State<SaleProductSection> createState() => _SaleProductSectionState();
}

class _SaleProductSectionState extends State<SaleProductSection> {
  final List<Product> _products = [];

  Future<bool?> fetchUserProducts() async {
    print("SupplierId is: ${widget.userId}");
    try {
      var result = await getProductsBySupplier(widget.userId);

      // print("Done!");

      if (result.isSuccess) {
        _products.clear();
        _products.addAll(result.data!);
        // setState(() {});
      } else {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Widget _buildOwnerSection(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return Column(
      children: [
        DividerTitle(
            content: Text(
          "Manage Tools",
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 18),
        )),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(
                    onCallBack: () async {
                      print("Start to fetch again");
                      // await Future.delayed(Duration(milliseconds: 500));

                      await fetchUserProducts();
                      setState(() {});

                      print("fetch completed");
                    },
                  ),
                ));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            width: globalSize.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.teal[300]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add more",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[200]),
                ),
                Icon(Icons.add, color: Colors.grey[200])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return MasonryGridView.builder(
      padding: EdgeInsets.only(bottom: 30),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (context, index) {
        // var product = Product(
        //     id: "1321313$index",
        //     name: "Name product ${index + 1}",
        //     description: "description",
        //     price: 300,
        //     image: "assets/images/test/${index + 1}.png",
        //     supplier: currentUser != null
        //         ? UserProfile.fromCurrentUser(currentUser)
        //         : UserProfile.empty());

        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductCard(product: products[index]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    final currentUser =
        Provider.of<AuthStateProvider>(context, listen: false).currentUser;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //manage product
            if (widget.userId == currentUser?.id) _buildOwnerSection(context),

            //products view
            DividerTitle(
                content: Text("Sale Products",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),

            const SizedBox(
              height: 10,
            ),

            FutureBuilder(
                future: fetchUserProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Skeletonizer(
                        enabled: !snapshot.hasData,
                        child: _buildProductGrid(context,
                            List<Product>.generate(4, (e) => Product.empty())));
                  } else {
                    return _products.isNotEmpty
                        ? _buildProductGrid(context, _products)
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: globalSize.width,
                            height: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Expanded(child: Divider()),
                                Text(
                                  "No product added.",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                                // Expanded(child: Divider()),
                              ],
                            ),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
