import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/custom_form_textfield.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/models/responseTypes/product.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/utils/product_validator.dart';

class ProductEditInfoModal extends StatefulWidget {
  final Product product;
  final void Function(Product) onConfirm;
  const ProductEditInfoModal(
      {super.key, required this.product, required this.onConfirm});

  @override
  State<ProductEditInfoModal> createState() => _ProductEditInfoModalState();
}

class _ProductEditInfoModalState extends State<ProductEditInfoModal> {
  final _nameField = TextEditingController();
  final _priceField = TextEditingController();
  final _descriptionField = TextEditingController();
  final _discountField = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? onValidate(bool isSuccess, String message) {
    if (!isSuccess) {
      return message;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Product"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DividerTitle(
                content: Text(
              "Product name",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            )),
            CustomFormTextfield(
              controller: _nameField,
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
            DividerTitle(
                content: Text(
              "Price (VND)",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            )),
            CustomFormTextfield(
              controller: _priceField,
              hintText: "Ex: 100000",
              obscureText: false,
              validator: (value) {
                var rs1 = ProductValidator.validateStringLength(
                    title: "Price", content: value ?? "", isRequire: true);
                var rs2 = ProductValidator.validatePrice(value);
                var msg = [rs1.message, rs2.message];

                return onValidate(
                    rs1.isValid && rs2.isValid, !rs1.isValid ? msg[0] : msg[1]);
              },
            ),
            DividerTitle(
                content: Text(
              "Description",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            )),
            CustomFormTextfield(
              controller: _descriptionField,
              initValue: widget.product.description,
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
          ],
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
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final oldProduct = widget.product;

                    final newProduct = Product(
                        supplier: UserProfile.cloneFrom(oldProduct.supplier),
                        id: oldProduct.id,
                        name: _nameField.text,
                        description: _descriptionField.text,
                        price: double.tryParse(_priceField.text)??oldProduct.price,
                        avatarImage: oldProduct.avatarImage,
                        discount: oldProduct.discount,
                        // discount: 0.2,
                        galleryPaths: oldProduct.galleryPaths);

                    Navigator.pop(context);
                    widget.onConfirm(newProduct);
                  }
                },
                child: const Text("Confirm")),
          ],
        ),
      ],
    );
  }
}
