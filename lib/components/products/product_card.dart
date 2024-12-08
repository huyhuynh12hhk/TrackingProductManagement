import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/products/show_product_detail.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
            onTap: () {
              showProductDetail(context, widget.product);
            },
            onHover: (value) {
              setState(() {
                _isHover = value;
                print("on hover");
              });
            },
            child: Container(
              height: MediaQuery.sizeOf(context).height / 5,
              width: MediaQuery.sizeOf(context).height / 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey),
                  color: Colors.black,
                  image: DecorationImage(
                    image: (widget.product.avatarImage.isEmpty
                        ? const AssetImage('assets/images/product.png')
                        : NetworkImage(ApiEndpoints.getImagePath(widget.product.avatarImage))),
                    colorFilter: const ColorFilter.mode(
                        Colors.black54, BlendMode.darken),
                    fit: BoxFit.cover,
                  )),
            )),
        // AnimatedContainer(
        //   height: 70,
        //   duration: Duration(milliseconds: 200),
        //   padding: EdgeInsets.only(
        //       top: (isHover) ? 25 : 30.0, bottom: !(isHover) ? 25 : 30),
        //   child:
        Positioned(
          bottom: 1,
          child: Container(
            width: MediaQuery.sizeOf(context).height / 5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.grey.withOpacity(.5),
            child: Center(
              child: Text(
                widget.product.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        // )
      ],
      // ),
    );
  }
}
