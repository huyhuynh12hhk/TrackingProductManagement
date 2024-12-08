import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app_v1/components/common/divider_title.dart';
import 'package:tracking_app_v1/components/document_view/expandable_document.dart';
import 'package:tracking_app_v1/components/users/detail_box.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';

class UserIntroductionSection extends StatefulWidget {
  final bool isOwner;
  final UserProfile userProfile;
  final bool isLoading;
  // final Future<UserProfile?> Function() onFetchUser;
  const UserIntroductionSection(
      {super.key,
      required this.userProfile,
      required this.isLoading,
      this.isOwner = false});

  @override
  State<UserIntroductionSection> createState() =>
      _UserIntroductionSectionState();
}

class _UserIntroductionSectionState extends State<UserIntroductionSection> {
  Widget _buildInfoSection() {
    return Skeletonizer(
        enabled: widget.isLoading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DetailBox(
              section: "Email",
              content: widget.userProfile.email,
              editable: widget.isOwner,
              onPressed: () {},
            ),
            // DetailBox(
            //   section: "Description",
            //   content: widget.userProfile.description,
            //   onPressed: () {},
            // ),
            DetailBox(
              section: "Gender",
              content: widget.userProfile.gender.isEmpty
                  ? "Not set"
                  : widget.userProfile.gender,
              editable: widget.isOwner,
              onPressed: () {},
            ),
            DetailBox(
              section: "Address",
              content: widget.userProfile.address.isEmpty
                  ? "Not set"
                  : widget.userProfile.address,
              editable: widget.isOwner,
              onPressed: () {},
            ),
            DetailBox(
              section: "Phone number",
              content: widget.userProfile.phoneNumber.isEmpty
                  ? "Not set"
                  : widget.userProfile.phoneNumber,
              editable: widget.isOwner,
              onPressed: () {},
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var globalSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //highlight
            DividerTitle(
                content: Text("Story",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),

            Skeletonizer(
              enabled: widget.isLoading,
              child: Container(
                width: globalSize.width,
                decoration: BoxDecoration(
                    color: Colors.lightGreen.shade100,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ExpandableDocument(
                  content: widget.userProfile.description.isEmpty
                      ? "Not set"
                      : widget.userProfile.description,
                  maxLines: 3,
                ),
              ),
            ),

            //detail
            DividerTitle(
                content: Text("Information",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),

            // SizedBox(height: 10,),

            _buildInfoSection(),
          ],
        ),
      ),
    );
  }
}
