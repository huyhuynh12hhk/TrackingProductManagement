import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/images/asset_thumbnail.dart';
import 'package:tracking_app_v1/components/images/take_photo_view.dart';
import 'package:tracking_app_v1/providers/camera_provider.dart';

class SelectDeviceImageView extends StatefulWidget {
  final int maxSelected;
  const SelectDeviceImageView({super.key, required this.maxSelected});

  @override
  State<SelectDeviceImageView> createState() => _SelectDeviceImageViewState();
}

class _SelectDeviceImageViewState extends State<SelectDeviceImageView> {
  List<AssetEntity> assets = [];
  ValueNotifier<List<AssetEntity>> _selectedAssets =
      ValueNotifier<List<AssetEntity>>([]);
  bool isInit = true;

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  void toggleSelectedImage(AssetEntity image) {
    
    if (_selectedAssets.value.any(
      (element) => element.id == image.id,
    )) {
      _selectedAssets.value.remove(image);
    } else {
      if (_selectedAssets.value.length >= widget.maxSelected) {
        _selectedAssets.value.removeAt(0);
      }
      _selectedAssets.value.add(image);
    }

    // _selectedAssets.value = Set.from(_selectedAssets.value);
    setState(() {});
  }

  Future<void> _fetchAssets() async {
    if (isInit) {
      print("Start to fetch assets");
      assets = await PhotoManager.getAssetListRange(
        start: 0,
        end: 100000,
      );
      setState(() {
        isInit = false;
      });
    }
  }

  Widget _buildGallerySection(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: assets.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        final image = assets[index];
        return ValueListenableBuilder<List<AssetEntity>>(
          valueListenable: _selectedAssets,
          builder: (context, value, child) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              margin: const EdgeInsets.all(2.0),
              child: FutureBuilder(
                  future: image.file,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    bool isSelected = _selectedAssets.value.any(
                      (element) => element == image,
                    );
                    return AssetThumbnail(
                        isSelected: isSelected,
                        file: snapshot.data!,
                        asset: image,
                        onSelected: () => toggleSelectedImage(image),
                        onUnselected: () => toggleSelectedImage(image));
                  }),
            );
          },
        );
      },
    );
  }

  Widget _buildHeadToolBar(BuildContext context) {
    var cameras = Provider.of<CameraProvider>(context).cameras;
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Pick your images here",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  backgroundColor: Colors.grey[500],
                  foregroundColor: Colors.blue[800]),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePhotoView(cameras: cameras),
                    ));
              },
              child: Icon(
                Icons.camera_alt_sharp,
                size: 22,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            //header
            _buildHeadToolBar(context),
            Divider(),

            //gallery images
            _buildGallerySection(context),
          ],
        ),

        //button
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20),
            width: globalSize.width,
            height: globalSize.height / 10,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400]),
                      onPressed: _selectedAssets.value.length > 0
                          ? () {
                              Navigator.pop(
                                  context, _selectedAssets.value.toList());
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Text(
                            "Select ${_selectedAssets.value.length} image${_selectedAssets.value.length > 1 ? 's' : ""}"),
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
