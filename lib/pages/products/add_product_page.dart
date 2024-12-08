import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/common/custom_form_textfield.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/components/images/show_image_picker.dart';
import 'package:tracking_app_v1/components/notifications/show_notification_dialog.dart';
import 'package:tracking_app_v1/components/products/editable_gallery.dart';
import 'package:tracking_app_v1/components/products/product_origin_field.dart';
import 'package:tracking_app_v1/models/image_source.dart';
import 'package:tracking_app_v1/models/requestTypes/add_product_model.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/pages/common/image_selector_page.dart';

import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/services/media_service.dart';
import 'package:tracking_app_v1/services/product_service.dart';
import 'package:tracking_app_v1/utils/product_validator.dart';

//https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
class AddProductPage extends StatefulWidget {
  final void Function()? onCallBack;
  const AddProductPage({super.key, required this.onCallBack});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  static const String _testImg = "assets/images/product.png";
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<ImageSource> _galleries = [];
  List<Product> _originProducts = [];
  bool _submittable = true;
  bool _isAvtHover = false;

  Future<void> onAddProduct() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      var user =
          Provider.of<AuthStateProvider>(context, listen: false).currentUser;
      //validate data
      var price = double.tryParse(_priceController.text);

      List<String> imgPaths = [];
      if (_galleries.isNotEmpty) {
        final mediaRequests = _galleries.map((e) {
          return saveMediaFile(authorId: user!.id, file: File(e.path));
        }).toList();

        var avtPath = await mediaRequests[0];
        if (avtPath.isSuccess) {
          imgPaths.add(avtPath.data!);
        }
        mediaRequests.removeAt(0);

        var galleryPaths = await Future.wait(mediaRequests);

        for (var path in galleryPaths) {
          if (path.isSuccess) {
            imgPaths.add(path.data!);
          }
        }
      }

      // print("Origin now ${json.encode(_originProducts)}");

      final model = AddProductModel(
        name: _nameController.text,
        description: _descriptionController.text,
        price: price ?? 0,
        discount: 0,
        galleryPaths: imgPaths,
        supplierId: user!.id,
        originKeys: {for (var item in _originProducts) item.id: ''},
      );

      var rs = await addProduct(model);

      if (rs.isSuccess) {
        // print("Added Success");
        Navigator.pop(context);
        Navigator.pop(context);
        widget.onCallBack!();
      } else {
        throw new Exception(rs.errorMessage);
      }
    } catch (e) {
      print(">>Sending Error: ${e}");
      Navigator.pop(context);
      showNotificationMessage(
          context, "Something went wrong. Please try again");
    }
  }

  String? onValidate(bool isSuccess, String message) {
    if (!isSuccess) {
      // setState(() {
      //   _submittable = false;
      // });
      return message;
    } else {
      // setState(() {
      //   _submittable = false;
      // });
      return null;
    }
  }

  void onAddOriginProduct(Product product) {
    _originProducts.add(product);
    setState(() {});
  }

  Widget _buildImageAddingSection(BuildContext context) {
    var globaleSize = MediaQuery.of(context).size;
    final owner =
        Provider.of<AuthStateProvider>(context, listen: false).currentUser;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            // print("Go to select image");

            final rs = await showImagePicker();

            // print("Got ${rs.length} item(s)");
            if (rs.isNotEmpty) {
              final files = rs.map((x) {
                return ImageSource(path: x.path, type: ImageType.file);
              }).toList();

              _galleries.insert(0,files.first);
              setState(() {});
            }

            // var rs = await Navigator.push<List<AssetEntity>>(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ImageSelectorPage(),
            //   ),
            // );
            // // print("Selected ${rs?.length ?? 0} asset");
            // if (rs != null && rs.isNotEmpty) {
            //   var file = await rs[0].file;
            //   if (file != null) {
            //     _galleries.insert(
            //         0, ImageSource(path: file.path, type: ImageType.file));
            //     setState(() {});
            //   }
            // }
          },
          onHover: (value) => setState(() {
            _isAvtHover = true;
          }),
          child: Stack(
            children: [
              Container(
                width: globaleSize.width / 5 * 3,
                height: globaleSize.width / 5 * 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                  image: DecorationImage(
                      image: _galleries.isNotEmpty
                          ? _galleries[0].toImageWidget().image
                          : const AssetImage(_testImg),
                      fit: BoxFit.cover),
                ),
              ),
              if (_isAvtHover)
                Container(
                  width: globaleSize.width / 5 * 3,
                  height: globaleSize.width / 5 * 3,
                  color: Colors.black.withOpacity(.5),
                  child: Center(
                    child: Text(
                      "+ Add image",
                      style: TextStyle(
                          color: Colors.grey[100],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                )
            ],
          ),
        ),
        EditableGallery(
          ownerId: owner!.id,
          modifiable: true,
          initImages: [],
          onAddFile: (file) {
            _galleries.add(file);
          },
          onClearAll: () {
            _galleries.removeRange(1, _galleries.length);
          },
          onRemoveFile: (file) {
            _galleries.remove(file);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Add new product profile here"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                // color: Colors.grey[300],
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.grey[800]),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                // color: ,
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    backgroundColor: Colors.lightGreen[100]),
                onPressed: _formKey.currentState?.validate() ?? false
                    ? () {
                        if (_formKey.currentState?.validate() == true) {
                          print("Sending....");
                          onAddProduct();
                        } else {
                          print("cannot send");
                          // setState(() {
                          //   submittable = false;
                          // });
                        }
                      }
                    : null,
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              children: [
                _buildImageAddingSection(context),
                const SizedBox(
                  height: 30,
                ),
                const DividerTitle(
                    content: Text(
                  "Product Name",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
                CustomFormTextfield(
                  controller: _nameController,
                  hintText: "Product Name",
                  obscureText: false,
                  validator: (value) {
                    var rs = ProductValidator.validateStringLength(
                        title: "Name",
                        content: value ?? "",
                        min: 5,
                        max: 20,
                        isRequire: true);

                    return onValidate(rs.isValid, rs.message);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const DividerTitle(
                    content: Text(
                  "Price (VND)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
                CustomFormTextfield(
                  controller: _priceController,
                  hintText: "Ex: 100000",
                  obscureText: false,
                  validator: (value) {
                    var rs1 = ProductValidator.validateStringLength(
                        title: "Price", content: value ?? "", isRequire: true);
                    var rs2 = ProductValidator.validatePrice(value);
                    var msg = [rs1.message, rs2.message];

                    return onValidate(rs1.isValid && rs2.isValid,
                        !rs1.isValid ? msg[0] : msg[1]);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const DividerTitle(
                    content: Text(
                  "Description (optional)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
                CustomFormTextfield(
                  controller: _descriptionController,
                  hintText: "Write description here",
                  obscureText: false,
                  validator: (value) {
                    var rs = ProductValidator.validateStringLength(
                        title: "Description", content: value ?? "", max: 1000);
                    return onValidate(rs.isValid, rs.message);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                //Origins section
                DividerTitle(
                    content: Text(
                  "From product (optional)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),

                ProductOriginField(
                  onAddOrigin: (value) => onAddOriginProduct(value),
                  onClearAll: () {
                    _originProducts.clear();
                    setState(() {});
                  },
                  originProducts: _originProducts,
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
