import 'package:flutter/material.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';

showImagePopup(BuildContext context, String title, String ownerId, String uri) {
  final globalSize = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: globalSize.width,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[600]!),
              image: DecorationImage(
                image: uri.isNotEmpty?
                NetworkImage(ApiEndpoints.getImagePath(uri))
                :const AssetImage("assets/images/product.png"),
                fit: BoxFit.contain
              ),
              
            ),
          )
        ],
      ),
    ),
  );
}
