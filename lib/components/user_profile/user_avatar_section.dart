import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/images/show_image_popup.dart';
import 'package:tracking_app_v1/constants/domain_type.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/utils/app_coverter.dart';

class UserAvatarSection extends StatefulWidget {
  final bool isOwner;
  final UserProfile userProfile;
  const UserAvatarSection(
      {super.key, required this.userProfile, required this.isOwner});

  @override
  State<UserAvatarSection> createState() => _UserAvatarSectionState();
}

class _UserAvatarSectionState extends State<UserAvatarSection> {
  

  // Widget _buildRelationshipTool() {
  //   return Container(
  //     width: 100,
  //     height: 50,
  //     child: const Row(
  //       children: [],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    ImageProvider<Object> bgImage = (widget.userProfile.backgroundImage.isEmpty
        ? const AssetImage('assets/images/bgimg.png')
        : NetworkImage(widget.userProfile.backgroundImage));
    return Container(
      height: 240,
      width: globalSize.width > 700 ? 700 : globalSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              //background
              GestureDetector(
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => const AlertDialog(
                  //     title: Text("Background image"),
                  //   ),

                  // );
                  showImagePopup(
                      context,
                      widget.userProfile.fullName,
                      widget.userProfile.id,
                      widget.userProfile.backgroundImage);
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height / 4.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey),
                      color: Colors.black,
                      image: DecorationImage(
                        image: bgImage,
                        colorFilter: const ColorFilter.mode(
                            Colors.black54, BlendMode.darken),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Positioned(
                bottom: -40,
                left: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //avatar
                    InkWell(
                      onTap: () {
                        showImagePopup(
                            context,
                            widget.userProfile.fullName,
                            widget.userProfile.id,
                            widget.userProfile.avatarImage);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[600]!)),
                        child: CircleAvatar(
                          radius: MediaQuery.sizeOf(context).width / 9,
                          backgroundColor: Colors.white,
                          backgroundImage: (widget
                                  .userProfile.avatarImage.isEmpty
                              ? const AssetImage('assets/images/avatar.png')
                              : NetworkImage(widget.userProfile.avatarImage)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),

                    SizedBox(
                      height: 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                          //user identity
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.shade200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              // currentUser.email!,
                              widget.userProfile.fullName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                      
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
