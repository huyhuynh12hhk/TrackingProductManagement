import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/notifications/show_notification_dialog.dart';
import 'package:tracking_app_v1/components/qr_code/show_qr_code.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/pages/products/product_detail_page.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/services/product_service.dart';

void showProductDetail(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: ProductDetailView(
        product: product,
      ),
    ),
  );
}

class ProductDetailView extends StatefulWidget {
  final Product product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  Widget _buildNameSection(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;

    return Container(
      width: globalSize.width - 20,
      padding: const EdgeInsets.only(right: 10.0, left: 10, top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              // textAlign: TextAlign.center,
              // wrapWords: true,
              overflow: TextOverflow.ellipsis,
              softWrap: true,

              maxLines: 3,
              widget.product.name
              // +" sdada asdsadad dsdada daddas sadsad"
              ,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: MediaQuery.sizeOf(context).height / 3,
      // width: MediaQuery.sizeOf(context).height / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
          color: Colors.black,
          image: DecorationImage(
            image: (widget.product.avatarImage.isEmpty
                ? const AssetImage('assets/images/product.png')
                : NetworkImage(
                    ApiEndpoints.getImagePath(widget.product.avatarImage))),
            // colorFilter:
            //     const ColorFilter.mode(Colors.black54, BlendMode.darken),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildToolButton(
      {required Icon icon, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildToolbarSection(BuildContext context) {
    final user =
        Provider.of<AuthStateProvider>(context, listen: false).currentUser;

    bool isEditable = widget.product.supplier.id == (user?.id ?? "");
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildToolButton(
          icon: Icon(
            Icons.share,
            color: Colors.amber.shade400,
          ),
          onPressed: () {
            showOnMaintainFeature(context);
          },
        ),
        _buildToolButton(
          icon: Icon(
            Icons.find_in_page,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productId: widget.product.id,
                    editable: isEditable,
                  ),
                ));
          },
        ),
        _buildToolButton(
          icon: Icon(
            Icons.add_shopping_cart,
            color: Colors.deepOrange.shade300,
          ),
          onPressed: () {
            showOnMaintainFeature(context);
          },
        ),
        _buildToolButton(
          icon: Icon(Icons.qr_code),
          onPressed: () {
            showQRCode(context, "product${widget.product.id}");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: Colors.tealAccent.shade400,
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNameSection(context),
            SizedBox(
              height: 30,
            ),
            //image
            _buildImageSection(),
            SizedBox(
              height: 10,
            ),

            //tools section
            _buildToolbarSection(context)
          ],
        ),
      ),
    );
  }
}
