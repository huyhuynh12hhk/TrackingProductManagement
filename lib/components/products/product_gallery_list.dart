import 'package:flutter/material.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';

class ProductGalleryList extends StatefulWidget {
  final String ownerId;
  final List<String> images;
  const ProductGalleryList(
      {super.key, required this.images, required this.ownerId});

  @override
  State<ProductGalleryList> createState() => _ProductGalleryListState();
}

class _ProductGalleryListState extends State<ProductGalleryList> {
  List<Widget> _buildListImage(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return widget.images.take(5).map((image) {
      return Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(5),
          width: globalSize.width / 4,
          height: globalSize.width / 4,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[400],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image.isNotEmpty
                  ? NetworkImage(
                      ApiEndpoints.getImagePath(image))
                  : const AssetImage('assets/images/product.png')
            )
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return Container(
      height: globalSize.width / 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.black))),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildListImage(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
