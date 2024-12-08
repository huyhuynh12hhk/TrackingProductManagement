import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/constants/domain_type.dart';
import 'package:tracking_app_v1/models/image_source.dart';
import 'package:tracking_app_v1/models/responseTypes/relationship_item.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/pages/account/user_profile_page.dart';
import 'package:tracking_app_v1/services/users_service.dart';
import 'package:tracking_app_v1/utils/app_coverter.dart';

class FollowingSection extends StatefulWidget {
  final String userId;
  final bool isOwner;
  const FollowingSection(
      {super.key, required this.userId, required this.isOwner});

  @override
  State<FollowingSection> createState() => _FollowingSectionState();
}

class _FollowingSectionState extends State<FollowingSection> {
  List<RelationshipItem> _relationships = [];
  bool _isLoading = false;
  

  @override
  void initState() {
    // _fetchUserRelationships();
    _isLoading = true;
    super.initState();
  }

  Future<bool> _fetchUserRelationships() async {
    if (_isLoading) {
      // print("Start fetching");
      try {
        final rs = await getUserRelationships(widget.userId);

        if (rs.isSuccess) {
          _relationships.addAll(rs.data!);

          _isLoading = false;
          setState(() {});
          // print("Done");
          return true;
        }
      } catch (e) {
        print("Follow page Error: $e");
      }
    }
    // print("False");
    // await Future.delayed(Duration(seconds: 2));
    return false;
  }

  Widget _buildAddingSection(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return Column(
      children: [
        const Divider(),
        Container(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.black),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add new"),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(Icons.add)
                      ],
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: globalSize.width / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black),
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_2),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildListUserSection(
      BuildContext context, List<RelationshipItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final user = items[index].user;

        return Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //avatar
                    Container(
                      width: 50,
                      height: 50,
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                              image: user.avatarImage.isNotEmpty
                                  ? NetworkImage(ApiEndpoints.getImagePath(
                                      user.avatarImage))
                                  : const AssetImage(
                                      "assets/images/avatar.png"),
                              fit: BoxFit.cover)),
                    ),

                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserProfilePage(userProfile: user),
                              ));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //name
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.fullName,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),

                            //contact
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${user.email}",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 13,
                                        color: Colors.grey[700]),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
/*
              DropdownMenu(
                menuStyle: MenuStyle(

                ),
                onSelected: (value) {

                },
                initialSelection: items[index].type,
                width: 130,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
                enableFilter: false,
                trailingIcon: null,

                dropdownMenuEntries:
                    _followTypes.map((value) {
                  return DropdownMenuEntry(

                    value: value,
                    label: toPascalCase(value),
                  );
                }).toList(),
                enableSearch: false,
                // onChanged: (value) {},
              ),
*/
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: Colors.grey[700]!)
                ),
                child: widget.isOwner
                    ? DropdownButton<String>(
                        underline: null,

                        value: items[index].type,
                        alignment: Alignment.bottomCenter,
                        // dropdownColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        // menuWidth: 100,
                        // isExpanded: true,
                        // iconEnabledColor: Colors.blue,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        items: FollowTypes.map((String value) {
                          final label = RelationshipLabelConvert(value);
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: value,
                            child: Text(
                              label.keys.first,
                              style: TextStyle(
                                color: label.values.first
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      )
                    : 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // SizedBox(width: 0,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.all(10),
                          // width: 80,
                          // height: 30,
                          child: Text(
                            toPascalCase(items[index].type),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                      ],
                    ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _buildAddingSection(context),
          FutureBuilder(
              future: _fetchUserRelationships(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.data!) {
                  return _relationships.isNotEmpty
                      ? _buildListUserSection(context, _relationships)
                      : Center(
                          child: Text(
                            "No following user was found.",
                            style: TextStyle(
                              color: Colors.grey[500]!,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                }
                return Skeletonizer(
                    child: _buildListUserSection(
                        context,
                        List.generate(
                            5,
                            (i) => RelationshipItem(
                                user: UserProfile.empty(),
                                type: "follow"))));
                // return Column(
                //   children: [
                //     Text("On loading..."),
                //     CircularProgressIndicator()
                //   ],
                // );
              })
        ],
      ),
    );
  }
}
